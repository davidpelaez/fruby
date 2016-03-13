module Fruby
  module Syro
    module RequestHelpers

      def finish_request
        halt(res.finish)
      end

      def parse_body
        body = req.body.read
        inbox.merge! Oj.load(body) unless body.empty?
      end

      def parse_params
          inbox.merge! t(:symbolize_keys)[req.params]
      end

    end
  end
end
