require "spec_helper"

describe "You can listen for all events" do
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

  it "by subscribing as a listener" do
    an_audible_object.add_listener(self)
    
    an_audible_object.poke
    an_audible_object.tap

    expect(self).to be_poked
    expect(self).to be_tapped
  end

  def poked?; @poked; end
  def tapped?; @tapped; end

  def update(e)
    @poked = true if e[:event] == :poked
    @tapped = true if e[:event] == :tapped
  end
end
