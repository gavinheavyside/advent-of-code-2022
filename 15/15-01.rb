#!/usrobin/env ruby

def render(coords)
  minmax_x = coords.keys.map{ |key| key.first }.minmax
  minmax_y = coords.keys.map{ |key| key.last }.minmax

  (minmax_y.first..minmax_y.last).each do |y|
    (minmax_x.first..minmax_x.last).each do |x|
      print coords[[x,y]][:text]
    end
    print "\n"
  end
end

def remap(readings)
  coords = Hash.new { |hash, key| hash[key] = {type: :unknown, text: '.'} }
  readings.each do |reading|
    coords[[reading[:beacon][:x], reading[:beacon][:y]]] = {type: :beacon, text: 'B' }
    coords[[reading[:sensor][:x], reading[:sensor][:y]]] = {type: :sensor, text: 'S' }
  end

  puts "remapped beacons and sensors"

  coords
end

def manhattan_distance(p1, p2)
  (p1[:x] - p2[:x]).abs + (p1[:y] - p2[:y]).abs
end

def check_row(readings, coords, row_num)
  overlaps = readings.select do |reading|
    sensor = reading[:sensor]
    extent = manhattan_distance(reading[:beacon], sensor)

    (row_num - sensor[:y]).abs <= extent
  end

  puts overlaps.size

  overlaps.each do |reading|
    sensor = reading[:sensor]
    extent = manhattan_distance(reading[:beacon], sensor)

    y_offset = (row_num - sensor[:y]).abs
    lpos = sensor[:x] + y_offset - extent
    rpos = sensor[:x] + extent - y_offset

    (lpos..rpos).each do |x|
      coord = [x, row_num]
      if coords[coord][:type] == :unknown
        coords[coord] = { type: :clear, text: '#' }
      end
    end
  end

  coords.select{ |(x,y), val| y == row_num && val[:type] != :unknown && val[:type] != :beacon }.size
end

readings = $stdin.
  readlines.
  map{ |line| line.chomp.match(/Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/) }.
  map{ |coords| {sensor: {x: coords[1].to_i, y: coords[2].to_i}, beacon: {x: coords[3].to_i, y: coords[4].to_i } } }

puts "got readings"

coords = remap(readings)
puts "remapped readings"

puts check_row(readings, coords, 2000000)
