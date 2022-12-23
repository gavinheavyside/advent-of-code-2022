#!/usr/bin/env ruby

def check_row(row)
  check_row_internal(row)
  check_row_internal(row.reverse)
end

def check_row_internal(row)
  row[0...-1].each_with_index do |src_tree, index|
    distance = row.drop(index+1).find_index do |dst_tree|
      dst_tree[:height] >= src_tree[:height]
    end
    src_tree[:sight] << (distance ? distance + 1 : (row.size - index - 1))
  end
  row.last[:sight] << 0
end

trees = $stdin.readlines.map(&:chomp).map do |row|
  row.chars.map { |tree| { height: tree.to_i, sight: [] } }
end

trees.each do |row|
  check_row(row)
end

trees.transpose.each do |row|
  check_row(row)
end

scores = trees.map do |row|
  row.map { |tree| tree[:sight].reduce(:*) }
end

puts scores.flatten.max
