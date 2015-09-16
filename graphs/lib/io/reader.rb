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
