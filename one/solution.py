import sys
import re
dig_reg=re.compile('\d')
sum=0
for line in sys.stdin.readlines():
    digs=dig_reg.findall(line)
    sum += int(digs[0])*10 + int(digs[-1])
print(sum)
