require "spec_helper"

describe "An audible object" do
  let(:an_audible_object) do
     an_audible_class = Class.new do
      require "audible"; include Audible

      def poke
        notify :poked
      end

      protected

      def accepts?(e);
        [:poked].include? e
      end
    end.new
  end

  it "notifies of the event I ask for" do
    an_audible_object

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
end
