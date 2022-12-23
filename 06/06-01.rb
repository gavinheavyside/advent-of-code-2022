#!/usr/bin/env ruby

input = $stdin.read.chomp.chars

marker = 0
input.each_cons(4).with_index do |chars, index|
  if chars.uniq.size == 4
    marker = index + 4
    break
  end
end

puts marker
