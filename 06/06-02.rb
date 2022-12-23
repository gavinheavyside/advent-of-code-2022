#!/usr/bin/env ruby

input = $stdin.read.chomp.chars

marker = 0
input.each_cons(14).with_index do |chars, index|
  if chars.uniq.size == 14
    marker = index + 14
    break
  end
end

puts marker
