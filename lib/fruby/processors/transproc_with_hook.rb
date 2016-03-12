module Fruby
  module Processors

    class TransprocWithHook < ROM::Processor::Transproc
      def post_transformer
        Transproc::Coercions[:identity]
      end

      def visit(atr, *args)
        base_transformer = super(atr, *args)
        base_transformer >> post_transformer if base_transformer
      end
    end

  end # Processors
end # Fruby
