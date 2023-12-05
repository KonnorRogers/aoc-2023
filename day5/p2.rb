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

# class Seed
#   attr_accessor :id
#
#   def initialize(id)
#     @id = id
#   end
#
  def location_to_seed(ranges, num)
    num = Integer(num)
    final_num = num

    ranges.each do |range|
      soil_number = Integer(range[0])
      seed_number = Integer(range[1])
      length = Integer(range[2])

      is_possible_seed_number = num >= soil_number && num <= soil_number + length

      if final_num == num && is_possible_seed_number
        final_num = num + (seed_number - soil_number)
      end

      # p "num: #{final_num} soil_number: #{soil_number}, seed_number: #{seed_number}"
      # p final_num
    end

    final_num
  end
# end

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

# p hash["humidity-to-location"]

seed_ranges = []

idx = -1
hash["seeds"].each_with_index do |num, index|
  # 0 is even, so we start at -1
  idx += 1 if index.even?
  seed_ranges[idx] = [] if seed_ranges[idx].nil?
  seed_ranges[idx] << Integer(num)
end

hash["seeds"] = seed_ranges.map { |r| (r[0]..r[0] + r[1]) }


final_num = nil
id = -1

final_num = nil
loop do
  id += 1
  humidity_num = location_to_seed(hash["humidity-to-location"], id)
  temperature_num = location_to_seed(hash["temperature-to-humidity"], humidity_num)
  light_num = location_to_seed(hash["light-to-temperature"], temperature_num)
  water_num = location_to_seed(hash["water-to-light"], light_num)
  fertilizer_num = location_to_seed(hash["fertilizer-to-water"], water_num)
  soil_num = location_to_seed(hash["soil-to-fertilizer"], fertilizer_num)
  seed_num = location_to_seed(hash["seed-to-soil"], soil_num)
  final_num = id

  break if hash["seeds"].any? { |range| range.cover?(seed_num) }
end

puts final_num


#    Seed 79, soil 81, fertilizer 81, water 81, light 74, temperature 78, humidity 78, location 82.
#    Seed 14, soil 14, fertilizer 53, water 49, light 42, temperature 42, humidity 43, location 43.
#    Seed 55, soil 57, fertilizer 57, water 53, light 46, temperature 82, humidity 82, location 86.
#    Seed 13, soil 13, fertilizer 52, water 41, light 34, temperature 34, humidity 35, location 35.
