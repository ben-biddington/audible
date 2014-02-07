class Listeners
  def initialize
    @listeners = []
  end

  def add(listener)
    verify listener

    listeners << listener
  end

  def delete(listener)
    the_one_to_delete = listeners.find{|l| l === listener}
    fail "Cannot delete something that was not listening" if the_one_to_delete.nil?
    listeners.delete the_one_to_delete
  end

  def each(&block)
    listeners.each {|listener| block.call listener}
  end

  private

  def verify(listener)
    must_not_exist_already listener
    must_respond_to_right_message listener
  end

  def must_not_exist_already(listener)
    fail "Cannot add the same listener more than once" if exists? listener
  end
  
  def must_respond_to_right_message(listener)
    it_responds_correctly = listener.respond_to?(:update) and listener.method(:update).arity === 1
    fail "Cannot add listener unless it responds to update with arity one" unless it_responds_correctly
  end
  
  def exists?(listener)
    listeners.any?{|l| l === listener}
  end

  attr_reader :listeners
end
