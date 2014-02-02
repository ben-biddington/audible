require "spec_helper"

describe "Basic drb connections" do
  before :all do
    exe = File.join(File.dirname(__FILE__), "bin", "server")
    
    @pid = Process.spawn "bundle exec ruby #{exe}"
  end

  after :all do
    Process.kill("HUP", @pid)
    Process.wait
  end

  it "tells me the time" do
    require 'drb/drb'

    DRb.start_service

    timeserver = DRbObject.new_with_uri "druby://127.0.0.1:9999"

    expect(timeserver.get_current_time).to_not be_nil
  end
end
