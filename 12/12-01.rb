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

shortest_path = graph.dijkstra_shortest_path(edge_weights_map, start_pos, end_pos)

puts shortest_path.size - 1
