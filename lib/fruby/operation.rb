module Fruby
  class Operation

    def self.from(options={}, &block)
      namespace = options.delete :namespace
      raise "Missing :namespace" unless namespace
      container = ModuleContainer.new namespace
      CallSheet options.merge({container: container}), &block
    end

  end
end

require_relative 'operation/abstract_env'
require_relative 'operation/step_data'
require_relative 'operation/container'
require_relative 'operation/module_container'
require_relative 'operation/wildcard_listener'
