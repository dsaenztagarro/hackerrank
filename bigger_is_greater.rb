module Suite
  module Test1
    class STDIN
      def self.read
        %{5
ab
bb
hefg
dhck
dkhc}
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

  def words
    @lines.slice(1, number_of_words)
  end

  private

  def number_of_words
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

class Finder
  def initialize(word)
    @word = word
  end

  def find
    possible_words.sort.shift
  end

  private

  def possible_words
    @word.split('').permutation.inject([]) do |memo, word|
      perm = word.join
      if (perm <=> @word).eql? 1
        memo << perm
      end
      memo
    end
  end
end

# Testing purpose
# @reader = Reader.new(Suite::Test1::STDIN)

@reader = Reader.new(STDIN)
@writer = Writer.new(STDOUT)

@reader.words.each do |word|
  greater_word = Finder.new(word).find
  if greater_word
    @writer.add_line greater_word
  else
    @writer.add_line 'no answer'
  end
end

@writer.print
