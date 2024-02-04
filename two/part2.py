import sys
import re
d={
    'red':12,
    'green':13,
    'blue':14,
}
def min_power(line):
    groups=line.split('; ')
    min_d={
        'red':0,
        'blue':0,
        'green':0,
    }
    for group in groups:
        draws = group.split(',')
        for draw in draws:
            draw = draw.lstrip()
            space_idx=draw.find(' ')
            count = int(draw[:space_idx])
            color = draw[space_idx+1:]
            min_d[color] = max(min_d[color],count)
    prod=1
    for v in min_d.values():
        prod*=v
    return prod
                
    
sum=0
for line in sys.stdin.readlines():
    id_idx_end=line.find(':')
    id_idx_start=5
#     print(line,end='')
    id = int(line[id_idx_start:id_idx_end])

    line=line[id_idx_end+2:-1]
    print(line)
    power=min_power(line)
    sum+=power

print(sum)
