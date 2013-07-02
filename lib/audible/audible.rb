module Audible
  def on(event, &block)
    listeners_for(event) << block if block_given?
  end

  protected

  def notify(event, *args)
    listeners_for(event).each do |listener|
      listener.call event, args
    end
  end

  def accepts?(e); accept_all_by_default end

  private

  def accept_all_by_default; true; end

  def listeners_for(event)
    fail "Event <#{event}> not supported by #{self.class}." unless accepts?(event) === true
    listeners[event] = [] unless listeners.has_key? event
    listeners[event]
  end

  def listeners; @listeners ||= {}; end
end
