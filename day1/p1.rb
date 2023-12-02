input = File.readlines("./input-1.txt")

values = input.map do |str|
  digits = str.scan(/\d/)
  d1 = digits.first
  d2 = digits.last

  Integer(d1.to_s + d2.to_s)
end

answer = values.inject(0) { |accum, value| accum + value }

puts answer
