module Fruby
  class Operation
    class ModuleContainer < Container

      attr_reader :namespace

      def initialize(ns, *args, &block)
        super(*args, &block)
        @namespace = ns
        register_constants
      end

      def keys
        @_container.keys
      end

      private

      def register_constants
        namespace.constants.map do |c|
          register c.downcase, t(:constantize, namespace)[c]
        end
      end

    end # ModuleContainer
  end # Operation
end # Fruby
