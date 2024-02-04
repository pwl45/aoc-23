#!/usr/bin/env ruby
n = gets.split(':')[1].gsub(' ','').to_i
g = gets.split(':')[1].gsub(' ','').to_i

puts "#{n},#{g}"
discriminant = (n*n - 4*g)
if discriminant < 0
  puts 0
end
puts "disc: #{discriminant}"
bottom = (1*n - Math.sqrt( discriminant )) /2
true_bottom = ([bottom,0.1].max+1).floor
top = (1*n + Math.sqrt( discriminant )) /2
true_top= (top-1).ceil
puts "#{top},#{bottom},#{top-bottom}"
puts "#{true_top},#{true_bottom},#{true_top-true_bottom+1}"
puts true_top-true_bottom+1
 
# prod = 1
# (0...times.length).each do |i|
#   n = times[i]
#   g = distances[i]
#   puts "#{n},#{g}"
#   discriminant = (n*n - 4*g)
#   if discriminant < 0
#     puts 0
#     next
#   end
#   puts "disc: #{discriminant}"
#   bottom = (1*n - Math.sqrt( discriminant )) /2
#   true_bottom = ([bottom,0.1].max+1).floor
#   top = (1*n + Math.sqrt( discriminant )) /2
#   true_top= (top-1).ceil
#   puts "#{top},#{bottom},#{top-bottom}"
#   puts "#{true_top},#{true_bottom},#{true_top-true_bottom+1}"
#   puts true_top-true_bottom+1
#   prod*=(true_top-true_bottom+1)

# end

# puts prod
