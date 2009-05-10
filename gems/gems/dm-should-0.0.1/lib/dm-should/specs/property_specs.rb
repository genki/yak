module DataMapper::Should
  class PropertySpecs < Specs
    
    alias_method :property, :scope

    def initialize(scope)
      assert_kind_of "scope of PropertySpecs", scope, DataMapper::Property
      super
    end

  end
end
