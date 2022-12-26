#!/usr/bin/env ruby

require 'rgl/adjacency'
require 'rgl/path'
require 'rgl/dijkstra'

def find(char_map, letter)
  row_num = char_map.index{ |row| row =~ /#{letter}/ }
  col_num = char_map[row_num].chars.index(letter)
  [col_num, row_num]
end

char_map = $stdin.readlines

start_pos = find(char_map, 'S')
end_pos   = find(char_map, 'E')

height_map = char_map.map{|row| row.chomp.sub('S','a').sub('E','z').bytes}

graph = RGL::DirectedAdjacencyGraph.new
edge_weights_map = Hash.new{ |k,v| k[v] = 1 }

height_map.each_with_index do |row, row_num|
  row.each_cons(2).with_index do |(left,right), col_num|
    left_pos = [col_num, row_num]
    right_pos = [col_num+1, row_num]
    graph.add_edge(left_pos, right_pos) if (right - left) < 2
    graph.add_edge(right_pos, left_pos) if (left - right) < 2
  end
end

height_map.transpose.each_with_index do |column, col_num|
  column.each_cons(2).with_index do |(left,right), row_num|
    left_pos = [col_num, row_num]
    right_pos = [col_num, row_num+1]
    graph.add_edge(left_pos, right_pos) if (right - left) < 2
    graph.add_edge(right_pos, left_pos) if (left - right) < 2
  end
end

low_points = []
height_map.each_with_index do |row, row_num|
  row.each_with_index do |height, col_num|
    low_points << [col_num, row_num] if height == 97
  end
end

paths = low_points.map do |new_start|
  graph.dijkstra_shortest_path(edge_weights_map, new_start, end_pos)
end

puts paths.compact.map(&:size).sort.first - 1
