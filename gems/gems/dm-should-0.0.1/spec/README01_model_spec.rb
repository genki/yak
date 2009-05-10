require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/rdoc_helper'

h3 "01: DataMapper::Model (Class methods) with dm-should" do

  h4 "property_with_spec method" do

    it "should be defined in order to define specs of models" do
      Item.should respond_to(:property_with_spec)     
    end

    it "should be used like below:
    class Item1
      include DataMapper::Resource
      
      property :id, Serial
      property_with_spec :name, String do
        should be_present
      end
    end
    " do
    class Item1
      include DataMapper::Resource
      
      property :id, Serial
      property_with_spec :name, String do
        should be_present
      end
    end
     Item.specs.on(:name).first.should be_a(DataMapper::Should::BePresent)
    end

  end
end

h4 "Available predicates" do
  it "All available predicates are defined on <tt>DataMapper::Should::AvailablePredicates</tt> module" do
    klass = Class.new do
      include DS::AvailablePredicates
    end
    ins = klass.new

    ins.should respond_to(:be_unique)
    ins.should respond_to(:be_integer)

  end


  it "Available predicates means the methods could be used in +property_with_spec+ block\n\n" do
    proc do
      class Predicate
        include DataMapper::Resource
        property_with_spec :id, Serial do
          should be_present
          should be_unique
          should be_integer
        end
      end
    end.should_not raise_error
  end

end
