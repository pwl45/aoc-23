class Pos
  # This will create getter methods for x and y
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
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

  def connects(other, grid)
    return self.connected_neighbors(grid).include?(other)
  end

  def to_s()
    return "#{@x},#{@y}"
  end

  def inspect()
    return "#{@x},#{@y}"
  end

  def bafsa(grid)
    seen={}
    stack=[[self,0]]
    curr = nil
    while (curr,depth = stack.shift)
      puts stack.to_s
      if seen[curr]
        puts 'cycle!'
        return depth
      else
        seen[curr]=true
        # puts "#{grid[curr.y][curr.x]}(#{curr.x},#{curr.y}) -> #{curr.connected_neighbors(grid)}"
        puts "#{grid[curr.y][curr.x]}(#{curr.x},#{curr.y}) -> #{curr.connected_neighbors(grid).reject{ |p| seen[p] }}"
        stack += curr.connected_neighbors(grid).reject{ |p| seen[p] }.map{ |p| [p,depth+1] }
      end
    end
    return depth
  end
end

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
(0...grid.length).each do |y|
  row = grid[y]
  (0...row.length).each do |x|
    if grid[y][x] == 'S'
      puts "S: #{x},#{y}"
      puts "result:#{Pos.new(x,y).bafsa(grid)}"
    end
    # puts "#{x},#{y}"
  end
end
