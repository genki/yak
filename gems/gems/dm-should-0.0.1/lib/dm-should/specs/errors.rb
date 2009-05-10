module DataMapper::Should
  class Errors < ModelSpecs

    alias_method :errors, :specs
    alias_method :errors_mash, :specs_mash
    alias_method :record, :scope

    attr_writer :specs_mash
    private :specs_mash=
    alias_method :errors_mash=, :specs_mash=


    def initialize(record)
      assert_kind_of "scope of Errors", record, DataMapper::Resource
      super record.class 
      @model = @scope
      @scope = record
    end

      def new_property_specs(spec)
        ErrorsOnProperty.new(:actual => spec.property.get(record), :property => spec.property)
      end
      private :new_property_specs


    def empty?
      errors.empty?
    end


    def clear!
      errors.clear
      self.errors_mash = Mash.new
    end


    def each(&block)
      errors.each(&block)
    end

    include Enumerable


    alias_method :error_messages, :translated_keys

    def translation_keys_each
      if block_given?
        map do |spec_class|
          yield self.class.translation_key(spec_class), assigns(spec_class)
        end
      end
    end

    def self.translation_key(spec_class)
      "warn" + "." + super
    end

    def assigns(spec_class)
      actual = spec_class.read_attribute(record)
      spec_class.assigns.update(:actual => actual.inspect)
    end

  end

end

