module Audible
  def on(*events, &block)
    events.each{|e| attach(e, &block)}
  end

  def relay(source, event)
    source.on(event){|e,args| notify event,args.first}
  end

  protected

  def attach(event,&block)
    fail no_way_to_notify unless block_given?

    listeners_for(event) << block
  end

  def notify(event, *args)
    listeners_for(event).each do |listener|
      listener.call event, args
    end
  end

  def accepts?(e); accept_all_by_default; end

  private

  def no_way_to_notify
    "No block supplied. How will I notify you?"
  end

  def accept_all_by_default; true; end

  def listeners_for(event)
    fail "Event <#{event}> not supported by #{self.class}." unless accepts?(event) === true
    listeners[event] = [] unless listeners.has_key? event
    listeners[event]
  end

  def listeners; @listeners ||= {}; end
end
