require "stringio"

input = File.read(File.expand_path("input-1.txt", __dir__))

# input = StringIO.new(
# <<~INPUT
# seeds: 79 14 55 13
#
# seed-to-soil map:
# 50 98 2
# 52 50 48
#
# soil-to-fertilizer map:
# 0 15 37
# 37 52 2
# 39 0 15
#
# fertilizer-to-water map:
# 49 53 8
# 0 11 42
# 42 0 7
# 57 7 4
#
# water-to-light map:
# 88 18 7
# 18 25 70
#
# light-to-temperature map:
# 45 77 23
# 81 45 19
# 68 64 13
#
# temperature-to-humidity map:
# 0 69 1
# 1 0 69
#
# humidity-to-location map:
# 60 56 37
# 56 93 4
# INPUT
# ).read

class Seed
  attr_accessor :id

  def initialize(id)
    @id = id
  end

  def convert(ranges, num)
    # 50 98 2 -> soil: 50, seeds: 98 + 1
    # 52 50 48 -> soil: 52, seeds: 50

    num = Integer(num)
    final_num = num

    ranges.each do |range|
      soil_number = Integer(range[0])
      seed_number = Integer(range[1])
      length = Integer(range[2])

      is_possible_seed_number = num >= seed_number && num <= seed_number + length

      if final_num == num && is_possible_seed_number
        final_num = num + (soil_number - seed_number)
      end
    end

    final_num
  end
end

# 50 98 2
# 52 50 48
# [range_start, source_range_start, range_length]

hash = {
  "seeds" => [],
  "seed-to-soil" => [],
  "soil-to-fertilizer" => [],
  "fertilizer-to-water" => [],
  "water-to-light" => [],
  "light-to-temperature" => [],
  "temperature-to-humidity" => [],
  "humidity-to-location" => []
}

def to_range(inputs)
  inputs.split(/\n/).map { |i| i.split(/\s+/) }
end

inputs = input.split(/\n\n/)

hash["seeds"] = inputs[0].split(/:\s+/)[1].split(/\s+/)
hash["seed-to-soil"] = to_range(inputs[1].split(/:\s+/)[1])
hash["soil-to-fertilizer"] = to_range(inputs[2].split(/:\s+/)[1])
hash["fertilizer-to-water"] = to_range(inputs[3].split(/:\s+/)[1])
hash["water-to-light"] = to_range(inputs[4].split(/:\s+/)[1])
hash["light-to-temperature"] = to_range(inputs[5].split(/:\s+/)[1])
hash["temperature-to-humidity"] = to_range(inputs[6].split(/:\s+/)[1])
hash["humidity-to-location"] = to_range(inputs[7].split(/:\s+/)[1])

seed_ranges = []

idx = -1
hash["seeds"].each_with_index do |num, index|
  # 0 is even, so we start at -1
  idx += 1 if index.even?
  seed_ranges[idx] = [] if seed_ranges[idx].nil?
  seed_ranges[idx] << Integer(num)
end


# seeds = []
# seed_ranges.each do |range|
#   start = range[0]
#   length = range[1]
#
#   seeds << (start..length)
#   #
#   # # Find the lowest valid seed numbers
#   # length.times do |num|
#   #   seeds << start + num
#   # end
# end

hash["seeds"] = seed_ranges

locations = hash["seeds"].map do |range|
  final_num = nil
  Seed.new(Integer(id)).tap do |seed|
    soil_num = seed.convert(hash["seed-to-soil"], id)
    fertilizer_num = seed.convert(hash["soil-to-fertilizer"], soil_num)
    water_num = seed.convert(hash["fertilizer-to-water"], fertilizer_num)
    light_num = seed.convert(hash["water-to-light"], water_num)
    temp_num = seed.convert(hash["light-to-temperature"], light_num)
    humidity_num = seed.convert(hash["temperature-to-humidity"], temp_num)
    location_num = seed.convert(hash["humidity-to-location"], humidity_num)
    final_num = location_num

    # debug = {
    #   soil_num: soil_num,
    #   fertilizer_num: fertilizer_num,
    #   water_num: water_num,
    #   light_num: light_num,
    #   temp_num: temp_num,
    #   humidity_num: humidity_num,
    #   location_num: location_num
    # }
    # p debug
  end

  final_num
end

p locations.min

#    Seed 79, soil 81, fertilizer 81, water 81, light 74, temperature 78, humidity 78, location 82.
#    Seed 14, soil 14, fertilizer 53, water 49, light 42, temperature 42, humidity 43, location 43.
#    Seed 55, soil 57, fertilizer 57, water 53, light 46, temperature 82, humidity 82, location 86.
#    Seed 13, soil 13, fertilizer 52, water 41, light 34, temperature 34, humidity 35, location 35.
