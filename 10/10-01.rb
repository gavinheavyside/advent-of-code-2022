#!/usr/bin/env ruby

INSTRUCTIONS = {
  addx: 2,
  noop: 1
}

program = $stdin.readlines.map(&:chomp).map do |row|
  cmd, arg = row.split(' ')
  [cmd.to_sym, arg.to_i]
end

reg_x = [1]

program.each do |cmd, arg|
  INSTRUCTIONS[cmd].times do
    reg_x << reg_x[-1]
  end
  if cmd == :addx
    reg_x[-1] = (reg_x[-1] + arg)
  end
end

puts reg_x.inspect

cycles = [20,60,100,140,180,220]
puts cycles.map { |cycle| reg_x[cycle-1]*cycle }.reduce(:+)
