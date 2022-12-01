#!/usr/bin/env ruby

loads = [[]]

while line = $stdin.gets
  if line.chomp.empty?
    loads << []
  else
    loads.last << Integer(line.chomp)
  end
end

puts loads.map{ |items| items.reduce(:+) }.max
