# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "audible"
  gem.homepage = "http://github.com/ben-biddington/audible"
  gem.license = "MIT"
  gem.summary = %Q{Object communications}
  gem.description = %Q{Object communications}
  gem.email = "ben.biddington@gmail.com"
  gem.authors = ["Ben Biddington"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "audible #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:unit_tests)

task :default => :unit_tests
