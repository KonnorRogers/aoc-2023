require "stringio"
# require "strscan"

input = File.readlines(File.expand_path("input-1.txt", __dir__))

# input = StringIO.new(
# <<~INPUT
# 32T3K 765
# T55J5 684
# KK677 28
# KTJJT 220
# QQQJA 483
# INPUT
# ).readlines

hands = []
bids = []

input.each do |line|
  split = line.split(/\s+/)

  hands << split[0]
  bids << Integer(split[1])
end


def frequency(string)
  Hash.new(0).tap { |counts| string.chars.each { |v| counts[v] += 1 } }
end

CARD_TO_NUM = {
  "A" => 14,
  "K" => 13,
  "Q" => 12,
  "T" => 11,
  "9" => 10,
  "8" => 9,
  "7" => 8,
  "6" => 7,
  "5" => 6,
  "4" => 5,
  "3" => 4,
  "2" => 3,
  "J" => 2
}

def calculate_kicker(cards)
  # 6 digits because we have 5 cards
  final = 0
  cards.length.times do |i|
    card = cards[i]
    final += (13**(cards.length - i)) * CARD_TO_NUM[card]
  end
  final
end

def calculate_hand(cards, bid)
  hash = frequency(cards)
  kicker = calculate_kicker(cards)

  joker_count = Integer(hash["J"])

  hash.delete("J")

  # 5 of a kind
  if (
    hash.value?(5) ||
    joker_count >= 4 ||
    (joker_count == 3 && hash.value?(2)) ||
    (joker_count == 2 && hash.value?(3)) ||
    (joker_count == 1 && hash.value?(4))
  )
    return { cards: cards, rank: 8, kicker: kicker, bid: bid }
  end


  # 4 of a kind
  if (
    hash.value?(4) ||
    joker_count == 3 ||
    (joker_count == 2 && hash.value?(2)) ||
    (joker_count == 1 && hash.value?(3))
  )
    return { cards: cards, rank: 7, kicker: kicker, bid: bid }
  end

  values = hash.values.sort

  # full house
  if
    (hash.value?(3) && hash.value?(2)) ||
    (joker_count == 2 && hash.value?(2)) ||
    (joker_count == 1 && values[-1] == 2 && values[-2] == 2)
    return {cards: cards, rank: 6, kicker: kicker, bid: bid }
  end


  # 3 of a kind
  if
    hash.value?(3) ||
    joker_count == 2 ||
    (joker_count == 1 && hash.value?(2))

    return {cards: cards, rank: 5, kicker: kicker, bid: bid }
  end

  # 2 pair
  if
    (values[-1] == 2 && values[-2] == 2) ||
    (joker_count == 1 && hash.value?(2))

    return {cards: cards, rank: 4, kicker: kicker, bid: bid }
  end

  # These should never get jokers

  # pair
  if hash.value?(2) || joker_count == 1
    return {cards: cards, rank: 3, kicker: kicker, bid: bid }
  end

  # nothin
  {cards: cards, rank: 2, kicker: kicker, bid: bid }
end

p(hands.map.with_index do |cards, index|
  calculate_hand(cards, bids[index])
end.sort do |a, b|
  next a[:kicker] <=> b[:kicker] if a[:rank] == b[:rank]

  a[:rank] <=> b[:rank]
end.map.with_index { |h, i| h[:bid] * (i + 1) }.sum)
