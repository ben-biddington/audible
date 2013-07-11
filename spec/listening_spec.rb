require "spec_helper"

describe "An audible object" do
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

  it "notifies of the event I ask for" do
    notified = false

    an_audible_object.on :poked do
      notified = true
    end

    an_audible_object.poke

    notified.must be_true
  end

  it "fails if the event does not match a supported one" do
    expect{an_audible_object.on(:xxx_does_not_exist_xxx){}}.to raise_error /Event .+ not supported/
  end

  it "you can subscribe to multiple events at once and receive multiple notifications" do
    notifications = 0
    
    an_audible_object.on(:poked, :tapped) do
      notifications += 1
    end

    an_audible_object.poke
    an_audible_object.tap

    notifications.must === 2
  end

  # TEST: what about notification order?
end
