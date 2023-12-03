require "stringio"
require "strscan"

input = File.readlines("./input-1.txt")

# input = StringIO.new(
#   <<~INPUT
# 467..114..
# ...*......
# ..35..633.
# ......#...
# 617*......
# .....+.58.
# ..592.....
# ......755.
# ...$.*....
# .664.598..
#   INPUT
# ).readlines


numbers = []

input.each_with_index do |line, row|
  string_scanner = StringScanner.new(line)

  loop do
    scanned_number = string_scanner.scan_until(/\d+/)

    break if scanned_number.nil?

    part_number = scanned_number.scan(/\d+/).flatten.first
    current_column = string_scanner.pos

    # Plus 2 to check before / after
    (part_number.length + 2).times do |column_number|
      column = (current_column - part_number.length - 1) + column_number

      # We don't check -1
      next if column < 0

      # We don't check outside of the board.
      next if column > line.length - 1

      special_symbol_regex = /[^\d.\n]/
      next_char = input[row][column]

      if next_char.match?(special_symbol_regex)
        numbers << part_number
        break
      end

      if row - 1 >= 0
        next_char = input[row - 1][column]

        if next_char.match?(special_symbol_regex)
          numbers << part_number
          break
        end
      end

      if row + 1 < input.length
        next_char = input[row + 1][column]

        if next_char.match?(special_symbol_regex)
          numbers << part_number
          break
        end
      end
    end
  end
end

puts numbers.map(&:to_i).sum
