class Listeners
  def initialize
    @listeners = []
  end

  def add(listener)
    fail "Cannot add the same listener more than once" if exists? listener
    
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

  def exists?(listener)
    listeners.any?{|l| l === listener}
  end

  attr_reader :listeners
end
