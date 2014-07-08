require "spec_helper"

describe "The relayed notifications" do
  before :all do
    an_audible_object = Class.new do
      require "audible"; include Audible

      def poke; notify :poked, {:a => "1", :b => "2"}; end
    end.new

    a_relaying_class = Class.new do
      require "audible"; include Audible
      
      def initialize(inner)
        @inner = inner
        relay @inner, :poked
      end 
    end

    a_relaying_object = a_relaying_class.new(an_audible_object)

    a_relaying_object.on :poked do |e,args| 
      @relayed_notification,@relayed_args = e,args
    end

    an_audible_object.poke
  end

  it ("notifies with the same name")      { expect(@relayed_notification).to eql :poked }
  it ("notifies with the same arguments") { expect(@relayed_args.first).to eql({:a => "1", :b => "2"}) }
end

describe "You can rename the relayed notification to something else" do
  let :an_audible_object do 
    Class.new do
      require "audible"; include Audible

      def poke; notify :poked; end
    end.new
  end
  
  before do
    a_relaying_class = Class.new do
      require "audible"; include Audible
      
      def initialize(inner)
        relay inner, :poked, :as => :any_new_name
      end 
    end

    @a_relaying_object = a_relaying_class.new(an_audible_object)
  end

  it "notifies with the new name and suppresses the original" do
    @a_relaying_object.on :poked do |e,args| 
      fail "Expected the <:poked> notification to be suppressed"
    end

    @a_relaying_object.on :any_new_name do |e,args| 
      notified = true
    end

    notified = false

    an_audible_object.poke
    
    expect(:notified).to be_true, "Expected to be notified with <#{:any_new_name}>"
  end
end
