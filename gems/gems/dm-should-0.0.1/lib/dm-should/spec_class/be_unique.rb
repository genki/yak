module DataMapper::Should
  class BeUnique < SpecClass

    predicates do
      def be_unique(options={})
        BeUnique.new(@property, options)
      end
    end

    attr_reader :scopes 

    def initialize(property, options={})
      @property = property
      @options = options
      setup_scopes_of_uniqueness
    end

      def setup_scopes_of_uniqueness
        @scopes = @options[:scope] ?
          Array(@options[:scope]).map { |sym| @property.model.properties[sym] } :
          []
      end
      private :setup_scopes_of_uniqueness

    def translation_key
      spec_name = (!scopes.empty?) ? 
        "be_unique_within_scopes" : "be_unique"
    end

    def assigns
      super.update(:scopes => scope_list)
    end

      def scope_list
        scopes.map { |s| s.name.to_s }.join(",")
      end
      private :scope_list


    # TODO: Should some unique index at the layer of database ensure this?
    # In other words, where and how could I hanlde the exception about unique 
    # index of a database?
    def satisfy?(resource)
      conditions = { property.name => read_attribute(resource) }
      conditions.merge! :id.not => resource.id unless resource.new_record?

      scopes.each do |scope|
        conditions.merge! scope.name => scope.get(resource)
      end

      property.model.first(conditions).nil?
    end


  end
end
