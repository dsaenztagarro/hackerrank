module Suite
  module Test1
    class STDIN
      def self.read
        %(7
1 3 9 8 2 7 5)
      end
    end
  end
end

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
  end

	def sort
		quicksort(0, @array.length - 1)
	end

	private

  def quicksort(lo, hi)
    if lo < hi
      p = partition(lo, hi)
      quicksort(lo, p - 1)
      quicksort(p + 1, hi)
    end
  end

	def partition(lo, hi)
		pivot_value = @array[hi]
		store_index = lo
		(lo..hi - 1).to_a.each do |index|
			if @array[index] < pivot_value
				swap(index, store_index)
				store_index += 1
			end
		end
    swap(store_index, hi)
    @writer.add_line @array.join(' ')
    store_index
	end

	def swap(x, y)
		tmp = @array[x]
		@array[x] = @array[y]
		@array[y] = tmp
	end
end

# Testing purpose
# @reader = Reader.new(Suite::Test1::STDIN)

@reader = Reader.new(STDIN)
@writer = Writer.new(STDOUT)

@sorter = Sorter.new(@reader.array, @writer)
@sorter.sort

@writer.print
