require_relative 'container/functions'

module Fruby
  class Operation
    class Container
      include Dry::Container::Mixin
      def t(*args)
        ContainerFunctions[*args]
      end
    end
  end
end
