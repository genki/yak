require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/top" do
  before(:each) do
    @response = request("/")
  end

  it "should respond successfully" do
    @response.should be_successful
  end
end
