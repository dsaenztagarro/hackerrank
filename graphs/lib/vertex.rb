# Represents a vertex of a graph
class Vertex
  attr_accessor :status, :parent

  UNDISCOVERED = 1
  DISCOVERED = 2
  PROCESSED = 3

  def initialize
    @status = UNDISCOVERED
  end

  def discovered?
    @status = DISCOVERED
  end

  def processed?
    @status == PROCESSED
  end
end
