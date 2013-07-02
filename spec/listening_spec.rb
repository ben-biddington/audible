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
end
