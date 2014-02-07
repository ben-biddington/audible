class Listeners
  def initialize
    @listeners = []
  end

  def add(listener)
    fail "Cannot add the same listener more than once" if exists? listener
    
    listeners << listener
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
