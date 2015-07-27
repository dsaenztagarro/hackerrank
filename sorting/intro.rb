module Suite
  module Test1
    class STDIN
      def self.read
        %(4
6
1 4 5 7 9 12)
      end
    end
  end
end

# Responsible for reading STDIN
class Reader
  attr_reader :array, :size, :value

  # @param stdin input
  def initialize(stdin)
    @lines = stdin.read.split("\n")
    @pointer = 0
    @value = read_num
    @size = read_num
    @array = @lines[@pointer].split(' ').slice(0, @size).map(&:to_i)
  end

  def each_testcase
    testcases.each { |testcase| yield testcase }
  end

  private

  def testcases
    number_of_testcases.times { read_testcase }
    @testcases
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
  def initialize(array, value)
    @array = array
    @value = value
  end

  def find_index
    @array.each_with_index do |item, index|
      return index if @value == item
    end
  end
end

# Testing purpose
@reader = Reader.new(Suite::Test1::STDIN)

# @reader = Reader.new(STDIN)
@writer = Writer.new(STDOUT)

index = Sorter.new(@reader.array, @reader.value).find_index

@writer.add_line(index)
@writer.print
