module Fruby
  class Operation
    class Container
      module Functions
        #include Transproc::Helper
        extend Transproc::Registry
        # import all singleton methods from a module/class
        import Transproc::HashTransformations
        import Transproc::Conditional
        import Transproc::Coercions
        import Transproc::ArrayTransformations

        def self.constantize(c,ns="")
          c = Inflecto.camelize c
          target = [ns,c].join "::"
          Inflecto.constantize target
        rescue NameError
          return nil
        end

        def self.t(*args)
          self[*args]
        end

        # def self.as_mapper(value, mapper_class)
        #   mapper_class.build.call([value]).first
        # end

        def self.sanitize_as(value, mapper_class)
          mapper_class.call t(:symbolize_keys)[value]
          #(t(:symbolize_keys) >> t(:as_mapper,mapper_class))[value]
        end

        def self.validate_as(value, validator_class)
          result = validator_class.new.call value
          if result.failures.size > 0
            Left(result)
          else
            Right(value)
          end
        end
      end # Functions
    end # Container
  end # Operations
end # Fruby
