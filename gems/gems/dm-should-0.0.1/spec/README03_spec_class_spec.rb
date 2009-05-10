require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/rdoc_helper'

h3 "03: Specs Class and SpecClass of dm-should" do

  h4 "What is Specs?
For example, when you have an Item class like this:
  class Item
    include DataMapper::Resource
    property :id, Serial
    property_with_spec :name, String do
      should be_present
      should be_unique
      should match(/^A/)
    end
  end
  " do  

    before :all do
  class Item3
    include DataMapper::Resource
    property :id, Serial
    property_with_spec :name, String do
      should be_present
      should be_unique
      should match(/^A/)
    end
  end
      Item3.auto_migrate!
    end

    before :each do
      @record = Item3.new
    end
    attr_reader :record
    
    it "<tt>Item.specs</tt> is an instance of <tt>DataMapper::Should::ModelSpecs</tt>,

  its class is a child class of <tt>DataMapper::Should::Specs</tt>.
    " do
      Item.specs.should be_an_instance_of(DS::ModelSpecs)
      DS::ModelSpecs.superclass.should == DS::Specs
    end

    it "<tt>Item.specs.on(:name)</tt> is an instance of <tt>DataMapper::Should::PropertySpecs</tt>,

  its class is a child class of <tt>DataMapper::Should::Specs</tt>.
    " do
      Item.specs.on(:name).should be_an_instance_of(DS::PropertySpecs)
      DS::PropertySpecs.superclass.should == DS::Specs
    end

    it "<tt>record.errors</tt> is an instance of <tt>DataMapper::Should::Errors</tt>,

  its class is a child class of <tt>DataMapper::Should::ModelSpecs</tt>.
    " do
      record.valid?
      record.errors.should be_an_instance_of(DS::Errors)
      DS::Errors.superclass.should == DS::ModelSpecs
    end

    it "<tt>record.errors.on(:name)</tt> is an instance of <tt>DataMapper::Should::ErrorsOnProperty</tt>,

  its class is a child class of <tt>DataMapper::Should::PropertySpecs.</tt>
    " do
      record.valid?
      record.errors.on(:name).should be_an_instance_of(DS::ErrorsOnProperty)
      DS::ErrorsOnProperty.superclass.should == DS::PropertySpecs
    end

    it "These <tt>DataMapper::Should::Specs</tt>'s subclasses stores objects of SpecClass" do
      Item.specs.each do |obj|
        obj.should be_a(DataMapper::Should::SpecClass)
      end

      Item.specs.on(:name).each do |obj|
        obj.should be_a(DataMapper::Should::SpecClass)
      end

      record.valid?
      record.errors.each do |obj|
        obj.should be_a(DataMapper::Should::SpecClass)
      end

      record.errors.on(:name).each do |obj|
        obj.should be_a(DataMapper::Should::SpecClass)
      end
    end

    it "You can access one of SpecClass of a Specs instance by <tt>[]</tt> method" do 
      Item3.specs.on(:name)[0].should be_a(DS::BePresent)
      Item3.specs.on(:name)[1].should be_a(DS::BeUnique)
      Item3.specs.on(:name)[2].should be_a(DS::Match)
    end

  end
end

h4 "What is SpecClass?

[There are #{DS::SpecClass.subclasses.size} subclasses now.]
#{DS::SpecClass.subclasses.map{|k| "  <tt>#{k.to_s}</tt>" }.join(",\n")}

" do
  it "They have <tt>satisfy?</tt> method to ensure themselves

  <tt>satisfy?</tt> method is sended when <tt>record.valid?</tt> .   
  " do 
    record = Item3.new
    spec = Item3.specs.on(:name)[0]
    spec.should be_a(DS::BePresent)
    spec.satisfy?(record).should be_false
    
    record.name = "present"
    spec.satisfy?(record).should be_true
  end
end

