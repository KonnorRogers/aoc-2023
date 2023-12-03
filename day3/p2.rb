require "stringio"
require "strscan"

input = File.readlines("./input-1.txt")
# input = StringIO.new(
# <<~INPUT
#   ..152....
#   .....*...
#   ....249..
# INPUT
# ).readlines
#
# input = StringIO.new(
#   <<~INPUT
# 467..114..
# ...*......
# ..35..633.
# ......#...
# *617......
# .....+.58.
# ..592.....
# ......755.
# ...$.*....
# .664.598..
#   INPUT
# ).readlines

numbers = {}

input.each_with_index do |line, gear_y|
  string_scanner = StringScanner.new(line)

  loop do
    special_symbol_regex = /[^\d.\n]/
    gear_string = string_scanner.scan_until(special_symbol_regex)

    break if gear_string.nil?

    # part_number = scanned_number.scan(/\d+/).flatten.first
    gear_x = string_scanner.pos - 1

    3.times do |y_increment|
      y = gear_y - 1 + y_increment

      3.times do |x_increment|
        x = gear_x - 1 + x_increment

        # find full number
        str = input[y][x]

        next unless str =~ /\d/

        beginning_digits = ""
        ending_digits = ""
        incrementor = 0

        # beginning of number
        loop do
          incrementor -= 1
          digit = input[y][x + incrementor]

          unless digit =~ /\d/
            break
          end

          beginning_digits = digit + beginning_digits
        end

        incrementor = 0
        loop do
          incrementor += 1
          digit = input[y][x + incrementor]

          unless digit =~ /\d/
            break
          end

          ending_digits = ending_digits + digit
        end
        coords = "#{gear_x},#{gear_y}"
        numbers[coords] = [] if numbers[coords].nil?
        numbers[coords] << Integer(beginning_digits + str + ending_digits)
        numbers[coords].uniq!
      end
    end
  end
end

p numbers.select { |k, v| v.length == 2 }.sum { |k, v| v[0] * v[1] }
