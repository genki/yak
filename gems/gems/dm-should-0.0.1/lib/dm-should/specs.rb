module DataMapper::Should
  class Specs

    include DataMapper::Assertions

    include TranslationRoleOfSpecs

    attr_reader :scope, :specs

    def initialize(scope)
      @scope = scope
      @specs = []
    end

    def add(new_specs)
      add_to_specs new_specs
    end
    alias_method :<<, :add

      def add_to_specs(new_specs)
        specs << new_specs
        specs.flatten!
      end
      private :add_to_specs


    def [](key)
      specs[key]
    end

    def to_a
      specs.dup
    end

    def each(&block)
      specs.each &block
    end

    include Enumerable

    def inspect
      "\#<#{self.class} @specs=#{@specs.inspect} >"
    end

    def pretty_print(pp)
      pp.object_address_group self do
        pp.group do
          pp.breakable
          pp.text "@specs="
          pp.group 1 do
            pp.seplist(specs, lambda { pp.text ',' }) do |v|
              pp.breakable
              pp.text v.inspect 
            end
          end
        end
      end
    end

  end
end
