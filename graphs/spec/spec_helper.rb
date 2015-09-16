require 'byebug'
Dir.glob('lib/**/*.rb').each { |file| require_relative File.join('..', file) }
