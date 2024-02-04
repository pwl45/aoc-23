lines = []
def differences(arr)
  return arr.each_cons(2).map{|xi,xj| xj-xi}
end
def extrap(arr)
  puts arr.to_s
  if arr.all?(&:zero?)
    return arr + [0]
  else
    return arr + [arr.first - extrap(differences(arr)).last]
  end
  # while (! arr.all?(&:zero?))
  #   arr = arr.each_cons(2).map{ |xi,xj| xj-xi }
  #   puts arr.to_s
  # end
  return []
end
      
sum=0
while (line = gets)
  arr = line.split.map(&:to_i)
  result = extrap(arr)
  puts result.to_s
  sum+=result.last
end

puts sum
