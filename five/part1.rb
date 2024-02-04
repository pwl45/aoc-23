class Range
  def initialize(start,stop)
    @start = start
    @stop = stop
  end

  def start
    return @start
  end

  def to_s
    return "(#{@start}:#{@stop})"
  end
end

class RangeMap
  def initialize(start,stop,diff)
    @start = start
    @stop = stop
    @diff = diff
  end

  def start
    @start
  end
  def stop
    @stop
  end
  def diff
    @diff
  end

  def to_s
    diff_str = @diff > 0 ? '+' + @diff.to_s : @diff.to_s
    return "(#{@start.to_s}:#{@stop.to_s})#{diff_str}"
  end
end

class OrderedRangeMapList
  def initialize(orml)
    @orml = orml
    @orml = @orml.sort_by{ |x| x.start }
  end

  def to_s
    # @orml.to_s
    return '[ ' + @orml.map(&:to_s).join(', ') + ' ]'
  end

  def map_seed(seed)
    # return the first index where dls[index][0] (source) >= seed
    index = @orml.bsearch_index { |element| element.start > seed } || @orml.length

    return seed if index <= 0

    range_map = @orml[index-1]
    return seed unless seed.between?(range_map.start,range_map.stop-1)

    seed + range_map.diff
  end
end

seeds = gets.match(/([0-9]+.*)/).to_s.split().map(&:to_i)
# puts "seeds #{seeds}"
range_map_list = []
while (line=gets&.chomp) do
  while line&.match(/^[0-9]/)
    dest, src, range = line.split.map(&:to_i)
    range_map = RangeMap.new(src,src+range,dest-src)
    puts range_map
    range_map_list.append(range_map)
    line = gets&.chomp
  end
  next if range_map_list.empty?
  orml = OrderedRangeMapList.new(range_map_list)
  # puts orml.to_s

  seeds= seeds.map { |seed| orml.map_seed(seed) }
  range_map_list=[]
end
puts seeds.min
# puts seeds_from_range.min
