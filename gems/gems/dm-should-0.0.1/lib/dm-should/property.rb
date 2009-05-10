module DataMapper

  class Property
    include Extlib::Hook
    before(:set) do |resource, value| 
      set_before_typecast_value!(resource, value)
    end

    def before_typecast_variable_name
      :"@#{self.name}_before_typecast" 
    end

    def set_before_typecast_value!(resource, value)
      resource.instance_variable_set(
        before_typecast_variable_name, value)
    end

    def get_before_typecast_value!(resource)
      resource.instance_variable_get(
        before_typecast_variable_name)
    end

  end

end
