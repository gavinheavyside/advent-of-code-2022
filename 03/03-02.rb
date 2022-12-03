#!/usr/bin/env ruby

require 'set'

rucksacks = []
while line = $stdin.gets
  rucksacks << Set.new(line.chomp.chars)
end

badges = rucksacks.each_slice(3).map do |r1, r2, r3|
  r1.intersection(r2).intersection(r3).first
end

priority_order = ('a'..'z').to_a + ('A'..'Z').to_a

puts badges.map { |badge| priority_order.index(badge) + 1 }.reduce(:+)
