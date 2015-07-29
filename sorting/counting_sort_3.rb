module Suite
  module Test1
    class STDIN
      def self.read
        %(10
4 that
3 be
0 to
1 be
5 question
1 or
2 not
4 is
2 to
4 the)
      end
    end
  end
end

class Cell
  attr_reader :value, :str

  def initialize(value, str)
    @value = value
    @str = str
  end
end

# Responsible for reading STDIN
class Reader
  attr_reader :array, :size

  # @param stdin input
  def initialize(stdin)
    @lines = stdin.read.split("\n")
		@array = @lines.slice(1..size_of_array).map do |line|
			data = line.split(' ')
			Cell.new(data[0].to_i, data[1])
		end
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
	attr_reader :count_list

  def initialize(array)
    @array = array
    @count_list = ZArray.new
  end

	def count_list
    @array.each do |cell|
			(cell.value..99).to_a.each do |index|
				@count_list[index] = (@count_list[index] || 0) + 1
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

@writer.add_line @sorter.count_list.join(' ')
@writer.print
