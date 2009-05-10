# coding: UTF-8
require File.join(File.dirname(__FILE__) , %w[.. /spec_helper])

describe "when a [String] record.name should be present, record.valid? returns.." do

  before do
    @record = BePresent1.new
  end
  attr_reader :record

  it "false if record.name is nil" do
    record.valid?.should == false
  end

  it "false if record.name is empty string" do
    record.name = ""
    record.valid?.should == false
  end

  it "false if record.name only contains invisible string" do
    # 1 byte space
    record.name = "  "
    record.valid?.should == false

    # end line
    record.name = "\n\n"
    record.valid?.should == false

    # tab space
    record.name = "\t\t"
    record.valid?.should == false
  end

  it "false if record.name only contains invisible string ( including 2 byte space )" do
    # 2 byte space
    record.name = "　　" 
    record.valid?.should == false

    # combined
    record.name = " 　 　\t\n"
    record.valid?.should == false
  end

  it "true  if record.name is string that is not empty string." do
    record.name = "foo"
    record.valid?.should == true
  end

end

describe "when a [Integer] record.number should be present, record.valid? returns.." do

  before do
    @record = BePresent2.new
  end
  attr_reader :record

  it "false if record.number is nil" do
    record.valid?.should == false
  end

  it "false if record.number is empty string" do
    record.number = ""
    record.valid?.should == false
  end

  it "true  if record.number is numeric string" do
    record.number = "100"
    record.valid?.should == true
  end

  it "true  if record.number is a Fixnum" do
    record.number = 100
    record.valid?.should == true
  end

  it "true  if record.number is an Array" do
    record.number = [1,2,3]
    record.valid?.should == true
    proc do
      # It will produce a SQL error when actually trying to save the record.
      record.save
      record
    end.should raise_error
  end

end
