require "stringio"
require "prettyprint"
# require "strscan"

input = File.read(File.expand_path("input-1.txt", __dir__))

# input = StringIO.new(
# <<~INPUT
# RL
#
# AAA = (BBB, CCC)
# BBB = (DDD, EEE)
# CCC = (ZZZ, GGG)
# DDD = (DDD, DDD)
# EEE = (EEE, EEE)
# GGG = (GGG, GGG)
# ZZZ = (ZZZ, ZZZ)
# INPUT
# ).read
#
# input = StringIO.new(
# <<~INPUT
# LLR
#
# AAA = (BBB, BBB)
# BBB = (AAA, ZZZ)
# ZZZ = (ZZZ, ZZZ)
# INPUT
# ).read

split = input.split(/\n\n/)

instructions = split[0]
nodes = {}

split[1].split(/\n/).each do |str|
  ary = str.split(/\s+=\s+/)
  node = ary[0]

  # puts ary
  coords = ary[1].gsub(/\(/, "").gsub(/\)/, "").gsub(/\s+/, "").split(/,/)
  left = coords[0]
  right = coords[1]

  nodes[node] = { L: left, R: right }
end

FINAL = "ZZZ".freeze

current_node = "AAA"
steps = 0
loop do
  break if current_node == FINAL

  instruction = instructions[steps % instructions.length].to_sym

  current_node = nodes[current_node][instruction]
  steps += 1
end

p steps
