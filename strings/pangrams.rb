require 'set'

module Suite
  module Test1
    class STDIN
      def self.read
        'We promptly judged antique ivory buckles for the next prize'
      end
    end
  end

  module Test2
    class STDIN
      def self.read
        'We promptly judged antique ivory buckles for the prize'
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

  def string
    @lines.first
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
    alphabet = Set.new(all_characters)
    @str.downcase.split('').each { |letter| alphabet.delete(letter) }
    alphabet.empty?
  end

  private

  def all_characters
    ('a'..'z').to_a
  end
end

# Testing purpose
# @reader = Reader.new(Suite::Test1::STDIN)

@reader = Reader.new(STDIN)
@writer = Writer.new(STDOUT)

success = Checker.new(@reader.string).check
@writer.add_line "#{success ? '' : 'not '}pangram"

@writer.print
