require 'kleisli'
module Types
  class Nothing
    extend Dry::Data::TypeBuilder
    class << self
      def call(input)
        input.nil? ? Kleisli::Maybe::None.new : input
      end

      def try(input)
        call(input)
      end

      def valid?(input)
        input.nil? || input.is_a?(Kleisli::Maybe::None)
      end

      alias_method :[], :call
    end
  end
end

Dry::Data.register "types.nothing", Types::Nothing

# module Types
#   class FlatMaybe
#     extend Dry::Data::TypeBuilder
#     class << self
#       def call(input)
#         binding.pry
#         input.nil? ? Kleisli::Maybe::None.new : Maybe(input)
#       end
#
#       def try(input)
#         call(input)
#       end
#
#       def valid?(input)
#         input.nil? || input.is_a?(Kleisli::Maybe::None)
#       end
#
#       alias_method :[], :call
#     end
#   end
# end
#
# Dry::Data.register "types.nothing", Types::Nothing
