def value(card)
 return 12 - "AKQJT98765432".index(card)
end

def type(hand)
  puts "hand: #{hand}"
  counts = hand.chars.group_by {|e| e}.map{|key,values| [key,values.length]}
  counts = counts.sort_by{|count| -count[1]}
  puts "#{counts}"
  puts counts[0][1]*10 + ((counts.length > 1) ? counts[1][1] : 0)
  return counts[0][1]*10 + ((counts.length > 1) ? counts[1][1] : 0)
end

def strength(hand)
  type_val = type(hand)
  total_strength=0
  multiplier=1
  hand.chars.reverse_each do |card|
    total_strength+=value(card)*multiplier
    multiplier*=13
  end
  total_strength+=multiplier*type_val
  return total_strength
end

hands=[]
while(line = gets)
  line=line.chomp
  hands << line.split
end

hand_strengths=[]
hands.each do |hand,bet|
  puts "#{hand},#{bet}"
  hand_strength = strength(hand)
  puts "strength: #{hand_strength}"
  hand_strengths << [hand_strength,hand,bet]
end

sorted_hands = hand_strengths.sort_by{|x| x[0]}
puts "#{sorted_hands}"
bet_multiplier=1
total_winnings=0
sorted_hands.each do |hand|
  hand_winnings=bet_multiplier*hand[2].to_i
  puts "#{hand} wins #{bet_multiplier}*#{hand[2]}=#{hand_winnings}"
  total_winnings+=hand_winnings
  bet_multiplier+=1
end
puts total_winnings
