module Fruby
  class Operation
    StepData = Struct.new(:env, :meta, :data) do
      def respond_to?(x)
        super(x) || data.respond_to?(x)
      end

      def method_missing(method_sym, *args, &blk)
        data.send method_sym, *args, &blk
      end

      def next!(*args, &blk)
        self.class.new(env, meta, *args, &blk)
      end

      alias_method :to_hash, :data

      def inspect
        "#<StepData @env=#{env.inspect} @data=#{data.inspect} @meta=#{meta.inspect}>"
      end
    end
  end
end
