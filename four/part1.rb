require 'set'

sum=0
while (line = gets)
  winners, numbers = line.chomp.match(/: (.*?) \| (.*)/).captures
  winners = Set.new(winners.split.map(&:to_i))
  sum += numbers.split.map(&:to_i).select { |n| winners.include?(n) }.reduce(0) { |total, n|  total.zero? ? 1 : total * 2 }
end
puts sum
