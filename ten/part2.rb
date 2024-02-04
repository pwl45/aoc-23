require 'set'
def die(s)
  puts s
  exit 1
end

class Pos
  include Comparable
  # This will create getter methods for x and y
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def <=>(other)
    return nil unless other.is_a? Pos

    comparison = self.y <=> other.y
    return comparison.zero? ? self.x <=> other.x : comparison
  end

  def is_valid?(grid)
    return (@y >= 0 && @y < grid.length) && (@x >= 0 && @x < grid[y].length)
  end

  def neighbors()
    return [
      Pos.new(@x,@y+1),Pos.new(@x,@y-1),Pos.new(@x-1,@y),Pos.new(@x+1,@y)
    ]
  end


  def valid_neighbors(grid)
    return self.neighbors.select{|x| x.is_valid?(grid)}
  end

  def connected_neighbors(grid)
    case grid[@y][@x]
    # | is a vertical pipe connecting north and south.
    # - is a horizontal pipe connecting east and west.
    # L is a 90-degree bend connecting north and east.
    # J is a 90-degree bend connecting north and west.
    # 7 is a 90-degree bend connecting south and west.
    # F is a 90-degree bend connecting south and east.
    # . is ground; there is no pipe in this tile.
    # S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.
    when '|'
      return [Pos.new(@x,@y+1),Pos.new(@x,@y-1)].select{|p| p.is_valid?(grid)}
    when '-'
      return [Pos.new(@x+1,@y),Pos.new(@x-1,@y)].select{|p| p.is_valid?(grid)}
    when 'L'
      return [Pos.new(@x+1,@y),Pos.new(@x,@y-1)].select{|p| p.is_valid?(grid)}
    when 'J'
      return [Pos.new(@x-1,@y),Pos.new(@x,@y-1)].select{|p| p.is_valid?(grid)}
    when '7'
      return [Pos.new(@x-1,@y),Pos.new(@x,@y+1)].select{|p| p.is_valid?(grid)}
    when 'F'
      return [Pos.new(@x+1,@y),Pos.new(@x,@y+1)].select{|p| p.is_valid?(grid)}
    when '.'
      return []
    when 'S'
      return self.valid_neighbors(grid).select{ |p| p.connects(self,grid) }
    else
      return []
    end
  end

  # Override the hash method
  def hash
    [@x, @y].hash
  end

  # Override the eql? method
  def eql?(other)
    other.is_a?(Pos) && other.x == @x && other.y == @y
  end

  # It's a good practice to also override the == method when you override eql?
  def ==(other)
    eql?(other)
  end

  def distance(other)
    dx=@x-other.x
    dy=@y-other.y
    return Math.sqrt(dx*dx + dy*dy)
  end

  def connects(other, grid)
    return self.connected_neighbors(grid).include?(other)
  end

  def to_s()
    return "(#{@x},#{@y})"
  end

  def inspect()
    return "(#{@x},#{@y})"
  end

  def grid_get(grid)
    return grid[self.y][self.x]
  end

  def bafsa(grid)
    seen={}
    stack=[[self,nil,0]]
    pipes = []
    segments=[]
    seg_start=self

    while (curr,prev,depth = stack.pop)
      pipes << curr
      if ['F','J','L','7'].include?(curr.grid_get(grid))
        segments << [seg_start,curr]
        seg_start=curr
      end
      if seen[curr]
        puts 'cycle!'
        puts pipes.to_s
        return [depth,pipes,segments]
      else
        seen[curr]=true
        # puts "#{grid[curr.y][curr.x]}(#{curr.x},#{curr.y}) -> #{curr.connected_neighbors(grid)}"
        nexts=curr
                .connected_neighbors(grid)
                .reject{|x| x == prev} # don't go backwards
                .map{ |p| [p,curr,depth+1] } # add extra info
        die "too many neighbors" unless nexts.length <= 2
        # puts "#{grid[curr.y][curr.x]}(#{curr.x},#{curr.y}) -> #{nexts}"
        # stack += nexts
        stack << nexts.first
      end
    end
    return [depth,pipes,segments]
  end
end


# TODO make sure point.x between edges.xs 
def ray_cast(point,edges)
  p0 = point
  inside = false
  # intersection of x=P.x and (y-y1)=((y2-y1)/(x2-x1))
  edges.each() do |p1,p2|
    next if p1.y == p2.y
    ys = [p1.y,p2.y]
    next unless p0.y >= ys.min and p0.y < ys.max

    if p1.x == p2.x
      xints = p1.x
    else
      m = (p2.y-p1.y).to_f/(p2.x-p1.x)
      # puts "m: #{m}"
      xints = (p0.y - p1.y + m*p1.x)/m
    end
    # intersection of
    # y = y0
    # and
    # y-y1 = m(x-x1)
    # y = mx + y1 - mx1
    # y0 = mx + y1 - mx1
    # y0 - y1 + mx1 = mx
    # (y0 - y1 + mx1)/m = x
    if xints > p0.x
      inside = !inside
    end
  end
  return inside
end


# res = ray_cast(Pos.new(0,0),[[Pos.new(1,5),Pos.new(7,-5)]])
# res = ray_cast(Pos.new(0,0),[[Pos.new(1,5),Pos.new(7,5)]])


def put_grid(grid)
  grid.each do |row|
    puts row.to_s
  end
end


grid=[]
seen={}
while(line = gets)
  tiles = line.chomp.chars
  grid << tiles
end

put_grid grid

iteration=0
pipes=[]
segments=[]
(0...grid.length).each do |y|
  row = grid[y]
  (0...row.length).each do |x|
    if grid[y][x] == 'S'
      puts "S: #{x},#{y}"
      depth,pipes,segments=Pos.new(x,y).bafsa(grid)
      puts "result:#{depth}"
    end
    # puts "#{x},#{y}"
  end
end

puts "segments: #{segments} #{segments.length}"
puts "pipes: #{pipes} #{pipes.length}"



nin=0
(0...grid.length).each do |y|
  row = grid[y]
  (0...row.length).each do |x|
    pos=Pos.new(x,y)
    next if pipes.include?(pos)

    rights = (x+1...row.length)
    # puts "rights: #{rights}"
    # if rights.map{|xi| Pos.new(xi,y)}.select{|v| pipes.include?(v) && ['|','J'].include?(v.grid_get(grid))}.length.odd?
    #   puts "in! #{pos}"
    #      nin+=1
    # end
      
    # puts pos.to_s
    if ray_cast(pos,segments)
      puts "in! #{pos}"
         nin+=1
    end

  end
end

puts nin
