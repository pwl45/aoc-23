import sys
import re
patterns = [str(i) for i in range(1, 10)] + ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']
rev_patterns = [x[::-1] for x in patterns]
pattern=re.compile('|'.join(patterns))
rev_pattern=re.compile('|'.join(rev_patterns))

match_dict = {
    'one': 1,
    'two': 2,
    'three': 3,
    'four': 4,
    'five': 5,
    'six': 6,
    'seven': 7,
    'eight': 8,
    'nine': 9
}

# Add '1' to '9' mapping
for i in range(1, 10):
    match_dict[str(i)] = i

print(match_dict)
sum=0
for line in sys.stdin.readlines():
    revline = line[::-1]
    print(line[:-1])
    first=pattern.search(line).group()
    second=rev_pattern.search(revline).group()

    print(first,second)
    print(match_dict[first],match_dict[second[::-1]])
    sum+=10*(match_dict[first])+match_dict[second[::-1]]

print(sum)
