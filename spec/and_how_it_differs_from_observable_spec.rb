require "spec_helper"

describe "Observable" do
  let(:an_observable_object) do
    Class.new do
      require "observer"; include Observable

      def poke
        changed
        notify_observers :poked
      end

      def tap
        changed
        notify_observers :tapped
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

    an_observer.args.must === :poked
  end

  it "for multiple events the observer must decide for themselves" do
    an_observer = Class.new do
      def initialize
        @poked,@tapped = 0,0
      end

      def update(args)
        @poked  = true if args === :poked
        @tapped = true if args === :tapped
      end
      
      def poked?; @poked === true; end
      def tapped?; @tapped === true; end
    end.new
    
    an_observable_object.add_observer(an_observer)

    an_observable_object.poke
    an_observable_object.tap

    an_observer.must be_tapped
    an_observer.must be_poked
  end

  it "notifications not sent if updated not called"
end
