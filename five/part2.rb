class SeedRange
  attr_reader :start, :stop

  def initialize(start, stop)
    @start = start
    @stop = stop
  end

  def shift(diff)
    SeedRange.new(@start + diff, @stop + diff)
  end

  def to_s
    "(#{@start}:#{@stop})"
  end

  def <=>(other)
    @start <=> other.start
  end
end

def merge_adjacent_ranges(seed_ranges)
  return seed_ranges if seed_ranges.length <= 1

  # return seed_ranges
  seed_ranges = seed_ranges.sort
  # puts "before: #{seed_ranges.length}"
  result = seed_ranges.reduce([]){ |agg,curr|
    # puts agg.to_s
    # puts curr.to_s
    if agg.length == 0 || curr.start != agg.last.stop
      agg << curr
    else
      agg[agg.length-1] = SeedRange.new(agg.last.start,curr.stop)
      agg
    end
  }
  # puts "after: #{result.length}"
  return result
end

class RangeMap
  attr_reader :start, :stop, :diff
  def initialize(start,stop,diff)
    @start = start
    @stop = stop
    @diff = diff
  end

  def to_s
    diff_str = @diff > 0 ? '+' + @diff.to_s : @diff.to_s
    return "(#{@start.to_s}:#{@stop.to_s})#{diff_str}"
  end

  # Take a range and map only the parts of it that overlap with this RangeMap
  # ((10:20)+5).map_range_strict((1:100)) -> (15:25)
  def map_range_strict(range)
    if range.start < @start && range.stop > @stop
      new_start = @start + @diff
      new_stop = @stop + @diff
    elsif range.start < @start # range starts too early
      new_start = @start + @diff
      new_stop = range.stop + @diff
    elsif range.stop > @stop # range stops too late
      new_start = range.start + @diff
      new_stop = @stop + @diff
    else # range fits inside
      new_start = range.start + @diff
      new_stop = range.stop + @diff
    end
    SeedRange.new(new_start,new_stop)
  end
end

class OrderedRangeMapList
  def initialize(orml)
    @orml = orml
    @orml = @orml.sort_by{ |x| x.start }
  end

  def to_s
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

  def map_seed_range(range)
    bottom_index = @orml.bsearch_index { |element| element.start > range.start } || @orml.length
    top_index = @orml.bsearch_index { |element| element.start > range.stop } || @orml.length

    # case 1: bottom_index == 0: whole range is below the smallest rangemap; return range unchanged
    return [range] if bottom_index == 0

    # case 2: whole range is above the largest rangemap; return range unchanged
    return [range] if top_index == @orml.length && @orml[top_index-1].stop < range.start

    agg = []
    bottom_range = @orml[bottom_index-1]
    top_range = @orml[top_index-1]

    # Catch anything that's below our lowest rangemap
    agg.append(SeedRange.new(range.start,bottom_range.start)) if range.start < bottom_range.start

    (bottom_index-1...top_index).each do |index|
      unless index == bottom_index-1 || @orml[index-1].stop == @orml[index].start
        gap_start = @orml[index-1].stop
        gap_stop = @orml[index].start-1
        agg.append(SeedRange.new(gap_start,gap_stop))
      end
      range_map=@orml[index]
      agg.append(range_map.map_range_strict(range))
    end

    # Catch anything that's above our highest rangemap
    agg.append(SeedRange.new(top_range.stop,range.stop)) unless top_range.stop >= range.stop

    return agg
  end
end

seeds = gets.match(/([0-9]+.*)/).to_s.split.map(&:to_i)
unless seeds.length.even?
  puts "bad: must have even number of seeds"
  exit 1
end

paired_seeds=seeds.each_slice(2).to_a.map {|pair| SeedRange.new(pair[0],pair[0]+pair[1])}

range_map_list = []
while (line=gets&.chomp) do
  while line&.match(/^[0-9]/)
    dest, src, range = line.split.map(&:to_i)
    range_map = RangeMap.new(src,src+range,dest-src)
    range_map_list.append(range_map)
    line = gets&.chomp
  end
  next if range_map_list.empty?
  orml = OrderedRangeMapList.new(range_map_list)

  paired_seeds = paired_seeds.map { |seed_range| orml.map_seed_range(seed_range) }.flatten
  # puts paired_seeds.to_s
  paired_seeds = merge_adjacent_ranges(paired_seeds)
  range_map_list=[]
end
puts "min: #{paired_seeds.min.start}"
