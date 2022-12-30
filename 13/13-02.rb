#!/usr/bin/env ruby

def in_order?(pair1, pair2)
  in_order = :unknown

  if pair1.nil?
    in_order = :in_order
  elsif pair2.nil?
    in_order = :out_of_order
  elsif [pair1, pair2].all? { |p| p.is_a? Integer }
    in_order = :in_order if (pair1 < pair2)
    in_order = :out_order if (pair1 > pair2)
  elsif [pair1, pair2].all? { |p| p.is_a? Array}
    [pair1.size, pair2.size].max.times do |i|
      in_order = in_order?(pair1[i], pair2[i])
      break unless in_order == :unknown
    end
  elsif [pair1, pair2].any? { |p| p.is_a? Array }
    [Array(pair1).size, Array(pair2).size].max.times.map do |i|
      in_order = in_order?(Array(pair1)[i], Array(pair2)[i])
      break unless in_order == :unknown
    end
  else
    raise "Unexpected pair #{pair1.inspect}, #{pair2.inspect}"
  end

  in_order
end

packet_pairs = $stdin.
  readlines.
  map(&:chomp).
  slice_before{ |row| row.empty? }.
  map{ |pair| pair.reject{ |line| line.empty? } }.
  map{ |pair| pair.map{|line| eval(line) } }

packet_pairs << [[[2]], [[6]]]

flattened = packet_pairs.flatten(1)

sorted = flattened.sort do |p1, p2| 
  in_order?(p1, p2) == :in_order ? -1 : 1
end

puts (sorted.index([[2]]) + 1) * (sorted.index([[6]]) + 1)
