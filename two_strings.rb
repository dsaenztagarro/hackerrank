module Suite
  module Test1
    class STDIN
      def self.read
        %{2
hello
world
hi
world}
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

  def testcases
    @lines.slice(1, number_of_testcases * 2).each_slice(2).map do |group|
      TestCase.new(*group)
    end
  end

  private

  def number_of_testcases
    @lines[0].to_i
  end
end

class TestCase
  attr_accessor :strA, :strB

  def initialize(strA, strB)
    @strA = strA
    @strB = strB
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
  def initialize(testcase)
    @testcase = testcase
  end

  def check
    number_of_tests.each do |index|
      char = @testcase.strA[index]
      return true if @testcase.strB.include? char
    end
    false
  end

  private

  def number_of_tests
    (0..@testcase.strA.length - 1).to_a
  end
end

# Testing purpose
# @reader = Reader.new(Suite::Test1::STDIN)

@reader = Reader.new(STDIN)
@writer = Writer.new(STDOUT)

@reader.testcases.each do |testcase|
  if Checker.new(testcase).check
    @writer.add_line 'YES'
  else
    @writer.add_line 'NO'
  end
end

@writer.print
