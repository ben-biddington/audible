require "spec_helper"

class BusyBody
  require "audible"; include Audible
  
  def go
    step_one
    step_two
    step_three
  end
  
  private

  %w{one two three}.each do |name|
    full_name = "step_#{name}".to_sym

    define_method(full_name){ notify full_name }
  end 
end

class LogSpy
  attr_reader :messages

  def initialize(what)
    @messages = []

    what.on :step_one do
      @messages << "Step 1"
    end

    what.on :step_two do
      @messages << "Step 2"
    end

    what.on :step_three do
      @messages << "Step 3"
    end
  end
end

describe BusyBody," and notifying instead of logging" do
  it "attach the log by notification rather than as dependency" do
    busy_body = BusyBody.new
    
    log = LogSpy.new busy_body

    busy_body.go

    log.messages.must == ["Step 1", "Step 2", "Step 3"]
  end
end
