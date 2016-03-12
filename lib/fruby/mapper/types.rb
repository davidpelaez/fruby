#require 'rom-mapper'

module Fruby
  class Mapper
    module Types

      RequiredAttributeError = Class.new(StandardError) do
        def initialize
          super "nil was given as value for a required attribute"
        end
      end

      extend ::Transproc::Registry

      # By marking a mapper attribute as type: :optional this will be called
      # the value of the attribute will be explicitely set to nil and its key will
      # be present in the final hash sent to the mapper's model class constructor
      def self.to_optional(x)
        x || nil
      end

      # def self.to_maybe(x)
      #   Types::Nothing[x]
      # end

      def self.to_required(x)
        raise RequiredAttributeError.new if x.nil?
        x
      end
    end # Types

    ROM::Processor::Transproc::Functions.import Types

  end # Mapper
end # Fruby
