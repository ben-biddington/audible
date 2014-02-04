require "rspec"
require File.join ".", "lib", "audible"

Object.class_eval do
  alias :must :should
  alias :must_not :should_not
end
