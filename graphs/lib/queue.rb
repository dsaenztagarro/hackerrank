# Represents a priority queue
class Queue
  def initialize
    @list = []
  end

  # @param vertex [Fixnum] The number of vertex
  def enqueue(vertex)
    @list << vertex
  end

  # @return [Fixnum] The number of the vertex
  def dequeue
    @list.shift
  end

  def empty?
    @list.empty?
  end
end
