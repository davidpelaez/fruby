require 'logger'

module Fruby
  class Operation

    class WildcardListener
      attr_reader :logger

      def initialize(logger = Logger.new(STDOUT))
        @logger = logger
      end

      def method_missing(event, *data)
        logger.info "#{event}: #{data}"
      end

      def respond_to?(x)
        true
      end
    end

  end # Operations
end # Fruby
