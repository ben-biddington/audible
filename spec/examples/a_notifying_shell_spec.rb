require "spec_helper"

class Shell
  require "audible"; extend Audible
  
  class << self
    def exec(what)
      Open3.popen2(what, :err => [:child, :out]) do |i,o,t|
        o.each_line {|line| notify :progress, line}
      end
    end
  end
end

describe "An audible shell" do
  it "notifies for each line of output" do
    result = StringIO.new

    Shell.on :progress do |e, args|
      result.puts args.first
    end

    Shell.exec "ls -a"

    result.length.must be > 0
  end
end
