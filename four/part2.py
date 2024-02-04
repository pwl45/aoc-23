import sys
sum=0
multipliers={}
row=0
for line in sys.stdin.readlines():
    sum+=multipliers.get(row,1)
    line = line[line.find(':') + 2:-1].replace('  ',' ')
    halves = line.split(' | ')
    print(halves)
    winners = set(halves[0].split(' '))
    wins=0
    for num in halves[1].split(' '):
        if num in winners:
            print(f'{num} is winner')
            print(f'multiplier:{multipliers.get(row,1)} inc mulitplier for row={row+wins}->{multipliers.get(row+wins,1)}')
            wins+=1
            multipliers[row+wins] = multipliers.get(row+wins,1)+multipliers.get(row,1)
    # sum += card_total
    row+=1

print(sum)
