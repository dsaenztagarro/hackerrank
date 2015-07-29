module Suite
  module Test1
    class STDIN
      def self.read
        %(100
63 25 73 1 98 73 56 84 86 57 16 83 8 25 81 56 9 53 98 67 99 12 83 89 80 91 39 86 76 85 74 39 25 90 59 10 94 32 44 3 89 30 27 79 46 96 27 32 18 21 92 69 81 40 40 34 68 78 24 87 42 69 23 41 78 22 6 90 99 89 50 30 20 1 43 3 70 95 33 46 44 9 69 48 33 60 65 16 82 67 61 32 21 79 75 75 13 87 70 33)
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

# Extends array providing default value 0 to all not initialized records
class ZArray < Array
  def [](x)
    if x > size
      for i in (size + 1..x)
        self[i] = 0
      end
    end
    v = super(x)
  end

  def []=(x, v)
    max = size
    super(x, v)
    if size - max > 1
      (max..size - 2).each do |i|
        self[i] = 0
      end
    end
  end
end

class Sorter
  def initialize(array)
    @array = array
    @count_list = ZArray.new
  end

  def sort
    numbers = []
    count_list.each_with_index do |item, index|
      number_of_repetitions = @count_list[index]
      number_of_repetitions.times { numbers << index }
    end
    numbers
  end

  private

	def count_list
    @array.each do |item|
      if @count_list[item]
        @count_list[item] += 1
      else
        @count_list[item] = 1
      end
    end
    @count_list
	end
end

# Testing purpose
# @reader = Reader.new(Suite::Test1::STDIN)

@reader = Reader.new(STDIN)
@writer = Writer.new(STDOUT)

@sorter = Sorter.new(@reader.array)
@writer.add_line @sorter.sort.join(' ')

@writer.print
