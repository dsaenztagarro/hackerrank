require 'spec_helper'

class BfsGraph < Graph
  include Algorithm::BreathFirstSearch
  attr_reader :distances

  def initialize(*args)
    super
    @distances = []
    vertices_indexes.each { |x| @distances[x] = -1 }
  end

  def read_distances
    @distances.compact.select { |dist| dist != 0 }.join(' ')
  end

  private

  def process_vertex_start(start)
    @distances[start] = 0
  end

  def process_edge(x, y)
    if @distances[x] >= 0 && @distances[y] < 0
      @distances[y] = @distances[x] + 6
    elsif @distances[y] >= 0 && distances[x] < 0
      @distances[x] = @distances[y] + 6
    end
  end
end

shared_examples 'expected stdout' do |stdin_file, stdout_file|
  let(:stdin_text) { File.read(File.join('spec', 'fixtures', stdin_file)) }
  let(:stdout_text) { File.read(File.join('spec', 'fixtures', stdout_file)) }

  it 'returns expected output' do
    allow(STDIN).to receive(:read).and_return(stdin_text)

    @reader = Reader.new(STDIN)
    @reader.each_testcase do |tc|
      graph = BfsGraph.new(tc.number_of_nodes, false)
      tc.edges.each { |edge| graph.add_edge(edge.x, edge.y) }
      graph.traverse(tc.start_index)
      result = graph.read_distances
      expect(stdout_text.index(result).eql? 0).to be true
    end
  end
end

describe BfsGraph do
  it_behaves_like 'expected stdout', 'bfs_stdin1.txt', 'bfs_stdout1.txt'
  it_behaves_like 'expected stdout', 'bfs_stdin2.txt', 'bfs_stdout2.txt'
end
