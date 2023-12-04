
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

class Array
  def each!
    while count > 0
      yield(shift)
    end
  end
end


class Card
  attr_accessor :id

  def initialize(line, id, matched_length = nil)
    @id = id

    @matched_length = matched_length

    if line
      numbers = line.split(/:\s+/)[1].split(/\s+\|\s+/)
      @winning_numbers = numbers[0].split(/\s+/).map { |num| Integer(num) }
      @your_numbers = numbers[1].split(/\s+/).map { |num| Integer(num) }
    end
  end

  def matched_numbers
    @winning_numbers.select { |num| @your_numbers.include?(num) }
  end

  def matched_length
    @matched_length ||= matched_numbers.length
  end
end

cards = input.map.with_index { |line, index| Card.new(line, index) }

cards.each_with_index do |card, index|
  id = card.id

  cards[index].matched_length.times do |i|
    copied_card = cards[id + i + 1]
    cards << Card.new(nil, copied_card.id, copied_card.matched_length)
  end
end

p cards.length
