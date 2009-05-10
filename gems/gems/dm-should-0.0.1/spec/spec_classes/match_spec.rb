require File.join(File.dirname(__FILE__) , %w[.. /spec_helper])

describe "When a [String] record.name should match /^A/, record.valid? returns" do

  before do
    @record = Match1.new
  end
  attr_reader :record

  it "true  if record.name is Apple" do
    record.name = "Apple"
    record.valid?.should be_true
  end

  it "false if record.name is Orange" do
    record.name = "Orange"
    record.valid?.should be_false
  end

  it "false if record.name is nil because nil is typecasted to_s " do
    record.valid?.should be_false
  end

end
