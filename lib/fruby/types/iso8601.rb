require 'time'

module Types
  class ISO8601

    extend Dry::Data::TypeBuilder

    class << self

      def call(input)
        return input if input.is_a? ::DateTime
        ::DateTime.iso8601 input
      rescue ArgumentError
        raise Dry::Data::ConstraintError, "#{input.inspect} violates constraints"
      end

      def try(input)
        call(input)
      end

      def valid?(input)
        binding.pry
      end

      alias_method :[], :call

    end

  end

end

Dry::Data.register "types.iso8601", Types::ISO8601
