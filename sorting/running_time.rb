module Suite
  module Test1
    class STDIN
      def self.read
        %(5
2 1 3 1 2)
      end
    end
  end
end

module ArrayExtensions
  refine Array do
    def reverse_each_with_index(&block)
      (0..length).reverse_each do |index|
        block.call self[index], index
      end
    end

    def reverse_each_with_index_from(max, &block)
      (0..max).reverse_each do |j|
        block.call self[j], j
      end
    end
  end
end

using ArrayExtensions

# Responsible for reading STDIN
class Reader
  attr_reader :array, :size

  # @param stdin input
  def initialize(stdin)
    @lines = stdin.read.split("\n")
    @array = @lines[1].split(' ').slice(0, size_of_array).map(&:to_i)
  end

  private

  def size_of_array
    @lines[0].to_i
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

class Sorter
  attr_reader :shifts_count

  def initialize(array, writer)
    @array = array
    @writer = writer
    @shifts_count = 0
  end

  def sort
    (1..@array.length - 1).each { |size| sort_item(size) }
  end

  private

  def sort_item(size)
    value = @array[size]
    @array.reverse_each_with_index_from(size) do |item, index|
      before_item = @array[index - 1] if index > 0
      if index == 0 || before_item <= value
        @array[index] = value
        break
      else
        @array[index] = before_item
        @shifts_count += 1
      end
    end
  end

  def save_state
    @writer.add_line @array.join(' ')
  end
end

# Testing purpose
# @reader = Reader.new(Suite::Test1::STDIN)

@reader = Reader.new(STDIN)
@writer = Writer.new(STDOUT)

@sorter = Sorter.new(@reader.array, @writer)
@sorter.sort

@writer.add_line(@sorter.shifts_count)
@writer.print
