module DataMapper
  module Should
    module AvailablePredicates
    end

    class SpecCollector
      include AvailablePredicates

      def self.collect(property, spec_proc)
        obj = self.new(property)
        obj.instance_eval &spec_proc if spec_proc.is_a? Proc
        obj.collected
      end

      def initialize(property)
        unless property.is_a? Property
          raise "the argument of SpecCollector.new should be an Property"
        end
        @property = property
        @specs = []
      end

      def should(spec)
        @specs << spec
      end

      def collected
        @specs
      end

    end
  end
end
