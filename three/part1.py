import sys
def is_symbol(c):
    return c in '#%&*+-/=@$'

def is_digit(c):
    return c in '1234567890'

def type(c):
    if is_symbol(c):
        return 's'
    elif is_digit(c):
        return 'd'
    else:
        return '.'

def type_coords(x,y,grid):
    if x >= len(grid):
        return '.'
    elif y >= len(grid[x]):
        return '.'
    else:
        return type(grid[x][y])

def type_pos(pos,grid):
    return type_coords(pos[0],pos[1],grid)

def neighbors_symbol(x,y,grid):
    for pos in [(x-1,y-1),(x-1,y),(x-1,y+1),(x,y-1),(x,y+1),(x+1,y-1),(x+1,y),(x+1,y+1)]:
        if type_pos(pos,grid) == 's':
            return True
    return False


grid=[]
for line in sys.stdin.readlines():
    line=line[:-1]
    grid+=[(line)]

y=0
sum=0
while y < len(grid):
    x=0
    while x < len(grid[y]):
        pos=(y,x)
        print(grid[y][x],end='')
        print(type_coords(y,x,grid),end='')
        if neighbors_symbol(y,x,grid):
            print('t',end='')
        else:
            print ('f',end='')
        print(' ',end='')
        if type_coords(y,x,grid) == 'd':
            num_start=x
            num_end=x

            counts=False
            while type_coords(y,num_end,grid) == 'd':
                counts = counts or neighbors_symbol(y,num_end,grid)
                num_end+=1
            if counts:
                print(''.join(grid[y][num_start:num_end]))
                sum+=int(''.join(grid[y][num_start:num_end]))
            #     num_end +=1
            # counts = counts or type_coords(num_end+1,x,grid
            x=num_end
        else:
            x+=1
    y+=1

    print()

print(sum)
