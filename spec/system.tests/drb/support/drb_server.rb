class DrbServer
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def start
    exe = File.join(File.dirname(__FILE__), "..", "bin", "server")
    
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
