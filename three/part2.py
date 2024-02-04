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

def neighboring_positions(y,x,grid):
    return [(x-1,y-1),(x-1,y),(x-1,y+1),(x,y-1),(x,y+1),(x+1,y-1),(x+1,y),(x+1,y+1)]


grid=[]
for line in sys.stdin.readlines():
    line=line[:-1]
    grid+=[(line)]

y=0
sum=0
num_locations={}
while y < len(grid):
    x=0
    while x < len(grid[y]):
        pos=(y,x)
        # print(type_coords(y,x,grid),end='')
        if neighbors_symbol(y,x,grid):
            pass
            # print('t',end='')
        else:
            pass
            # print ('f',end='')
        # print(' ',end='')
        if type_coords(y,x,grid) == 'd':
            num_start=x
            num_end=x

            counts=False
            while type_coords(y,num_end,grid) == 'd':
                counts = counts or neighbors_symbol(y,num_end,grid)
                # print(grid[y][num_end],end='')
                num_end+=1
            if counts:
                num=int(''.join(grid[y][num_start:num_end]))
                print(f'{num}: {y} {num_start}:{num_end}')
                sum+=num
                for num_x in range(num_start,num_end):
                    num_locations[(y,num_x)]=(num_start,num_end)
            x=num_end
        else:
            # print(grid[y][x],end='')
            x+=1
    y+=1

    print()

print(sum)
print(num_locations)
# for i in range(len(grid)):
#     print(num_locations.get(i,{}))


def get_number(pos,num_locations):
    nl=num_locations.get(pos,None)
    if num_locations.get(pos):
        return (pos[0],nl[0],nl[1])
    else:
        return None
    

y=0
newsome=0
while y < len(grid):
    x=0
    while x < len(grid[y]):
        neighbors = neighboring_positions(x,y,grid)
        if grid[y][x]=='*':
            neighbor_nums = set(filter(None,map(lambda pos: get_number(pos,num_locations), neighbors)))
            # print(f'nn:{neighbors}')
            print(f'{x},{y}: {neighbor_nums}')
            if len(neighbor_nums) == 2:
                prod=1
                for ny,num_start,num_end in neighbor_nums:
                    print('GOOD!')
                    print(ny,num_start,num_end)
                    num=int(''.join(grid[ny][num_start:num_end]))
                    print(num)
                    prod*=num
                print(prod)
                newsome+=prod
                # newsome += 
                
        # for pos in neighboring_positions(x,y,grid):
        #     print(f'{pos}:{num_locations.get(pos,None)}')
        #     nx,ny=pos

        x+=1
    y+=1
# print(neighboring_positions(0,0,grid))
print(newsome)
