require "spec_helper"

class DrbServer
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def start
    exe = File.join(File.dirname(__FILE__), "bin", "server")
    
    @pid = Process.spawn "bundle exec ruby #{exe}", :err=>:out, :out => ".log"

    while Pidfile.missing?
      sleep 0.25
    end

    require 'drb/drb'

    DRb.start_service
  end

  def kill
    Process.kill("INT", @pid)
    Process.wait    
  end
end

describe "Basic drb connections" do
  before :all do
    @server = DrbServer.new("druby://127.0.0.1:9999").tap {|server| server.start}
    @timeserver = DRbObject.new_with_uri @server.url 
  end

  after :all do
    @server.kill
  end

  before do
    @an_observer = Class.new do
      def update(args)
        @notified = true
      end
      
      def notified?; @notified === true; end

      def reset; @notified = false; end
    end.new
  end

  it "tells me the time" do
    expect(@timeserver.get_current_time.to_s).to match /^#{Time.now.year}/
  end

  it "can notify" do
    @timeserver.add_observer @an_observer

    @timeserver.progress
    
    expect(@an_observer).to be_notified
  end

  it "can detach observer which stops notifications" do
    @timeserver.add_observer @an_observer

    @timeserver.progress
    
    expect(@an_observer).to be_notified

    @an_observer.reset

    @timeserver.delete_observer @an_observer

    @timeserver.progress
    
    expect(@an_observer).to_not be_notified
  end

  it "can also get audible notifications" do
    notified = false

    @timeserver.on(:progress) do |e,args|
      notified = true
    end

    @timeserver.progress

    expect(notified).to be_true
  end
end
