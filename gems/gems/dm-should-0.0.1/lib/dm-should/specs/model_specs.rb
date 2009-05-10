module DataMapper::Should
  class ModelSpecs < Specs

    # Only ModelSpecs has specs as a Mash in addition to the specs Array.
    attr_reader :specs_mash
    alias_method :model, :scope

    def initialize(scope)
      assert_kind_of "scope of ModelSpecs", scope, DataMapper::Model
      super
      @specs_mash = Mash.new
    end

    def add(new_specs)
      add_to_specs new_specs
      add_to_specs_mash new_specs
    end
    alias_method :<<, :add

      def add_to_specs(new_specs)
        specs << new_specs
        specs.flatten!
      end
      private :add_to_specs

      def add_to_specs_mash(new_specs)
        Array(new_specs).each do |spec|
          key = spec.property.name
          unless specs_mash.has_key? key
            specs_mash[key] = new_property_specs(spec)
          end
          specs_mash[key] << spec
        end
      end
      private :add_to_specs_mash

      def new_property_specs(spec)
        PropertySpecs.new(spec.property)
      end
      private :new_property_specs


    def [](key)
      case key
        when Fixnum; specs[key]
        when String,Symbol; specs_mash[key]
        when DataMapper::Property; specs_mash[key.name]
      end
    end
    alias_method :on, :[]

    def to_mash
      specs_mash.dup
    end

    def pretty_print(pp)
      pp.object_address_group self do
        pp.breakable
        pp.text "@specs_mash="
        pp.group 1 do
          pp.breakable
          pp.pp_hash specs_mash
        end
      end
    end
      
  end
end
