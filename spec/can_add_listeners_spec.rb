require "spec_helper"

describe "Adding listeners" do
  let(:an_audible_object) do
     an_audible_class = Class.new do
      require "audible"; include Audible

      def poke; notify :poked ; end
      def tap(args ={}) ; notify :tapped, args; end

      protected

      def accepts?(e);
        [:poked,:tapped].include? e
      end
    end.new
  end

  it "works by calling update, just like Observable" do
    listener = Class.new do
      def initialize
        @notified = false
      end

      def update(args)
        @notified = true
      end

      def notified?
        @notified
      end
    end.new

    an_audible_object.add_listener listener

    an_audible_object.poke

    expect(listener).to be_notified
  end

  it "you get the event name and the args, just like ordinary notifications"
  it "you cannot add the same object twice"
  it "shall we check that listener responds to the right message?"
  it "you can delete listeners too which makes notifications stop"
  it "you can query for the number of listeners -- that way we can tell unsubscribe works"
end
