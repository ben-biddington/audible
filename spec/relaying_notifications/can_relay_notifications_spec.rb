require "spec_helper"

describe "Relaying notifications" do
  let(:an_audible_object) do
     an_audible_class = Class.new do
      require "audible"; include Audible

      def poke; notify :poked ; end
      def tap ; notify :tapped; end

      protected

      def accepts?(e);
        [:poked,:tapped].include? e
      end
    end.new
  end

  let(:a_relaying_class) do
    Class.new do
      require "audible"; include Audible
      
      def initialize(inner)
        @inner = inner
        relay @inner, :poked
      end 
    end
  end

  it "can be asked to relay requests" do
    notified = false

    a_relaying_object = a_relaying_class.new(an_audible_object)

    a_relaying_object.on(:poked){ notified = true } 

    an_audible_object.poke

    expect(notified).to be_true, "Expected the notification to have been relayed"
  end
end
