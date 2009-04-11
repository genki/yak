require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Users do
  describe "index" do
    before(:each) do
      @response = request("/users")
    end

    it "should respond successfully" do
      @response.should be_successful
    end
  end

  describe "show", :fixture => [:users, {:skip_filters => true}] do
    before(:each) do
      @response = request(resource(User.all.last))
    end

    it "should respond successfully" do
      @response.should be_successful
    end
  end
end
