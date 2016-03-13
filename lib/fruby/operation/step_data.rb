module Fruby
  class Operation
    StepData = Struct.new(:env, :meta, :hash) do
      def respond_to?(x)
        super(x) || hash.respond_to?(x)
      end

      def method_missing(method_sym, *args, &blk)
        hash.send method_sym, *args, &blk
      end

      def next!(*args, &blk)
        self.class.new env, meta, *args, &blk
      end

      alias_method :to_hash, :hash

      def inspect
        "#<StepData @env=#{env.inspect} @hash=#{hash.inspect} @meta=#{meta.inspect}>"
      end
    end
  end
end
