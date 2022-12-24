#!/usr/bin/env ruby

MOVES = {
  R: [:x, 1],
  L: [:x, -1],
  U: [:y, 1],
  D: [:y, -1]
}

def move(position, dir)
  delta = MOVES.fetch(dir)
  new_coord = position[delta.first] + delta.last
  position.merge({delta.first => new_coord})
end

def follow(head, tail)
  x_diff = head[:x] - tail[:x]
  y_diff = head[:y] - tail[:y]

  new_x = tail[:x]
  new_y = tail[:y]

  if x_diff.abs > 1
    new_x = tail[:x] + (x_diff/2)
    new_y = (y_diff != 0) ? head[:y] : tail[:y]
  end

  if y_diff.abs > 1
    new_y = tail[:y] + (y_diff/2)
    new_x = (x_diff != 0) ? head[:x] : tail[:x]
  end

  {x: new_x, y: new_y}
end

moves = $stdin.readlines.map(&:chomp).map do |row|
  dir, dist = row.split(' ')
  [dir.to_sym, dist.to_i]
end

rope = Array.new(2) { Array[Hash[{x:0, y:0}]] }

moves.each do |dir, count|
  count.times do
    head = rope.first
    head << move(head.last, dir)

    rope.each_cons(2) do |leader, follower|
      follower << follow(leader.last, follower.last)
    end
  end
end

puts rope.last.uniq.count
