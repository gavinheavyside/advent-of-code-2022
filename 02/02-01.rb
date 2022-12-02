#!/usr/bin/env ruby

def round_score(theirs, mine)
  play_score = {
    'A' => 1,
    'B' => 2,
    'C' => 3
  }

  if theirs == mine
    3 + play_score[mine]
  elsif (theirs == 'A' && mine == 'B') || (theirs == 'B' && mine == 'C') || (theirs == 'C' && mine == 'A')
    # win
    6 + play_score[mine]
  else
    play_score[mine]
  end
end

rounds = []

while line = $stdin.gets
  rounds << line.chomp.split
end

def normalize(mine)
  {
    'X' => 'A',
    'Y' => 'B',
    'Z' => 'C'
  }[mine]
end

puts rounds.map{ |theirs, mine| round_score(theirs, normalize(mine)) }.reduce(:+)
