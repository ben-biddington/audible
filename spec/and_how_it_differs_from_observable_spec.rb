require "spec_helper"

describe "Observable" do
  let(:an_observable_object) do
    Class.new do
      require "observer"; include Observable

      def poke
        changed
        notify_observers
      end
    end.new
  end

  it "you can register for notifications" do
    an_observer = Class.new do
      def update
        @notified = true
      end
      
      def notified?; @notified === true; end
    end.new
    
    an_observable_object.add_observer(an_observer)

    an_observable_object.poke

    an_observer.must be_notified
  end
end
