require 'byebug'

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

  def initialize(array, writer)
    @array = array
    @writer = writer
  end

  def sort_ar
    sort(@array)
  end

  private

  def sort(array)
    value = array.shift
    minor_values, major_values = [], []
    while (!array.empty?) do
      item = array.shift
      if item < value
        minor_values << item
      else
        major_values << item
      end
    end

    sorted_minor = minor_values.size < 2 ? minor_values : sort(minor_values)
    sorted_major = major_values.size < 2 ? major_values : sort(major_values)
    ar = sorted_minor.concat([value]).concat(sorted_major)
    @writer.add_line ar.join(' ')
    ar
  end
end

# Testing purpose
@reader = Reader.new(Suite::Test1::STDIN)

# @reader = Reader.new(STDIN)
@writer = Writer.new(STDOUT)

@sorter = Sorter.new(@reader.array, @writer)
@sorter.sort_ar

@writer.print
