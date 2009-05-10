module DataMapper::Should
  class ErrorsOnProperty < PropertySpecs
    alias_method :error_messages, :translated_keys


    #@param <Hash> params
    #  :actual   the actual value added to assign values
    #  :property the scope of this Specs 

    def initialize(params)
      assert_kind_of "the arugument of ErrorsOnProperty.new", params, Hash
      unless [:actual, :property].all? { |key| params.has_key? key }
        raise "both params[:actual] and params[:property] are required"
      end
      @actual = params[:actual]
      super params[:property]
    end


    def self.translation_key(spec_class)
      "warn" + "." + super
    end

    def assigns(spec_class)
      spec_class.assigns.update(:actual => @actual.inspect)
    end

  end
end
