require "stringio"
# require "strscan"

input = File.readlines(File.expand_path("input-1.txt", __dir__))

input = StringIO.new(
<<~INPUT
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
INPUT
).readlines

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
  "A" => 13,
  "K" => 12,
  "Q" => 11,
  "T" => 10,
  "9" => 9,
  "8" => 8,
  "7" => 7,
  "6" => 6,
  "5" => 5,
  "4" => 4,
  "3" => 3,
  "2" => 2,
  "J" => 1
}

def calculate_kicker(cards)
  # 6 digits because we have 5 cards
  final = 0
  start = 1_000_000_000_000_000
  cards.length.times do |i|
    card = cards[i]
    start = start / 100

    final += (start * CARD_TO_NUM[card])
  end
  final
end

p(hands.map.with_index do |cards, index|
  hash = frequency(cards)
  kicker = calculate_kicker(cards)

  joker_count = hash["J"]

  # 5 of a kind
  if hash.value?(5)
    next { cards: cards, kicker: kicker, rank: 8, bid: bids[index] }
  end

  if (
    (joker_count == 1 && hash.value?(4)) ||
    (joker_count == 2 && hash.value?(3)) ||
    (joker_count == 3 && hash.value?(2)) ||
    (joker_count == 4 && hash.value?(1)) ||
    (joker_count == 5)
  )
    next { cards: cards, kicker: kicker, rank: 8, bid: bids[index] }
  end

  # 4 of a kind
  next { cards: cards, kicker: kicker, rank: 7, bid: bids[index] } if hash.value?(4)

  if (
    (joker_count == 1 && hash.value?(3)) ||
    (joker_count == 2 && hash.value?(2)) ||
    (joker_count == 3 && hash.value?(1)) ||
    (joker_count == 4)
  )
    next { cards: cards, kicker: kicker, rank: 7, bid: bids[index] }
  end

  # full house
  next {cards: cards, kicker: kicker, rank: 6, bid: bids[index] } if hash.value?(3) && hash.value?(2)

  values = hash.values.sort

  if (
    # (joker_count == 4 && hash.value?(1)) ||
    # (joker_count == 3 && hash.value?(2)) ||
    # (values[-1] == 3 && values[-2] == 1 && joker_count >= 1) ||
    # (values[-1] == 2 && values[-2] == 2 && joker_count >= 1) ||
    # (values[-1] == 2 && values[-2] == 1 && joker_count >= 2) ||
    # (values[-1] == 3 && values[-2] == 1 && joker_count >= 2) ||
    # (values[-1] == 2 && values[-2] == 1 && joker_count >= 3) ||
    # (values[-1] == 1 && values[-2] == 1 && joker_count >= 3)
  )
    next {cards: cards, kicker: kicker, rank: 6, bid: bids[index] }
  end


  # 3 of a kind
  next {cards: cards, kicker: kicker, rank: 5, bid: bids[index] } if hash.value?(3)

  if (
    # (joker_count == 1 && hash.value?(2)) ||
    # (joker_count == 2 && hash.value?(1)) ||
    # (joker_count == 3)
  )
    next {cards: cards, kicker: kicker, rank: 5, bid: bids[index] }
  end


  # 2 pair
  next {cards: cards, kicker: kicker, rank: 4, bid: bids[index] } if values[-1] == 2 && values[-2] == 2

  if (
    (joker_count == 1 && hash.value?(2))
  )
    next {cards: cards, kicker: kicker, rank: 4, bid: bids[index] }
  end

  # These should never get jokers

  # pair
  next {cards: cards, kicker: kicker, rank: 3, bid: bids[index] } if values[-1] == 2 || joker_count >= 1

  # do we need to check this?
  next {cards: cards, kicker: kicker, rank: 2, bid: bids[index] } if values.all? { |x| x == 0 }

  # nothin
  {cards: cards, kicker: kicker, rank: 1, bid: bids[index] }
end.sort do |a, b|
  next a[:kicker] <=> b[:kicker] if a[:rank] == b[:rank]
  a[:rank] <=> b[:rank]
end.map.with_index { |h, i| h[:bid] * (i + 1) }.sum)

# Wrong: 254476776 (high)
# Wrong: 254448614 (high)
# Wrong: 255249440 (wrong)
# Wrong: 254627401 (wrong)
