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

  module Test2
    class STDIN
      def self.read
        File.open('./fixtures/bigger_is_greater_stdin.txt').read
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
    @word = word.split('')
  end

  # Based on https://en.wikipedia.org/wiki/Permutation#Generation_in_lexicographic_order
  #
  # 1. Find the largest index k such that a[k] < a[k + 1].
  #    If no such index exists, the permutation is the last permutation.
  # 2. Find the largest index l greater than k such that a[k] < a[l].
  # 3. Swap the value of a[k] with that of a[l].
  # 4. Reverse the sequence from a[k + 1] up to and including the final element a[n].
  #
  def find
    k = search_k
    return nil unless k
    l = search_l(k)
    return nil unless l
    swap(k, l)
    reverse_from(k+1)
    @word.join
  end

  private

  # @return Boolean - Marks whether char1 is greater than char2
  def greater(char1, char2)
    (char1 <=> char2) >= 0
  end

  def search_k
    k = max_word_index
    while k > 0 && greater(@word[k - 1], @word[k]) do
      k -= 1
    end
    return nil if k <= 0
    (k - 1)
  end

  # Find the largest index l greater than k such that a[k] < a[l].
  def search_l(k)
    l = max_word_index
    while (l > k && (@word[l] <= @word[k])) do
      l -= 1
    end
    return nil unless l > k
    l
  end

  def swap(k, l)
    tmp = @word[k]
    @word[k] = @word[l]
    @word[l] = tmp
  end

  def reverse_from(i)
    j = max_word_index
    while (i < j) do
      temp = @word[i]
      @word[i] = @word[j]
      @word[j] = temp
      i += 1
      j -= 1
    end
  end

  def max_word_index
    @word_size ||= @word.length - 1
  end
end

# Testing purpose
# @reader = Reader.new(Suite::Test2::STDIN)

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
