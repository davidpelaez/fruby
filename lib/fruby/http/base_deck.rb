module HTTP
  class BaseDeck < Syro::Deck


    module Functions
      #include Transproc::Helper
      extend Transproc::Registry
      extend Transproc::Composer
      # import all singleton methods from a module/class
      import Transproc::HashTransformations
      import Transproc::Conditional
      import Transproc::Recursion
      #import Transproc::ArrayTransformations

      def self.value_for_json(val)
        processor = compose do |fns|
          fns << t(:is, BigDecimal, -> x { x.to_f })
          fns << t(:is, DateTime, -> x { x.iso8601 })
          fns << t(:is, Kleisli::Maybe::None, -> x { nil })
          fns << t(:is, Kleisli::Maybe::Some, -> x { x.value })
        end
        processor[val]
      end

      def self.to_hash(h)
        t(:guard, -> s { s.respond_to?(:to_hash) }, -> s { s.to_hash })[h]
      end

      def self.prepare_for_json(val)
        hash_processors = compose do |fns|
          fns << t(:map_values, t(:to_hash))
          fns << t(:stringify_keys)
          fns << t(:map_values, t(:value_for_json))
        end
        #binding.pry
        t(:hash_recursion, hash_processors)[val]
      end

      def self.t(*args)
        self[*args]
      end
    end

    def process_write(operation:, input:)
      r = operation.call(input) do |m|
        m.success do |token|
          json output: token and finish_request
        end
        m.failure :validate do |validation|
          # Params validation failed?
          invalid_data_error errors: validation.messages
        end
        m.failure do |error|
          raise error
        end
      end
    end

    def process_read(operation:, input:)
      operation.call(input) do |m|
        m.success do |token|
          json output: token and finish_request
        end
        m.failure :validate do |error|
          # Params validation failed?
          invalid_data_error
        end
        m.failure :retrieve do |error|
          not_found_error if error.class == ROM::TupleCountMismatchError
        end
        m.failure do |error|
          raise error
       end
     end
    end

    def json(model)
      res[Rack::CONTENT_TYPE] = "application/json; charset=utf-8"
      model_with_meta = model.merge meta: metadata
      final_data = Functions[:prepare_for_json][model_with_meta]
      res.write Oj.dump(final_data)
    end

    def set_metadata(nmeta)
      metadata.merge! nmeta
    end

    def metadata
      @metadata ||= {}
    end

    def not_found_error(msg='Not found')
      res.status = 404
      msg = { error: 'not_found', message: msg }
      json(msg) and finish_request
    end

    def finish_request
      halt(res.finish)
    end

    def invalid_data_error(msg: "Invalid params", errors: [])
      res.status = 422
      msg = { error: 'unprocessable_entity', message: msg , errors: errors}
      json(msg) and finish_request
    end

    def parse_body
      body = req.body.read
      inbox.merge! Oj.load(body) unless body.empty?
    end

    def parse_params
        inbox.merge! Hashie.symbolize_keys(req.params)
    end

  end
end
