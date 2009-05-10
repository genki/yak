module DataMapper::Should
  class Match < SpecClass

    predicates do
      def match(regex)
        Match.new(regex, :property => @property)
      end
    end


    attr_reader :regex

    def initialize(regex, option={})
      assert_kind_of "an argument of DataMapper::Should::Match", regex, Regexp
      assert_kind_of "option[:property] of DataMapper::Should::Match", 
                     option[:property], DataMapper::Property
      @regex = regex
      super(option[:property])
    end


    def satisfy?(resource)
      !! read_attribute(resource).to_s.match(regex)
    end

  end
end
