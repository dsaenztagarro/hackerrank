class Graph
  attr_reader :nvertices, :edges

  def initialize(nvertices, directed)
    @nvertices = nvertices
    @nedges = 0
    @vertices = []
    @edges = []
    init_vertices && init_edges
  end

  # Adds an edge to the graph
  # @param x [Fixnum] start node of edge
  # @param y [Fixnum] end node of edge
  def add_edge(x, y)
    @edges[x] ||= []
    @edges[x] = EdgeNode.new(y, 0)
    unless @directed
      @edges[y] ||= []
      @edges[y] << EdgeNode.new(x, 0)
    end
    @nedges += 1
  end

  protected

  def reset_vertices
    all_vertices.each { |x| @vertices[x].status = Vertex::UNDISCOVERED }
  end

  private

  def init_vertices
    @vertices << nil
    all_vertices.each { |x| @vertices[x] = Vertex.new }
  end

  def all_vertices
    (1..@nvertices).to_a
  end

  def init_edges
    @edges[@nvertices] = nil
  end
end
