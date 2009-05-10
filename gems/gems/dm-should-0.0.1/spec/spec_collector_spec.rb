require File.dirname(__FILE__) + '/spec_helper'

class ItemWithoutSpec
  include DataMapper::Resource
  property :name, String
end

describe DataMapper::Should::SpecCollector do

  it "should collect spec from given proc" do
    spec_proc = proc do
      should be_present
    end
    # It shouldn't do no more than just returns array of collected specs on a
    # particullar property.
    # There is no need to pass SpecCollection of a model.
    # Passing a property class to this method is needed because each of spec
    # classes should have a reference to a proeprty class.
    # So, it isnt passed for modifying something. In other words, 
    # Neither a model or a SpecCollection is supposed to be changed by this method.  
    collected = DataMapper::Should::SpecCollector.collect(ItemWithoutSpec.properties[:name], spec_proc)
    collected.should be_an(Array)
    collected.should have(1).member
    collected[0].should be_a(DataMapper::Should::BePresent)
  end

end
