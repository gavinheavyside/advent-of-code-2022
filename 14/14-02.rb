#!/usrobin/env ruby


def display(coords)
  minmax_x = coords.keys.map{ |(x,y)| x }.minmax
  minmax_y = coords.keys.map{ |(x,y)| y }.minmax

  0.upto(minmax_y.max) do |y|
    minmax_x.first.upto(minmax_x.last) do |x|
      print coords[[x,y]][:text]
    end
    print "\n"
  end
end

def render(nodes)
  coords = Hash.new { |hash,key| hash[key] = { type: :air, text: '.' } }

  nodes.each do |row|
    row.each_cons(2) do |p1, p2|
      x_range = [p1.first, p2.first].sort
      y_range = [p1.last, p2.last].sort

      Range.new(*x_range).each do |x|
        Range.new(*y_range).each do |y|
          coords[[x,y]] = { type: :rock, text: '#' }
        end
      end
    end
  end

  coords[[500,0]] = { type: :source, text: '+' }

  floor = coords.keys.map{ |(x,y)| y }.max + 2

  (-10000..10000).each { |i| coords[[i,floor]] = { type: :rock, text: '#' } }

  coords
end

def tick(coords, current_pos)
  new_pos = current_pos.dup

  [0,-1,1].each do |i|
    test_pos = [current_pos.first + i, current_pos.last + 1]
    if coords[test_pos][:type] == :air
      new_pos = test_pos
      break
    end
  end

  if new_pos == current_pos
    coords[current_pos] = { type: :sand, text: 'o' }
  end

  new_pos
end

nodes = $stdin.
  readlines.
  map{ |line| line.chomp.split(' -> ') }.
  map{ |points| points.map { |point| point.split(',').map(&:to_i) } }

coords = render(nodes)

# display(coords)

current_iteration = 0
max_y = coords.keys.map{ |(x,y)| y }.max

10000.times do
  current_pos = [500,0]
  full_up = false

  loop do
    new_pos = tick(coords, current_pos)
    full_up = (new_pos == [500,0])
    break if full_up || (new_pos == current_pos)
    current_pos = new_pos
  end
  break if full_up
  current_iteration = current_iteration + 1
end

# display(coords)

puts current_iteration + 1
