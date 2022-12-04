#!/usr/bin/env ruby

require 'set'

assignments = []
while line = $stdin.gets
  assignments << line.chomp.split(',').map{ |assignment| assignment.split('-') }
end

fully_contained = assignments.select do |(first, second)|
  sections1 = Set.new((first.first..first.last).to_a)
  sections2 = Set.new((second.first..second.last).to_a)

  sections1.subset?(sections2) || sections2.subset?(sections1)
end

puts fully_contained.size
