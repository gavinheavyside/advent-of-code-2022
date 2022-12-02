#!/usr/bin/env ruby

MOVES = ['A', 'B', 'C'].freeze

def round_score(theirs, mine)
  play_score = MOVES.index(mine) + 1

  if theirs == mine # draw
    play_score += 3
  elsif (MOVES.index(mine) - MOVES.index(theirs) + 3) % 3 == 1 # win
    play_score += 6
  end

  play_score
end

def move_from_goal(theirs, goal)
  if goal == 'X' # lose
    MOVES[(MOVES.index(theirs)+2) % 3]
  elsif goal == 'Y' # draw
    theirs
  else # win
    MOVES[(MOVES.index(theirs)+1) % 3]
  end
end

rounds = []

while line = $stdin.gets
  rounds << line.chomp.split
end

scores = rounds.map do |theirs, goal|
  mine = move_from_goal(theirs, goal)
  round_score(theirs, mine)
end

puts scores.reduce(:+)
