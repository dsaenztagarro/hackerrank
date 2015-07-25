require 'byebug'

class Tree
  attr_reader :data
  attr_accessor :left, :right

  def initialize(x = nil)
    @data = x
  end

  def insert(x)
    if @data.nil?
      @data = x
    elsif @left.nil?
      @left = Tree.new(x)
    elsif @right.nil?
      @right = Tree.new(x)
    else
      list = [@left, @right]
      loop do
        node = list.shift
        if node.left.nil?
          node.insert(x)
          break
        else
          list << node.left
        end
        if node.right.nil?
          node.insert(x)
          break
        else
          list << node.right
        end
      end
    end
  end

  def traverse
    list = []
    yield @data
    list << @left if @left != nil
    list << @right if @right != nil
    loop do
      break if list.empty?
      node = list.shift
      yield node.data
      list << node.left unless node.left.nil?
      list << node.right unless node.right.nil?
    end
  end
end

@items = [1, 2, 3, 4, 5, 6, 7]
@tree = Tree.new
@items.each { |x| @tree.insert(x) }
@tree.traverse { |x| print "#{x} " }
print "\n"