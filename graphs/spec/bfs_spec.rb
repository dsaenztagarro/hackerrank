require 'spec_helper'

class BfsGraph < Graph
  include Algorithm::BreathFirstSearch
  attr_reader :distances

  def initialize(*args)
    super
    @distances = []
    all_vertices.each { |x| @distances[x] = -1 }
  end

  def hook_process_start_vertex(start)
    @distances[start] = 0
  end

  def hook_process_edge(x, y)
    if @distances[x] >= 0 && @distances[y] < 0
      @distances[y] = @distances[x] + 6
    elsif @distances[y] >= 0 && distances[x] < 0
      @distances[x] = @distances[y] + 6
    end
  end
end

describe BfsGraph do
  context 'stdin1.txt' do
    let(:stdin_file){ 'stdin1.txt' }

    it 'returns expected output' do
      allow(STDIN).to receive(:read).and_return(
        File.read(File.join('spec', 'fixtures', stdin_file)))

      @reader = Reader.new(STDIN)
      @reader.each_testcase do |tc|
        graph = BfsGraph.new(tc.number_of_nodes, false)
        tc.edges.each { |edge| graph.add_edge(edge.x, edge.y) }
        graph.traverse(tc.start_index)
        STDOUT.print graph.distances.select { |dist| dist != 0 }.join(' ') + '\n'
      end
    end
  end
end
