module Types
  Dry::Data.configure { |c| c.namespace = ::Types }
  Dry::Data.finalize

  class CallableStruct < Dry::Data::Struct
    include Procto.call
    class << self
      alias_method :[], :call
    end

    # class << self
    #   def [](input)
    #     self.new input
    #   end
    #   alias_method :call, :[]
    # end
  end

end
