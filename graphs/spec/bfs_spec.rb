require 'spec_helper'

class BfsGraph < Graph
  include Algorithm::BreathFirstSearch
  attr_reader :distances

  def initialize(*args)
    super
    @distances = []
    @nvertices.times { @distances = -1 }
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
        graph.traverse(tc.start_index)
        STDOUT.print graph.distances.join(' ') + '\n'
      end
    end
  end
end
