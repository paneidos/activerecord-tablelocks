class AtomicInteger
  attr_reader :value

  def initialize
    @value = 0
    @mutex = Mutex.new
  end

  def increment
    @mutex.synchronize do
      @value = @value + 1
    end
  end
end