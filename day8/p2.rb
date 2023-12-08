require "stringio"
require "prettyprint"
# require "strscan"

input = File.read(File.expand_path("input-1.txt", __dir__))

# input = StringIO.new(
# <<~INPUT
# LR
#
# 11A = (11B, XXX)
# 11B = (XXX, 11Z)
# 11Z = (11B, XXX)
# 22A = (22B, XXX)
# 22B = (22C, 22C)
# 22C = (22Z, 22Z)
# 22Z = (22B, 22B)
# XXX = (XXX, XXX)
# INPUT
# ).read

def greatest_common_denominator(a,b)
  b == 0 ? a : greatest_common_denominator(b, a % b)
end

def least_common_multiple(a,b)
  a / greatest_common_denominator(a, b) * b
end

def least_common_multiple_all(ary)
  ary.reduce(1) { |accum, current| least_common_multiple(accum, current) }
end

def get_steps(current_node, nodes, instructions)
  steps = 0

  loop do
    break if current_node.end_with?("Z")

    instruction = instructions[steps % instructions.length].to_sym
    current_node = nodes[current_node][instruction]
    steps += 1
  end

  steps
end

split = input.split(/\n\n/)

instructions = split[0]
nodes = {}

split[1].split(/\n/).each do |str|
  ary = str.split(/\s+=\s+/)
  node = ary[0]
  final_letter = node[-1]

  # puts ary
  coords = ary[1].gsub(/\(/, "").gsub(/\)/, "").gsub(/\s+/, "").split(/,/)
  left = coords[0]
  right = coords[1]

  nodes[final_letter] = {} if nodes[final_letter].nil?

  hash = { L: left, R: right }
  nodes[final_letter][node] = hash
  nodes[node] = hash
end

current_nodes = nodes["A"]

pp(least_common_multiple_all(current_nodes.keys.map { |current_node| get_steps(current_node, nodes, instructions) }))
