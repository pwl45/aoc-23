import sys
import re
d={
    'red':12,
    'green':13,
    'blue':14,
}
def is_valid(line):
    groups=line.split('; ')
    for group in groups:
        draws = group.split(',')
        for draw in draws:
            draw = draw.lstrip()
            space_idx=draw.find(' ')
            count = int(draw[:space_idx])
            color = draw[space_idx+1:]
            if count > d.get(color):
                return False
    return True
                
    
sum=0
for line in sys.stdin.readlines():
    id_idx_end=line.find(':')
    id_idx_start=5
#     print(line,end='')
    id = int(line[id_idx_start:id_idx_end])

    line=line[id_idx_end+2:-1]
    print(line)
    if is_valid(line):
        sum+=id

print(sum)
