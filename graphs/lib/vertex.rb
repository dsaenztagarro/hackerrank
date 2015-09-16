# Represents a vertex of a graph
class Vertex
  attr_accessor :id, :status, :parent, :edges

  UNDISCOVERED = 1
  DISCOVERED = 2
  PROCESSED = 3

  def initialize
    @status = UNDISCOVERED
    @edges = []
  end

  def update_attributes(opts)
    @status = opts[:status] || @status
    @parent = opts[:parent] || @parent
  end

  def undiscovered?
    @status == UNDISCOVERED
  end

  def discovered?
    @status == DISCOVERED
  end

  def processed?
    @status == PROCESSED
  end

  def add_edge(y, weight)
    @edges << EdgeNode.new(y, weight)
  end

  def each_edge
    @edges.each { |edge| yield(edge) }
  end
end
