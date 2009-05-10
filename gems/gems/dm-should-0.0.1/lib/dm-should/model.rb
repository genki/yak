module DataMapper
  module Model
    
    def property_with_spec(*args, &block)
      pro = property(*args)
      specs << Should::SpecCollector.collect(pro, block)
    end


    # A Model class has A SpecCollection.
    def specs
      @specs = Should::ModelSpecs.new(self) unless @specs
      @specs
    end


    def specdoc
      doc = ""
      property_names = properties.map { |p| p.name }
      property_names.each do |name|
        doc << "#{name}:\n"
        if property_specs = specs.on(name)
          property_specs.translation_keys_each do |ts, assigns|
            doc << Should::Translation.translate(ts, assigns.update(:field => "-"))
            doc << "\n"
          end
        else
          doc << "- NO SPEC\n"
        end
      end
      doc
    end

  end

end
