require "stringio"
# require "strscan"

input = File.readlines(File.expand_path("input-1.txt", __dir__))

# input = StringIO.new(
# <<~INPUT
# Time:      7  15   30
# Distance:  9  40  200
# INPUT
# ).readlines

times = input[0].split(/:\s+/)[1].split(/\s+/)
distances = input[1].split(/:\s+/)[1].split(/\s+/)

races = []
idx = 0
while idx < times.length
  races << { time: Integer(times[idx]), distance: Integer(distances[idx]) }
  idx += 1
end

def hold_times(time, target_distance)
  hold_time = 0

  hold_times = []

  while hold_time < time
    hold_time += 1

    distance = hold_time * (time - hold_time)

    hold_times << hold_time if distance > target_distance
  end

  hold_times
end

possibilities = races.map do |race|
  hold_times(race[:time], race[:distance]).length
end.inject(:*)

p possibilities
