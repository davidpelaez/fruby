module Fruby
  module Syro
    module ErrorHelpers

      def not_found_error(msg='Not found')
        res.status = 404
        msg = { error: 'not_found', message: msg }
        json(msg) and finish_request
      end

      def invalid_data_error(msg: "Invalid params", errors: [])
        res.status = 422
        msg = { error: 'unprocessable_entity', message: msg , errors: errors}
        json(msg) and finish_request
      end

      def invalid_json_error(msg: "Invalid JSON", errors: [])
        res.status = 400
        msg = { error: 'bad_request', message: msg , errors: errors}
        json(msg) and finish_request
      end

      def unauthorized_error(msg='Unauthorized')
        res.status = 401
        msg = { error: 'unathorized', message: msg }
        json(msg) and finish_request
      end

    end
  end
end
