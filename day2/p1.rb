require 'stringio'

input = File.readlines("./input-1.txt")

# input = StringIO.new(<<~INPUT
# Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
# Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
# Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
# Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
# Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
# INPUT
# ).readlines

class Game
  attr_accessor :id

  MAX_RED = 12
  MAX_GREEN = 13
  MAX_BLUE = 14

  def initialize(line)
    @line = line
    @id = line.scan(/Game (\d+):/).flatten.first
    @sets = line.split(/:/)[1].split(/;/)
  end

  def possible?
    @sets.each do |set|
      green_cubes = set.scan(/(\d+) green/).flatten.first

      return false if green_cubes && Integer(green_cubes) > MAX_GREEN

      blue_cubes = set.scan(/(\d+) blue/).flatten.first

      return false if blue_cubes && Integer(blue_cubes) > MAX_BLUE

      red_cubes = set.scan(/(\d+) red/).flatten.first

      return false if red_cubes && Integer(red_cubes) > MAX_RED
    end

    true
  end
end

answer = input.map { |line| Game.new(line) }.select { |game| game.possible? }.inject(0) { |accum, game| accum + Integer(game.id) }
puts answer
