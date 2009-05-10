require File.dirname(__FILE__) + '/spec_helper'

describe DataMapper::Should::Translation do
  
  describe ".raw" do 
    it "should returns sentence not yet translated" do
      raw = DS::Translation.raw("warn.be_present")
      raw.should be_a(String)
      raw.should include("%{field}")
      raw.should include("%{actual}")
    end
  end

  describe ".translate" do

    it "whose argument could be a scope string" do
      DS::Translation.translate("specdoc.be_present")
    end

    it "whose argument could be a spec class" do

      # 1. use SpecClass#translation_key with default prefix ( "specdoc." )
      # 2. assigns SpecClass#assigns.
      
      spec_class = SpecDoc1.specs[0]
      full = DS::Translation.translate("specdoc.be_present", spec_class.assigns)
      DS::Translation.translate(spec_class).should == full

    end

    it "should add defalt prefix to scope if needed" do
      full = DS::Translation.translate("specdoc.be_present")
      DS::Translation.translate("be_present").should == full
    end

  end

end

describe "a SpecClass should respond to" do
  subject {  SpecDoc1.specs[0] }

  it "#translation_key" do
    subject.translation_key.should == "be_present"
  end

  it "#assgins" do
    subject.assigns.should == { :field => "SpecDoc1.number" }
  end

  it "#doc" do

    full = DS::Translation.translate(subject)
    subject.doc.should == full

    # this method is used when #inspect and exist mainly for displaying more
    # information when developping .  
   
  end

end

