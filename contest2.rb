require 'byebug'

module Suite
  module Test1
    class STDIN
      def self.read
        %{3
2 3
-1 -1
-1 -1
2
1
1}
      end
    end
  end

  module Test2
    class STDIN
      def self.read
        %{5
2 3
-1 4
-1 5
-1 -1
-1 -1
1
2}
      end
    end
  end
end

# Responsible for reading STDIN
class Reader
  # @param stdin input
  def initialize(stdin)
    @lines = stdin.read.split("\n")
  end

  def pairs
    @lines.slice(1, number_of_pairs).map do |line|
      line.split.map { |index| index.to_i }
    end
  end

  def swaps
    start = index_swaps_counter+1
    @lines.slice(start, number_of_swaps).map do |line|
      line.to_i
    end
  end

  private

  def number_of_pairs
    @lines[0].to_i
  end

  def index_swaps_counter
    number_of_pairs + 1
  end

  def number_of_swaps
    @lines[index_swaps_counter].to_i
  end
end

class Tree
  attr_reader :data
  attr_accessor :left, :right

  def initialize(x = nil)
    @data = x
  end

  def self.root
    Tree.new(1)
  end
end

module Insertable
  def insert(x,y)
    @left = Tree.new(x) if x > 0
    @right = Tree.new(y) if y > 0
  end
end

module Traversable
  def inorder(&block)
    left.inorder(&block) unless left.nil?
    yield self
    right.inorder(&block) unless right.nil?
  end

  def traverse(depth, &block)
    yield(self, depth)
    left.traverse(depth + 1, &block) unless left.nil?
    right.traverse(depth + 1, &block) unless right.nil?
  end
end

module Searchable
  def search(index)
    return self if data.eql? index
    (left && left.search(index)) || (right && right.search(index))
  end
end

module Swappable
  def swap
    node_left = @left
    @left = @right
    @right = node_left
    self
  end
end

Tree.include(Insertable, Traversable, Searchable, Swappable)

# Testing purpose

@reader = Reader.new(Suite::Test2::STDIN)
@tree = Tree.root

@reader.pairs.each_with_index do |pair, index|
  left, right = *pair
  node_index = index + 1
  node = @tree.search(node_index)
  node.insert(left, right) if node
end

@states = []

@reader.swaps.each do |swap|
  state = ''
  @tree.traverse(1) do |node, depth|
    if (depth % swap) == 0
      node.swap
      # if multiple bases fit a depth level we break to avoid reversion
      break
    end
  end
  @tree.inorder do |node|
    state += node.data.to_s
  end
  @states << state
end

print @states.join("\n")
