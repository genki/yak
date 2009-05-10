module DataMapper

  module Resource

    def valid?
      errors.clear!
      ensure_specs
      errors.empty?
    end
    alias_method :satisfy?, :valid?


    def errors
      @errors = Should::Errors.new(self) unless @errors
      @errors
    end

    def ensure_specs
      self.class.specs.each do |spec|
        spec.ensure(self)
      end
    end

    
    # TODO think carefully about :create and :update methods later. 
    def save_only_when_valid
      if valid?
        save_without_ensure
      else
        false
      end
    end
    alias_method :save_without_ensure, :save
    alias_method :save, :save_only_when_valid

  end
end

