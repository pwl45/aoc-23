instructions = gets.chomp.chars
puts "#{instructions}"

def bail(s) puts s; exit 1 end

dir_map={}
while (line=gets)
  line = line.chomp
  next unless line.include?('=')

  puts line
  groups = line.match(/([A-z0-9]*) = \(([A-z0-9]*), ([A-z0-9]*)/).captures
  bail "bad: did not get node, left, and right from input" unless groups.length==3
  node,left,right=groups

  dir_map[node]={}
  dir_map[node+'R']=right
  dir_map[node+'L']=left
  puts "groups: #{groups}"
end

def num_steps_multi(positions,instructions,dir_map)
  steps=0
  seen=Hash.new({})
  cycles={}
  while true
    (1...positions.length).each do |i|
      if seen[i][positions[i]]
        puts "cycle! #{i} #{seen[i][positions[i]]}:#{steps}"
        next
      end
      seen[i][positions[i]] = steps
      # if starts[i] == positions[i] && steps>0
      #   puts "Cycle! #{i} #{starts[i]} steps=#{steps}"
      # end
    end
    instructions.each do |inst|
      if steps & (16384 - 1) == 0
        puts "steps=#{steps} positions=#{positions}"
      end
      # puts "steps=#{steps} positions=#{positions}"
      return steps if positions.all? { |s| s.end_with?('Z') }

      # puts inst
      positions = positions.map { |pos| dir_map[pos+inst] }
      steps+=1
      return -1 if steps == 100_000
    end
  end
end


starts = dir_map.keys.select{ |x| x.end_with?('A') }

steps = num_steps_multi(starts,instructions,dir_map)
puts "finished in #{steps} steps"
