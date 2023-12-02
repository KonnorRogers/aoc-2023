require 'stringio'

input = File.readlines("./input-1.txt")

# input = StringIO.new(<<~INPUT
# 1abcxoneight
# two1nine
# eightwothree
# abcone2threexyz
# xtwone3four
# 4nineeightseven2
# zoneight234
# 7pqrstsixteen
# INPUT
# ).readlines

word_to_num = {
  "one" => 1,
  "two" => 2,
  "three" => 3,
  "four" => 4,
  "five" => 5,
  "six" => 6,
  "seven" => 7,
  "eight" => 8,
  "nine" => 9,
}

values = input.map do |str|
  d1 = str.scan(/(\d|one|two|three|four|five|six|seven|eight|nine)/).first.first
  d2 = str.scan(/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/).last.last

  d1 = word_to_num[d1] ? word_to_num[d1] : d1
  d2 = word_to_num[d2] ? word_to_num[d2] : d2
  hash = {"d1" => d1, "d2" => d2}

  Integer(d1.to_s + d2.to_s)
end

puts values[0]
answer = values.inject(0) { |accum, value| accum + value }

puts answer
