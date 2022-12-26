#!/usr/bin/env ruby

def parse_config(section)
  m = section[0].match /Monkey (\d+):$/
  monkey = m[1].to_i

  m = section[1].match /Starting items: (.+)$/
  starting_items = m[1].split(', ').map(&:to_i)

  m = section[2].match /Operation: new = (old.+)$/
  operation = m[1]

  m = section[3].match /Test: divisible by (\d+)$/
  test = m[1].to_i

  m = section[4].match /true: throw to monkey (\d+)$/
  if_true = m[1].to_i

  m = section[5].match /false: throw to monkey (\d+)$/
  if_false = m[1].to_i

  [ monkey, {
      items: starting_items,
      operation: operation,
      test: test,
      if_true: if_true,
      if_false: if_false,
      inspections: 0
    }
  ]
end

def process(contents, monkeys)
  contents[:inspections] += contents[:items].size

  examined = contents[:items].map do |worry|
    eval contents[:operation].gsub('old', worry.to_s)
  end
  relieved = examined.map{ |worry| (worry / 3.0).floor }
  if_true, if_false = relieved.partition do |worry|
    worry % contents[:test] == 0
  end

  monkeys[contents[:if_true]][:items] += if_true
  monkeys[contents[:if_false]][:items] += if_false
  contents[:items] = []
end

program = $stdin.readlines.map(&:chomp)
sections = program.slice_before{ |row| row.empty? }.map{ |section| section.reject{ |line| line.empty? } }

monkeys = Hash[sections.map { |section| parse_config(section) }]

puts monkeys.inspect

20.times do
  monkeys.each do |monkey, contents|
    process(contents, monkeys)
  end
end

puts
puts monkeys.inspect

puts
puts monkeys.map{|k,v| v[:inspections]}.sort.reverse.take(2).reduce(:*)
