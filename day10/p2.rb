require 'stringio'
require "prettyprint"

INPUT = File.readlines(File.expand_path("input-1.txt", __dir__))

INPUT1 = StringIO.new(
<<~INPUT
...........
.S-------7.
.|F-----7|.
.||.....||.
.||.....||.
.|L-7.F-J|.
.|..|.|..|.
.L--J.L--J.
...........
INPUT
).readlines

INPUT2 = StringIO.new(
<<~INPUT
.F----7F7F7F7F-7....
.|F--7||||||||FJ....
.||.FJ||||||||L7....
FJL7L7LJLJ||LJ.L-7..
L--J.L7...LJS7F-7L7.
....F-J..F7FJ|L7L7L7
....L7.F7||L7|.L7L7|
.....|FJLJ|FJ|F7|.LJ
....FJL-7.||.||||...
....L---J.LJ.LJLJ...
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
  input = Marshal.load(Marshal.dump(input))
  current_location = [start[0], start[1]]
  current_direction = direction

  steps = 0

  # order = []
  # visited_nodes = {}
  loop do
    steps += 1

    if [:up, :down].include?(current_direction)
      current_location[1] += MOVEMENTS[current_direction]
    else
      current_location[0] += MOVEMENTS[current_direction]
    end

    next_location = input[current_location[1]][current_location[0]]

    input[current_location[1]][current_location[0]] = "!"

    return input if next_location == "S"

    return false if PIECES[next_location].nil? || (PIECES[next_location][0][0] != current_direction && PIECES[next_location][1][0] != current_direction)

    if current_direction == PIECES[next_location][0][0]
      current_direction = PIECES[next_location][0][1]
    else
      current_direction = PIECES[next_location][1][1]
    end
  end
end

def find_parts(input)
  counts = []
  input.each.with_index do |line, y|
    inside_count = 0
    line.each_char.with_index do |c, x|
      next if c == '!'

      # travel all the way in each direction and check for a "!"
      # We only need to be touching in two directions.
      coords = [x, y]

      checks = [
        check_all(input, :left, coords),
        check_all(input, :right, coords),
        check_all(input, :up, coords),
        check_all(input, :down, coords),
      ]

      p checks
      inside_count += 1 if checks.select { |check| check == true }.length == 2
    end
    # raise "#{line.inspect} -> #{line.inspect} stays inside" if inside
    counts << inside_count
  end

  counts.sum
end

def check_all(input, direction, coords)
  current_coords = [coords[0], coords[1]]

  final_coords = [coords[0], coords[1]]

  if direction == :right
    # final_x = input[current_coords[1]].rindex("!")
    final_x = input[current_coords[1]]
    p final_x
    final_coords[0] = final_x
  end

  if direction == :left
    # final_x = input[current_coords[1]].index("!")
    final_x = input[current_coords[1]]
    p final_x
    final_coords[0] = final_x
  end

  if direction == :up
    input.length.times do |i|
      if input[i][current_coords[0]] == "!"
        final_y = i
        p final_y
        final_coords[1] = final_y
        break
      end
    end
  end

  if direction == :down
    input.length.times do |i|
      if input[input.length - i - 1][current_coords[0]] == "!"
        final_y = i
        p final_y
        final_coords[1] = final_y
        break
      end
    end
  end

  # return false if final_coords.include?(nil)

  is_inside = false

  loop do
    if [:up, :down].include?(direction)
      current_coords[1] += MOVEMENTS[direction]

      is_inside = true if final_coords == current_coords
      break if current_coords[1] >= input.length || current_coords[1] < 0
    else
      current_coords[0] += MOVEMENTS[direction]

      is_inside = true if final_coords == current_coords
      break if current_coords[0] >= input[0].length || current_coords[0] < 0
    end
  end

  is_inside
end

subbed_input = travel(INPUT1).values.reject { |i| i == false }[0]
# subbed_input = travel(INPUT2).values.reject { |i| i == false }[0]

# pp  subbed_input
p find_parts(subbed_input)
# p travel(INPUT2) # 8
# p travel(INPUT).values.reject { |i| i == false }.sum / 4

# | is a vertical pipe connecting north and south.
# - is a horizontal pipe connecting east and west.
# L is a 90-degree bend connecting north and east.
# J is a 90-degree bend connecting north and west.
# 7 is a 90-degree bend connecting south and west.
# F is a 90-degree bend connecting south and east.
# . is ground; there is no pipe in this tile.
# S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.

