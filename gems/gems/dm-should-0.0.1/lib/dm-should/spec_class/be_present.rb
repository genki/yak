module DataMapper::Should
  class BePresent < SpecClass

    predicates do
      def be_present
        BePresent.new(@property)
      end
    end


    def satisfy?(resource)
      read_attribute(resource).present?
    end

  end
end

# core ext for be_present
unless Object.respond_to? :present?
  class Object
    def present?
      !blank?
    end
  end
end

# support multi-byte space
class String
  MULTIBYTE_SPACE = [0x3000].pack("U").freeze

  def blank?
    self.gsub(MULTIBYTE_SPACE, "").strip.empty?
  end
end
