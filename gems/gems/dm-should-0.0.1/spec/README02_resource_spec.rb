require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/rdoc_helper'

h3 "02: DataMapper::Resource (Instance methods) with dm-should" do
  h4 "valid? method" do
    before(:each) {  @item = Item.new  }
    attr_reader :item

    it "should return +true+ if a record satisfy its specs and +false+ if it doesn't" do

      item.valid?.should be_false

      item.name = "Name"
      item.valid?.should be_true

    end

    it "a record shouldn't be saved when valid? returns +false+" do
      Item.auto_migrate!

      item.valid?.should be_false
      proc { item.save }.should_not change(Item,:count)

      item.name = "Name"
      item.valid?.should be_true
      proc { item.save }.should change(Item, :count).by(1)

    end

  end
end

h4 "errors method" do
  before(:each) {  @record = Item.new  }
  attr_reader :record

  it "should return an instance of <tt>DataMapper::Should::Errors</tt>."  do
    record.errors.should be_a(DataMapper::Should::Errors)
  end

  it "Once valid? method executed and return +false+, record.errors has details about it" do
    record.valid?
    record.errors.empty?.should == false
  end

  it "You can generate error messages by passing a block to +translation_keys_each+ method:
    record.errors.translation_keys_each do |translation_key, assigns|
      your_translation_system.translate(translation_key, assigns)
    end

  The arguments of the block is +translation_key+ and +assigns+:
  [<b>translation_key</b>]
    a translation_key is kind of 'warn.be_present' or 'warn.be_unique'.
    They are combinations of 'doctype.spectype'.
  [<b>assigns[:field]</b>]
    is now a +String+ like 'Modelname.fieldname'. this is also supposed to be translated 
  [<b>assigns[:actual]</b>]
    is an actual value at the recently validated field 
  " do 
    record.valid?
    record.errors.translation_keys_each do |translation_key, assigns|
      translation_key.should == "warn.be_present"
      assigns.should have_key(:actual)
      assigns.should have_key(:field)
      assigns[:field].should == "Item.name"
    end
  end

  it "Or, You can simply use <tt>record.error.error_messages</tt> to get translated error message with default translation system
    record.errors.error_messages
    # => [\"Item.name was expected to be present, but it wasn't\"] 
  You can customize the default message set. See <tt>DataMapper::Should::Translation.translations</tt>.  
  " do
   record.valid? 
   record.errors.error_messages.should be_an(Array)
   record.errors.error_messages.should include("Item.name was expected to be present, but it wasn't")
  end
end
