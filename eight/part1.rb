instructions = gets.chomp.chars
puts "#{instructions}"

def bail(s) puts s; exit 1 end

dir_map={}
while (line=gets)
  line = line.chomp
  next unless line.include?('=')

  puts line
  groups = line.match(/([A-z]*) = \(([A-z]*), ([A-z]*)/).captures
  bail "bad: did not get node, left, and right from input" unless groups.length==3
  node,left,right=groups

  dir_map[node]={}
  dir_map[node]['R']=right
  dir_map[node]['L']=left
  puts "groups: #{groups}"
end

def num_steps(curr,instructions,dir_map)
  steps=0
  while true
    instructions.each do |inst|
      puts "steps=#{steps} curr=#{curr}"
      return steps if curr == 'ZZZ'

      puts inst
      curr = dir_map[curr][inst]
      steps+=1
      # return -1 if steps == 1000
    end
  end
end

steps = num_steps('AAA',instructions,dir_map)
# puts "#{steps}"
