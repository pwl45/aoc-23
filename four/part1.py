import sys
import re
from functools import reduce

sum=0
for line in sys.stdin.readlines():
    winners,numbers = re.match(r'.*: (.*?) \| (.*)', line).groups()
    winners = set([int(x) for x in winners.split()])
    sum += reduce(lambda total, n: 1 if total == 0 else total*2, filter(lambda x: x in winners,[int(x) for x in numbers.split()]),0)

print(sum)
