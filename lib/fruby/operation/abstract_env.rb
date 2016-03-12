module Fruby
  class Operation
    class AbstractEnv
      include AbstractType
      abstract_method :logger
      abstract_method :storage
    end
  end
end
