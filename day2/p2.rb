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

  def initialize(line)
    @line = line
    @id = line.scan(/Game (\d+):/).flatten.first
    @sets = line.split(/:/)[1].split(/;/)
  end

  def power
    @sets.each do |set|
      green_cubes = set.scan(/(\d+) green/).flatten.first

      @min_green = Integer(green_cubes) if green_cubes && (@min_green.nil? || Integer(green_cubes) > @min_green)

      blue_cubes = set.scan(/(\d+) blue/).flatten.first

      @min_blue = Integer(blue_cubes) if blue_cubes && (@min_blue.nil? || Integer(blue_cubes) > @min_blue)

      red_cubes = set.scan(/(\d+) red/).flatten.first

      @min_red = Integer(red_cubes) if red_cubes && (@min_red.nil? || Integer(red_cubes) > @min_red)
    end

    @min_red * @min_green * @min_blue
  end
end

answer = input.map { |line| Game.new(line) }.inject(0) { |accum, game| accum + Integer(game.power) }
puts answer
