module Fruby
  module Processors
    class EnhancedAttributes < TransprocWithHook

      BlockWrapper = Struct.new(:block) do
        def call(*args)
          self.block.call *args
        end
      end

      ComputedAttribute = Class.new(BlockWrapper)

      module Fns
        extend Transproc::Registry
        extend Transproc::Composer

        import Transproc::Conditional
        import Transproc::HashTransformations
        import Transproc::ArrayTransformations

        def self.resolve_as_computed(x)
          -> atr { x.block.call(atr) }
        end

        def self.resolve_attribute(a)
          t(:is, EnhancedAttributes::ComputedAttribute, t(:resolve_as_computed))[a]
        end

        def self.eval_values_with_self(value)
          t(:eval_values, [value])[value]
        end

        def self.resolve_attributes(entity)
          compose do |ops|
            ops << Fns[:map_values, Fns[:resolve_attribute]]
            ops << Fns[:eval_values_with_self]
          end.call(entity)
        end
      end # Fns

      def post_transformer
        Fns[:resolve_attributes]
      end

    end # EnhancedAttributes
  end # Processors
end # Fruby
