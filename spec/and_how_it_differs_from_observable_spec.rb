require "spec_helper"

describe "Observable" do
  let(:an_observable_object) do
    Class.new do
      require "observer"; include Observable

      def poke
        changed
        notify_observers(Time.now)
      end
    end.new
  end

  it "you can register for notifications" do
    an_observer = Class.new do
      def update(args)
        @notified = true
      end
      
      def notified?; @notified === true; end
    end.new
    
    an_observable_object.add_observer(an_observer)

    an_observable_object.poke

    an_observer.must be_notified
  end

  it "and you can send arguments with your notification" do
    an_observer = Class.new do
      def update(args)
        @args = args
      end
      
      def args; @args; end
    end.new
    
    an_observable_object.add_observer(an_observer)

    an_observable_object.poke

    an_observer.args.must_not be_nil 
  end
end
