module DataMapper::Should

  class SpecClass

    attr_reader :property
    include ::Extlib::Assertions

    cattr_reader :subclasses 
    @@subclasses = []

    def self.inherited(klass)
      klass.class_eval do
        # setup default name
        name self.to_s.sub("DataMapper::Should::", "").snake_case.to_sym 
      end
      @@subclasses << klass
    end

    def self.name(new_value=nil)
      @name = new_value if new_value.is_a? Symbol
      @name
    end

    def self.predicates(&block)
      DataMapper::Should::AvailablePredicates.module_eval &block if block
    end

    def initialize(property)
      @property = property
    end

    def read_attribute(resource, options={})
      typecasted = property.get(resource)
      options[:before_typecast] ?
        property.get_before_typecast_value!(resource) :
        typecasted
    end

    # NOTE: All spec class could be ensured with this form?
    def ensure(resource)
      resource.errors.add self unless satisfy?(resource)
    end

    def satisfy?(resource)
      raise "implement #satisfy? method in each of subclasses"
    end

    def doc(additional_values={})
      Translation.translate(
        translation_key,
        assigns.update(additional_values))
    end

    def translation_key
      self.class.name.to_s
    end

    def field
      [@property.model, @property.name].map { |x| x.to_s }.join(".") 
    end

    def assigns
      { :field => field }
    end

    def inspect
      "\#<#{self.class} #{doc.inspect} >"
    end

  end

end
