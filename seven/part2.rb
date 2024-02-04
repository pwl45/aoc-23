def value(card)
 return 12 - "AKQT98765432J".index(card)
end

def type(hand)
  exit 1 unless hand.length == 5

  counts = Hash.new(0)
  hand.chars.each { |value| counts[value]+=1 }
  puts counts

  puts "#{counts.keys}"
  sorted_keys = counts.keys.sort_by{ |k| -(counts[k]*13 + value(k)) }
  puts "#{sorted_keys}"
  puts "pre counts#{counts}"
  joker_count = counts['J']
  if joker_count > 0
    first_non_joker_card = sorted_keys[0]
    if sorted_keys[0]=='J'
      if sorted_keys.length > 1
        first_non_joker_card=sorted_keys[1]
      else
        first_non_joker_card='A'
      end
    end
    counts[first_non_joker_card] += counts['J']
    counts['J'] = 0
    sorted_keys = counts.keys.sort_by{ |k| -(counts[k]*13 + value(k)) }
  end

  puts "counts: #{counts}"
  puts counts[sorted_keys[0]]*10 + ((sorted_keys.length > 1) ? counts[sorted_keys[1]] : 0)
  return counts[sorted_keys[0]]*10 + ((sorted_keys.length > 1) ? counts[sorted_keys[1]] : 0)
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
