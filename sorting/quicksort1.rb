module Suite
  module Test1
    class STDIN
      def self.read
        %(5
4 5 3 7 2)
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

  def initialize(array)
    @array = array
  end

  def sort
    value = @array.shift
    minor_values, major_values = [], []
    while (!@array.empty?) do
      item = @array.shift
      if item < value
        minor_values << item
      else
        major_values << item
      end
    end
    minor_values.concat([value]).concat(major_values)
  end
end

# Testing purpose
# @reader = Reader.new(Suite::Test1::STDIN)

@reader = Reader.new(STDIN)
@writer = Writer.new(STDOUT)

@sorter = Sorter.new(@reader.array)

@writer.add_line(@sorter.sort.join(' '))
@writer.print
