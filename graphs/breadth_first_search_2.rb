require 'benchmark'

module Suite
  module Test1
    class STDIN
      def self.read
        %{1
4 2
1 2
1 3
1}
      end
    end
  end

  module Test2
    class STDIN
      def self.read
        File.open('./graphs/fixtures/breadth_first_search_stdin1.txt').read
      end
    end
  end
end

# Responsible for reading STDIN
class Reader
  # @param stdin input
  def initialize(stdin)
    @lines = stdin.read.split("\n")
    @pointer = 0
    @testcases = []
  end

  def each_testcase
    testcases.each { |testcase| yield testcase }
  end

  private

  def testcases
    number_of_testcases.times { read_testcase }
    @testcases
  end

  def number_of_testcases
    read_num
  end

  def read_testcase
    edges = []
    number_of_nodes, number_of_edges = read_pair
    number_of_edges.times { edges << Edge.new(*read_pair) }
    start_index = read_num
    @testcases << TestCase.new(number_of_nodes, edges, start_index)
  end

  # Read one line with two space separated integers
  def read_pair
    list = @lines[@pointer].split(' ').map(&:to_i)
    inc_pointer
    list
  end

  def read_num
    num = @lines[@pointer].to_i
    inc_pointer
    num
  end

  def inc_pointer
    @pointer += 1
  end
end

class TestCase
  attr_reader :number_of_nodes, :edges, :start_index

  def initialize(number_of_nodes, edges, start_index)
    @number_of_nodes = number_of_nodes
    @edges = edges
    @start_index = start_index
  end
end

class Writer
  def initialize(stdout)
    @stdout = stdout
    @lines = []
  end

  def add_line(line)
    @lines << line
  end

  def print
    @stdout.print @lines.join("\n")
  end
end

class Edge
  attr_accessor :src, :dst, :length

  def initialize(src, dst, length = 1)
    @src = src
    @dst = dst
    @length = length
  end
end

class Graph < Array
  attr_reader :edges

  def initialize
    @edges = []
  end

  def connect(src, dst, length = 1)
    unless self.include?(src)
      raise ArgumentError, "No such vertex: #{src}"
    end
    unless self.include?(dst)
      raise ArgumentError, "No such vertex: #{dst}"
    end
    @edges.push Edge.new(src, dst, length)
  end

  def connect_mutually(vertex1, vertex2, length = 1)
    self.connect vertex1, vertex2, length
    self.connect vertex2, vertex1, length
  end

  def neighbors(vertex)
    neighbors = []
    @edges.each do |edge|
      neighbors.push edge.dst if edge.src == vertex
    end
    return neighbors.uniq
  end

  def length_between(src, dst)
    @edges.each do |edge|
      return edge.length if edge.src == src and edge.dst == dst
    end
    nil
  end

  def dijkstra(src, dst = nil)
    distances = {}
    previouses = {}
    self.each do |vertex|
      distances[vertex] = nil # Infinity
      previouses[vertex] = nil
    end
    distances[src] = 0
    vertices = self.clone
    until vertices.empty?
      nearest_vertex = vertices.inject do |a, b|
        next b unless distances[a]
        next a unless distances[b]
        next a if distances[a] < distances[b]
        b
      end
      break unless distances[nearest_vertex] # Infinity
      if dst and nearest_vertex == dst
        return distances[dst]
      end
      neighbors = vertices.neighbors(nearest_vertex)
      neighbors.each do |vertex|
        alt = distances[nearest_vertex] + vertices.length_between(nearest_vertex, vertex)
        if distances[vertex].nil? or alt < distances[vertex]
          distances[vertex] = alt
          previouses[vertices] = nearest_vertex
          # decrease-key v in Q # ???
        end
      end
      vertices.delete nearest_vertex
    end
    if dst
      return nil
    else
      return distances
    end
  end
end

# Testing purpose
@reader = Reader.new(Suite::Test2::STDIN)

# @reader = Reader.new(STDIN)
@writer = Writer.new(STDOUT)

@reader.each_testcase do |obj|
  # Build graph
  Benchmark.bm(10) do |x|

    x.report("Build:") do
      @graph = Graph.new
      (1..obj.number_of_nodes).each { |node| @graph.push node }
      obj.edges.each { |edge| @graph.connect_mutually edge.src, edge.dst, 6 }
    end

    # Calculate distances
    @distances = (2..obj.number_of_nodes).map do |node|
      x.report("Distances (#{node}:") do
        dist = @graph.dijkstra(1, node)
        dist || -1
      end
    end

    # Print results
    x.report('Print:') do
      @writer.add_line @distances.join(' ')
    end
  end
end

@writer.print
