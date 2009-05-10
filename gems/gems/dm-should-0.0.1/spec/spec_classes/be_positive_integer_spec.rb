require File.join(File.dirname(__FILE__) , %w[.. /spec_helper])

describe "when a [Integer] record.number should be positive integer, record.valid? returns .." do

  before do
    @record = BePositiveInteger1.new
  end
  attr_reader :record


  it "true  if record.number is numeric string" do
    record.number = "100"
    record.valid?.should be_true
  end


  it "true  if record.number is a Integer" do
    record.number = 100
    record.valid?.should be_true
  end


  it "false if record.number is a negative integer" do
    record.number = -100
    record.valid?.should be_false
  end
  

  # TODO: Think about this later.
  it "false if record.number isn't numeric string or a Integer now, even if it respond to #to_i method." do
    time = Time.now
    time.should respond_to(:to_i)
    time.to_i.should be_a(Integer)
    record.number = time
    record.valid?.should be_false
  end


  it "true  if record.number is nil and :nullable => true [default]" do
    record.valid?.should be_true
  end

  it "false if record.number is nil and :nullable => false" do
    record = BePositiveInteger2.new
    record.valid?.should be_false
  end
  
end
