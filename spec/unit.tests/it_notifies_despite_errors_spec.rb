require "spec_helper"

describe "You always get notified, even when another listener fails" do 
  let(:an_audible_object) do
     Class.new do
      require "audible"; include Audible

      def poke; notify :poked; end
    end.new
  end
    
  it "notifies despite prior error, AND raises the error" do 
    notified = false
    
    an_audible_object.on(:poked){|e,args| fail "This is supposed to fail" }
    an_audible_object.on(:poked){|e,args| notified = true }
   
    expect{an_audible_object.poke}.to raise_error /fail/
    
    expect(notified).to be_true
  end 
  
  it "only raises the first error" do
    an_audible_object.on(:poked){|e,args| fail "ERROR A" }
    an_audible_object.on(:poked){|e,args| fail "ERROR B" }
    an_audible_object.on(:poked){|e,args| fail "ERROR C" }
   
    expect{an_audible_object.poke}.to raise_error /A/
  end
end