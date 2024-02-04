require 'set'
sum = 0
multipliers = Hash.new(1)

while (line = gets)
  winners, numbers = line.chomp.match(/: (.*?) \| (.*)/).captures
  winners = Set.new(winners.split.map(&:to_i))
  
  wins = numbers.split.map(&:to_i).count { |n| winners.include?(n) }
  sum += multipliers[wins]

  (1..wins).each { |i| multipliers[i] += multipliers[0] }
end

puts sum
