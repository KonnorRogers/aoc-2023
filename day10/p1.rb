require 'stringio'

INPUT = File.readlines(File.expand_path("input-1.txt", __dir__))

INPUT1 = StringIO.new(
<<~INPUT
.....
.S-7.
.|.|.
.L-J.
.....
INPUT
).readlines

INPUT2 = StringIO.new(
<<~INPUT
..F7.
.FJ|.
SJ.L7
|F--J
LJ...
INPUT
).readlines

MOVEMENTS = {
  up: -1,
  down: 1,
  left: -1,
  right: 1
}

PIECES = {
  "|" => [[:up, :up], [:down, :down]],
  "-" => [[:left, :left], [:right, :right]],
  "L" => [[:down, :right], [:left, :up]],
  "J" => [[:right, :up], [:down, :left]],
  "7" => [[:up, :left], [:right, :down]],
  "F" => [[:up, :right], [:left, :down]],
  "." => nil,
}

# connections = {
#   "|": ["L", "J", "7"]
# }

def find_start(input)
  x = 0
  y = input.find_index do |str|
    x = str.index("S")
  end

  [x, y]
end

def travel(input)
  start = find_start(input)

  up = travel_direction(input, start, :up)
  left = travel_direction(input, start, :left)
  right = travel_direction(input, start, :right)
  down = travel_direction(input, start, :down)
  {
    up: up,
    left: left,
    right: right,
    down: down,
  }
end

def travel_direction(input, start, direction)
  current_location = [start[0], start[1]]
  current_direction = direction

  steps = 0

  order = []
  loop do
    steps += 1

    if [:up, :down].include?(current_direction)
      current_location[1] += MOVEMENTS[current_direction]
    else
      current_location[0] += MOVEMENTS[current_direction]
    end

    next_location = input[current_location[1]][current_location[0]]
    order << next_location


    return steps if next_location == "S"
    # return order if next_location == "S"

    return false if PIECES[next_location].nil? || (PIECES[next_location][0][0] != current_direction && PIECES[next_location][1][0] != current_direction)

    if current_direction == PIECES[next_location][0][0]
      current_direction = PIECES[next_location][0][1]
    else
      current_direction = PIECES[next_location][1][1]
    end
  end
end

# p travel(INPUT1)
# p travel(INPUT2)
p travel(INPUT).values.reject { |i| i == false }.sum / 4

# | is a vertical pipe connecting north and south.
# - is a horizontal pipe connecting east and west.
# L is a 90-degree bend connecting north and east.
# J is a 90-degree bend connecting north and west.
# 7 is a 90-degree bend connecting south and west.
# F is a 90-degree bend connecting south and east.
# . is ground; there is no pipe in this tile.
# S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.

