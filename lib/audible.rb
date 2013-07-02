dirname = File.expand_path File.dirname(__FILE__)

Dir.glob(File.join(dirname, "audible", "**", "*.rb")).each{|f| require f}
