require "spec_helper"

describe "Adding listeners" do
  let(:an_audible_object) do
     an_audible_class = Class.new do
      require "audible"; include Audible

      def poke(args ={}); notify :poked, args ; end
      def tap(args ={}) ; notify :tapped, args; end

      protected

      def accepts?(e);
        [:poked,:tapped].include? e
      end
    end.new
  end

  let :listener do
    Class.new do
      def initialize
        @notified,@args = false,nil
      end

      def update(args)
        @notified = true
        @args = args
      end

      def notified?
        @notified
      end

      def notified_with?(opts ={})
        notified? and @args[:event] === opts[:event]
      end

      def reset; @notified = false; end
    end.new
  end

  it "works by calling update, just like Observable" do
    an_audible_object.add_listener listener

    an_audible_object.poke

    expect(listener).to be_notified
  end

  it "you cannot add the same object twice" do
    an_audible_object.add_listener listener
    expect{an_audible_object.add_listener listener}.to raise_error /Cannot add the same listener more than once/
  end

  it "you can delete listeners too which makes notifications stop" do
    an_audible_object.add_listener listener
    
    an_audible_object.poke

    expect(listener).to be_notified
    
    an_audible_object.delete_listener listener
    
    listener.reset

    expect(listener).to_not be_notified
  end

  it "fails to delete listener if it was never listening in the first place" do
    expect{ an_audible_object.delete_listener Object.new }.to raise_error /Cannot delete something that was not listening/
  end
  
  it "you get the event name and the args, just like ordinary notifications" do
    an_audible_object.add_listener listener
    
    an_audible_object.poke({:a => 1, :b => 2})

    expected_args = [{:a => 1, :b => 2}]

    expect(listener).to be_notified_with({:event => :poked, :args => expected_args})
  end

  it "shall we check that listener responds to the right message?"
  it "you can query for the number of listeners -- that way we can tell unsubscribe works"
end
