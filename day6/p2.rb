require "stringio"
# require "strscan"

input = File.readlines(File.expand_path("input-1.txt", __dir__))

# input = StringIO.new(
# <<~INPUT
# Time:      7  15   30
# Distance:  9  40  200
# INPUT
# ).readlines

time = Integer(input[0].split(/:\s+/)[1].split(/\s+/).join(""))
distance = Integer(input[1].split(/:\s+/)[1].split(/\s+/).join(""))

race = {time: time, distance: distance}

def hold_times(time, target_distance)
  hold_time = 0

  min_max = []

  while hold_time < time
    hold_time += 1

    distance = hold_time * (time - hold_time)

    break if !min_max[0].nil? && distance < target_distance
    next if distance <= target_distance

    min_max << hold_time if min_max[0].nil?
    min_max[1] = hold_time
  end

  min_max
end

possibilities = hold_times(race[:time], race[:distance])

p (possibilities[1] - possibilities[0] + 1)
