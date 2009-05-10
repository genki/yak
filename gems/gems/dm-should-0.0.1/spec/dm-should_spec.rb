require File.dirname(__FILE__) + '/spec_helper'

describe "DataMapper::Resource with dm-should" do

  subject do
    @record
  end

  before do
    @record = Item.new
  end


  it "should respond_to #ensure_specs" do
    should respond_to(:ensure_specs)
  end

  it "#ensure_specs should executed when #valid?" do
    @record.should_receive(:ensure_specs)
    @record.valid?
  end

  it "should have a DataMapper::Should::Errors as #errors" do
    @record.errors.should be_a(DataMapper::Should::Errors)
  end


  it "should be saved only when valid" do
    Item.auto_migrate!

    # Not saved when invalid
    @record.valid?.should be_false
    proc { @record.save }.should_not change(Item, :count) 

    # Saved when valid
    @record.name = ":name is present"
    @record.valid?.should be_true
    proc { @record.save }.should change(Item, :count).from(0).to(1)
  end

end

describe "Datamapper::Model with dm-should" do

  it "should have a DataMapper::Should::Specs as specs" do
    Item.specs.should be_a(DataMapper::Should::Specs)
  end

end

describe "SpecClasses of DataMapper::Should" do

  it "should has its symbolized name as an attribute" do
    DataMapper::Should::BePresent.name.should == :be_present
    DataMapper::Should::BeInteger.name.should == :be_integer
    DataMapper::Should::BeUnique.name.should == :be_unique
  end

  it "could ensure itself of a given resource" do
    item = Item.new
    Item.specs[0].ensure(item)
    item.errors.should_not be_empty 
    item.errors.all? { |spec| spec.satisfy?(item) == false }.should be

    item = Item.new
    item.name = "satisfy"
    Item.specs[0].ensure(item)
    item.errors.should be_empty

    item = Item2.new
    item.name = "satisfy"
    Item2.specs[0].ensure(item)
    item.errors.should be_empty
    Item2.specs[1].ensure(item)
    item.errors.should_not be_empty 
  end

end
