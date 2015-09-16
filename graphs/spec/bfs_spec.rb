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
  let :stdin do
    STDIN.stub(:read).with(File.read(File.join('spec', 'fixtures', stdin_file)))
  end
  let :reader do
    Reader.new(stdin)
  end

  context 'stdin1' do
    let(:stdin_file){ 'stdin1.txt' }

    it 'returns expected output' do
      reader.each_testcase do |testcase|
        graph = BfsGraph.new(testcase.number_of_nodes, false)
        graph.traverse
        STDOUT.print graph.distances.join(' ') + '\n'
      end
    end
  end
end
