require 'set'

sum=0
row=0
multipliers=Hash.new(1)
while (line = gets)
  sum+=multipliers[row]
  winners, numbers = line.chomp.match(/: (.*?) \| (.*)/).captures
  winners = Set.new(winners.split.map(&:to_i))

  wins = numbers.split.map(&:to_i).count { |n| winners.include?(n) }
  (1..wins).each do |i|
    multipliers[row+i] = multipliers[row+i]+multipliers[row]
  end
  row+=1
end
puts sum
