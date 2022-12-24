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
    new_x = tail[:x] + (x_diff/x_diff.abs)
    new_y = (y_diff != 0) ? tail[:y] + (y_diff/y_diff.abs) : tail[:y]
  end

  if y_diff.abs > 1
    new_y = tail[:y] + (y_diff/y_diff.abs)
    new_x = (x_diff != 0) ? tail[:x] + (x_diff/x_diff.abs) : tail[:x]
  end

  {x: new_x, y: new_y}
end

def display(knot)
  positions = knot.uniq
  x_pos = positions.map{ |pos| pos[:x] }
  y_pos = positions.map{ |pos| pos[:y] }

  min_x, max_x = x_pos.minmax
  min_y, max_y = y_pos.minmax

  (min_y..max_y).reverse_each do |y|
    (min_x..max_x).each do |x|
      if x==0 && y==0
        print 'S'
      elsif positions.include?({x: x, y: y})
        print '#'
      else
        print '.'
      end
    end
    print "\n"
  end
end

moves = $stdin.readlines.map(&:chomp).map do |row|
  dir, dist = row.split(' ')
  [dir.to_sym, dist.to_i]
end

rope = Array.new(10) { Array[Hash[{x:0, y:0}]] }

moves.each do |dir, count|
  count.times do
    head = rope.first
    head << move(head.last, dir)

    rope.each_cons(2) do |leader, follower|
#      puts
#      puts leader.inspect
#      puts follower.inspect
      follower << follow(leader.last, follower.last)
    end
  end
end

# display(rope.last)

puts rope.last.uniq.count
