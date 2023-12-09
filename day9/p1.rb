require "stringio"
require "prettyprint"
# require "strscan"

input = File.readlines(File.expand_path("input-1.txt", __dir__))

# input = StringIO.new(
# <<~INPUT
# 0 3 6 9 12 15
# 1 3 6 10 15 21
# 10 13 16 21 30 45
# INPUT
# ).readlines

def make_arrays(str)
  ary = []
  ary << str.split(/\s+/).map(&:to_i)

  idx = 0
  loop do
    current_ary = ary[idx]

    new_values = []

    (current_ary.length - 1).times do |i|
      new_values << current_ary[i + 1] - current_ary[i]
    end


    ary << new_values

    break if new_values.all? { |i| i == 0 }

    idx += 1
  end

  ary

end

def fill_values(ary)
  (ary.length - 1).times do |i|
    row = ary.length - 1 - i

    next if row - 1 <= -1

    prev_row = row - 1

    prev_num = ary[prev_row][-1]
    current_num = ary[row][-1]

    ary[prev_row] << current_num + prev_num
  end
  ary
end

pp(input.map do |str|
  ary = make_arrays(str)
  fill_values(ary)

  ary[0][-1]
end.sum)

# 18, 28 68
