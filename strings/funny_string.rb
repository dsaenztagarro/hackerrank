module Suite
  module Test1
    class STDIN
      def self.read
        %{2
acxz
bcxz}
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

  def strings
    @lines.slice(1, number_of_strings)
  end

  private

  def number_of_strings
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

class Checker
  def initialize(str)
    @str = str
  end

  def check
    (1..number_of_comparisons).to_a.each do |index|
      return false if self.class.diff(index, @str) != self.class.diff(index, reverse)
    end
    true
  end

  private

  def self.diff(index, str)
    (str[index].ord - str[index - 1].ord).abs
  end

  def number_of_comparisons
    @str.length - 1
  end

  def reverse
    @reverse ||= @str.reverse
  end
end

# Testing purpose
# @reader = Reader.new(Suite::Test1::STDIN)

@reader = Reader.new(STDIN)
@writer = Writer.new(STDOUT)

@reader.strings.each do |str|
  if Checker.new(str).check
    @writer.add_line 'Funny'
  else
    @writer.add_line 'Not Funny'
  end
end

@writer.print
