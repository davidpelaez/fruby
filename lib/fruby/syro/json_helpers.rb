module Fruby
  module Syro
    module JSONHelpers

      def json(model)
        res[Rack::CONTENT_TYPE] = "application/json; charset=utf-8"
        model_meta = model.delete(:meta){|k| {} }
        final_meta = model_meta.merge metadata
        model_with_meta = model.merge meta: final_meta
        final_data = Functions[:prepare_for_json][model_with_meta]
        res.write Oj.dump(final_data)
      end

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
      end # Functions

    end # JSONHelpers
  end # Syro
end # Fruby
