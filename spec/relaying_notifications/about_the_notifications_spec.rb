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
