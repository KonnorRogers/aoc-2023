require "stringio"
# require "strscan"

input = File.readlines(File.expand_path("input-1.txt", __dir__))

# input = StringIO.new(
# <<~INPUT
# Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
# Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
# Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
# Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
# Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
# Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
# INPUT
# ).readlines

class Card
  def initialize(line)
    # line = line

    numbers = line.split(/:\s+/)[1].split(/\s+\|\s+/)
    @winning_numbers = numbers[0].split(/\s+/).map { |num| Integer(num) }
    @your_numbers = numbers[1].split(/\s+/).map { |num| Integer(num) }
  end

  def matched_numbers
    @winning_numbers.select { |num| @your_numbers.include?(num) }
  end

  def points
    accum = 0
    matched_numbers.each_with_index do |_num, index|
      accum += 1 and next if index <= 1
      accum *= 2
    end

    accum
  end
end

p(input.sum { |line| Card.new(line).points })
