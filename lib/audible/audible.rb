module Audible
  def on(*events, &block)
    events.each{|e| attach(e, &block)}
  end

  def add_listener(object)
    listeners.add object
  end

  def delete_listener(object)
    listeners.delete object
  end

  def relay(source, event, opts ={})
    name = opts[:as] || event
    source.on(event){|e,args| notify name, args.first}
  end

  protected

  def attach(event,&block)
    fail no_way_to_notify unless block_given?

    callbacks_for(event) << block
  end

  def notify(event, *args)
    callbacks_for(event).each do |callback|
      callback.call event, args
    end

    listeners.each{|listener| listener.update({:event => event, :args => args})}
  end

  def accepts?(e); accept_all_by_default; end

  private

  def no_way_to_notify
    "No block supplied. How will I notify you?"
  end

  def accept_all_by_default; true; end

  def callbacks_for(event)
    fail "Event <#{event}> not supported by #{self.class}." unless accepts?(event) === true
    callbacks[event] = [] unless callbacks.has_key? event
    callbacks[event]
  end

  def callbacks; @callbacks ||= {}; end
  def listeners; @listeners ||= Listeners.new; end
end
