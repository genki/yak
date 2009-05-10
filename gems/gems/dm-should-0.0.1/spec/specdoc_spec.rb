require File.dirname(__FILE__) + '/spec_helper'

describe "model.specdoc" do

  before(:all) do
    SpecDoc2.auto_migrate!
  end

  subject { SpecDoc2.specdoc }

  it "should provide the specdoc of model" do 
    # print subject
    should include("- should be present")
    should include("- should be unique")
    should include("- should be a positive number")
  end

  it "should contain all property names" do
    should include("id:")
    should include("number:")
    should include("number2:")
  end

end
