#!/usr/bin/env ruby

require 'set'

rucksacks = []
while line = $stdin.gets
  rucksacks << line.chomp
end

compartments = rucksacks.map do |contents|
  mid = contents.size / 2
  [ contents[0...mid].chars, contents[mid..-1].chars ]
end

errors = compartments.map do |c1, c2|
  i1 = Set.new(c1)
  i2 = Set.new(c2)

  i1.intersection(i2).first
end

priority_order = ('a'..'z').to_a + ('A'..'Z').to_a

puts errors.map { |error| priority_order.index(error) + 1 }.reduce(:+)
