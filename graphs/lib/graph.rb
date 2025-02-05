class Graph
  attr_reader :nvertices, :edges

  def initialize(nvertices, directed)
    @nvertices = nvertices
    @nedges = 0
    init_vertices
  end

  # Adds an edge to the graph
  # @param x [Fixnum] start node of edge
  # @param y [Fixnum] end node of edge
  def add_edge(x, y)
    @vertices[x].add_edge(y, 0)
    @vertices[y].add_edge(x, 0) unless @directed
    @nedges += 1
  end

  protected

  def reset_vertices
    each_vertice { |vertice| vertice.status = Vertex::UNDISCOVERED }
  end

  private

  def init_vertices
    @vertices = []
    vertices_indexes.each { |i| @vertices[i] = Vertex.new }
  end

  def each_vertice
    vertices_indexes.each { |x| yield(@vertices[x]) }
  end

  def vertices_indexes
    (1..@nvertices).to_a
  end
end
