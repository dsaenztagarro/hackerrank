# Represents each testcase from STDIN
class TestCase
  attr_reader :number_of_nodes, :edges, :start_index

  def initialize(number_of_nodes, edges, start_index)
    @number_of_nodes = number_of_nodes
    @edges = edges
    @start_index = start_index
  end
end
