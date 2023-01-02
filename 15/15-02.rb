#!/usr/bin/env ruby

def remap(readings, possibilities, size)
  readings.each do |reading|
    sensor = reading[:sensor]
    extent = manhattan_distance(reading[:beacon], sensor)

    y_min = [0, sensor[:y] - extent].max
    y_max = [size, sensor[:y] + extent].min

    (y_min..y_max).each do |y|

      unless possibilities[y].empty?
        y_offset = (y - sensor[:y]).abs
        lpos = [0, sensor[:x] + y_offset - extent].max
        rpos = [size, sensor[:x] + extent - y_offset].min
        possibilities[y] = update(possibilities[y], (lpos..rpos))
      end
    end
  end
end

def manhattan_distance(p1, p2)
  (p1[:x] - p2[:x]).abs + (p1[:y] - p2[:y]).abs
end

def overlaps?(range1, range2)
  range2.min <= range1.max && range2.max >= range1.min
end

def update(row, new_range)
  updated_ranges = []

  row.map do |old_range|
    if overlaps?(old_range, new_range)
      if new_range.min > old_range.min
        updated_ranges << (old_range.min..new_range.min-1)
      end

      if new_range.max < old_range.max
        updated_ranges << (new_range.max+1..old_range.max)
      end
    else
      updated_ranges << old_range
    end
  end

  updated_ranges.uniq
end

readings = $stdin.
  readlines.
  map{ |line| line.chomp.match(/Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/) }.
  map{ |coords| {sensor: {x: coords[1].to_i, y: coords[2].to_i}, beacon: {x: coords[3].to_i, y: coords[4].to_i } } }

size = 4_000_000
possibilities = Array.new(size+1, [(0..size)] )
remap(readings, possibilities, size)

y = possibilities.find_index{|p| !p.empty?}
puts y + (4_000_000 * possibilities[y].first.min)
