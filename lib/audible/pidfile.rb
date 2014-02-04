class Pidfile
  require "fileutils"; extend FileUtils

  class << self
    def new(pid=$$)
      File.open path, "w" do |f|
        f.puts pid
      end
    end

    def missing?; false == exists? end
    def exists?; File.exists? path; end
    def delete; rm path; end
    def path; File.join ".", ".pid"; end
  end
end
