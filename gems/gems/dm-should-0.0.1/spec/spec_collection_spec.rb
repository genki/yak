require File.dirname(__FILE__) + '/spec_helper'

describe DataMapper::Should::Specs do
  subject { DS::Specs }

  describe "Available subclasses" do
    it "ModelSpecs" do
      should == DS::ModelSpecs.superclass
    end
    it "PropertySpecs" do
      should == DS::PropertySpecs.superclass
    end
    it "Errors" do
      should == DS::Errors.superclass.superclass
    end
    it "ErrorsOnProperty" do
      should == DS::ErrorsOnProperty.superclass.superclass
    end
  end

  describe "whose Role" do
    # use a PropertySpecs as a example.
    subject { SpecDoc1.specs.on(:number) }


    it "storing SpecClass instances" do
      subject.specs.should be_an(Array)
      subject.specs.each do |spec_class|
        spec_class.should be_a(DS::SpecClass)
      end
    end

    it "providing methods for specdoc generation" do
      subject.specdocs.first.should be_a(String)

      subject.translation_keys.first.should == "be_present"


      # this method is used in order to delegate another translation system
      # to generate docs. and I think this method should be mainly used.
      # TODO: it's better if the 2nd argument of the proc is a SpecClass
      # instead of assigns as a Hash already constructed.
      # I just prepare SpecClass#assgins to provide default assigns hash.
      
      subject.translation_keys_each do |translation_key, assigns|

        # translation scope to pass another translation system
        translation_key.should be_a(String)

        # assign values for translating
        assigns.should be_a(Hash)
        assigns.should have_key(:field)

      end
    end

  end 
end

describe DataMapper::Should::ModelSpecs do
  subject { SpecDoc2.specs }
  it "should be a subclass of DS::Specs" do
    should be_a(DS::Specs)
  end

  it "whose scope should be a model" do
    subject.scope.should == SpecDoc2
  end

  it "should have specs as a Mash in addition to the specs Array" do
    subject.specs_mash.should be_a(Mash)
  end

  it "should provide specs on a particular property" do
    subject.on(:number).should be_a(DS::PropertySpecs)
  end


  it "should privide specdoc of the model belongs to" do
    # pp subject.specdocs
    subject.specdocs.should be_an(Array)
  end

end

describe DataMapper::Should::PropertySpecs do
  subject { SpecDoc2.specs.on(:number) }

  it "should be a subclass of DS::Specs" do
    should be_a(DS::Specs)
  end

  it "whose scope should be a property" do
    subject.scope.should == SpecDoc2.properties[:number]
  end

  it "should provide specdoc of the property belongs to" do
    # pp subject.specdocs
    subject.specdocs
  end

end


describe DataMapper::Should::Errors do
  before(:all) do
    SpecDoc2.auto_migrate!
    @record = SpecDoc2.new
    record.valid?
  end
  attr_reader :record

  subject { record.errors }


  it "should be a subclass of DS::ModelSpecs" do
    subject.class.should == DS::Errors
    should be_a(DS::Specs)
    should be_a(DS::ModelSpecs) 
  end

  it "whose scope should be a record" do
    subject.scope.should be_a(DataMapper::Resource)
  end

  it "should provide error message using spec classes it has" do
    # pp subject.error_messages
    subject.error_messages.should have(3).items
  end

  it "should add prefix of translation scope" do
    subject.translation_keys_each do |translation_key, assigns|
      translation_key.should match(/^warn\./)
    end
  end

  it "should add actual value to assigns" do
    subject.translation_keys_each do |translation_key, assigns|
      assigns.should have_key(:actual)
      assigns[:actual].should == "nil"
    end
  end

end

describe DataMapper::Should::ErrorsOnProperty do
  before(:all) do
    SpecDoc2.auto_migrate!
    @record = SpecDoc2.new
    record.valid?
  end
  attr_reader :record

  subject { record.errors.on(:number) }

  it "should be a subclass of DS::Specs" do
    subject.class.should == DS::ErrorsOnProperty
    should be_a(DS::Specs)
  end

  it "should provide error message using spec classes it has" do
    # pp subject.error_messages
    subject.error_messages.should have(2).items
  end

  it "should add prefix of translation scope" do
    subject.translation_keys_each do |translation_key, assigns|
      translation_key.should match(/^warn\./)
    end
  end

  it "should add actual value to assigns" do
    subject.translation_keys_each do |translation_key, assigns|
      assigns.should have_key(:actual)
      assigns[:actual].should == "nil"
    end
  end

end
