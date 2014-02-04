require "spec_helper"

describe "Basic drb connections" do
  before :all do
    exe = File.join(File.dirname(__FILE__), "bin", "server")
    
    @pid = Process.spawn "bundle exec ruby #{exe}"

    sleep 5

    require 'drb/drb'

    DRb.start_service

    @timeserver = DRbObject.new_with_uri "druby://127.0.0.1:9999"
  end

  after :all do
    Process.kill("INT", @pid)
    Process.wait
  end

  it "tells me the time" do
    expect(@timeserver.get_current_time.to_s).to match /^#{Time.now.year}/
  end

  it "can notify" do
    an_observer = Class.new do
      def update(args)
        @notified = true
      end
      
      def notified?; @notified === true; end
    end.new
    
    @timeserver.add_observer an_observer

    @timeserver.progress
    
    expect(an_observer).to be_notified
  end
end
