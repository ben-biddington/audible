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

  it "fails to add a listener that does not respond to the right message" do
    a_bung_listener_with_no_update = Object.new

    expect{ an_audible_object.add_listener a_bung_listener_with_no_update }.to raise_error /Cannot add listener unless it responds to/
  end

  it "can be queried for the number of listeners" do
    expect(an_audible_object.listener_count).to eql 0

    an_audible_object.add_listener listener

    expect(an_audible_object.listener_count).to eql 1

    an_audible_object.delete_listener listener

    expect(an_audible_object.listener_count).to eql 0
  end
end
