#!/usr/bin/env ruby


def check_row(row)
  row[0][:visible] = :yes
  row[-1][:visible] = :yes

  check_row_internal(row)
  check_row_internal(row.reverse)
end

def check_row_internal(row)
  max = row.first[:height]
  row[1...(row.size-1)].each do |tree|
    if tree[:height] > max
      max = tree[:height]
      tree[:visible] = :yes
    end
  end
end

trees = $stdin.readlines.map(&:chomp).map do |row|
  row.chars.map do |tree|
    {
      visible: :no,
      height: tree.to_i
    }
  end
end

trees.each do |row|
  check_row(row)
end

trees.transpose.each do |row|
  check_row(row)
end

tree_counts = trees.map do |row|
  row.select{ |tree| tree[:visible] == :yes }.size
end

puts tree_counts.reduce(:+)
