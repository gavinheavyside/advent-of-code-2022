#!/usr/bin/env ruby

rows = $stdin.readlines.map(&:chomp)
crate_rows = rows.take_while{ |row| row =~ /\[/ }
columns = rows.find{ |row| row =~ / 1 / }.chomp.split.map(&:to_i).max
moves = rows.select{ |row| row =~ /move/ }

crate_stack = Array.new(columns, Array.new)

crate_rows.reverse.each do |row|
  row.chars.each_slice(4).with_index do |slice, index|
    if slice[1] != ' '
      crate_stack[index] = crate_stack[index] + [slice[1]]
    end
  end
end

moves.each do |move|
  m = move.match(/^move (\d+) from (\d+) to (\d+)$/)
  num = m[1].to_i
  src = m[2].to_i - 1
  dst = m[3].to_i - 1
  crate_stack[dst] = crate_stack[dst] + crate_stack[src].reverse.take(num)
  crate_stack[src] = crate_stack[src].take(crate_stack[src].size - num)
end

puts crate_stack.map(&:last).join

