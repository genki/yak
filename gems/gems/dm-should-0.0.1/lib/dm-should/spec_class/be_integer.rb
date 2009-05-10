module DataMapper::Should
  class BeInteger < SpecClass
    predicates do
      def be_integer
        BeInteger.new(@property)
      end
    end

    # allow both positive and negative integers.
    def satisfy?(resource)
      value = read_attribute(resource, :before_typecast => true)
      return true if property.nullable? and value.nil?
      value.to_s.match(/^[\+-]?[0-9]+$/) != nil
    end

  end

  class BePositiveInteger < SpecClass
    predicates do
      def be_positive_integer
        BePositiveInteger.new(@property)
      end
    end

    # allow only positive integers.
    def satisfy?(resource)
      value = read_attribute(resource, :before_typecast => true)
      return true if property.nullable? and value.nil?
      value.to_s.match(/^\+?[0-9]+$/) != nil
    end

  end

end
