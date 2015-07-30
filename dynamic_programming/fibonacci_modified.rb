module Suite
  module Test1
    class STDIN
      def self.read
        %(0 1 5)
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
    @params = @lines[0].split(' ').map(&:to_i)
  end

  def param_A
    @params[0]
  end

  def param_B
    @params[1]
  end

  def param_N
    @params[2]
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

class Fibonnaci
	attr_reader :count_list

  def initialize(param_A, param_B)
    @param_A = param_A
    @param_B = param_B
    init_stack
  end

  def value_for(index)
    (index - 2).times do
      param_A = @stack.shift
      param_B = @stack.first
      @stack << param_A + param_B ** 2
    end
    @stack.last
  end

  private

  def init_stack
    @stack = []
    @stack << @param_A
    @stack << @param_B
  end
end

# Testing purpose
# @reader = Reader.new(Suite::Test1::STDIN)

@reader = Reader.new(STDIN)
@writer = Writer.new(STDOUT)

@fib = Fibonnaci.new(@reader.param_A, @reader.param_B)

@writer.add_line @fib.value_for(@reader.param_N)
@writer.print
