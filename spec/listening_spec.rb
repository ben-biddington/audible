require "spec_helper"

describe "An audible object" do
  it "notifies of the event I ask for" do
    an_audible_class = Class.new do
      require "audible"; include Audible

      def poke
        notify :poked
      end
    end

    instance = an_audible_class.new

    notified = false

    instance.on :poked do
      notified = true
    end

    instance.poke

    notified.must be_true
  end

  it "fails if the event does not match a supported one" do
    an_audible_class = Class.new do
      require "audible"; include Audible

      def poke
        notify :poked
      end

      protected

      def accepts?(e);
        [:poked].include? e
      end
    end

    instance = an_audible_class.new

    expect{instance.on(:xxx_does_not_exist_xxx){}}.to raise_error /Event .+ not supported/
  end
end
