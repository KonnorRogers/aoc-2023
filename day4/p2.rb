
require "stringio"
# require "strscan"

input = File.readlines(File.expand_path("input-1.txt", __dir__))

input = StringIO.new(
<<~INPUT
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
INPUT
).readlines

class Array
  def each!
    while count > 0
      yield(shift)
    end
  end
end


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
end

class SmartCard
  def initialize(card, cards, index)
    @card = card
    @cards = cards.slice(index, cards.length - 1)
  end

  def process_cards(cards = @cards)
    accum = 0
    cards.each_with_index do |card, index|
      accum += 1

      next if card.matched_numbers.length == 0

      # puts cards.slice(index, index + card.matched_numbers.length - 1)
      accum += process_cards(cards.slice(index + 1, index + card.matched_numbers.length))
    end

    accum
  end
end

cards = input.map { |line| Card.new(line) }

smart_cards = []

cards.each_with_index { |card, idx| smart_cards << SmartCard.new(card, cards, idx) }

accum = 0
smart_cards.each { |card| accum += card.process_cards }

puts smart_cards.length
# puts process_cards(input)
