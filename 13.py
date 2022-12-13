# -1 if a<b, 0 if a==b, +1 if a>b
def mysort(a, b):
    for i,x in enumerate(a):
        if i == len(b): return 1 # a is longer
        
        y = b[i]
        if type(x) == type(1) and type(y) == type(1):
            if x==y: continue
            else: return -1 if x < y else 1 if x > y else 0
        
        if type(x) != type([]): x = [x]
        if type(y) != type([]): y = [y]
        
        #if m := mysort(x, y) != 0: return m
        m = mysort(x, y)
        if m != 0: return m
        # Else: match so far, try next
    return 0 if len(a)==len(b) else -1 # b may have more items still

with open('13.txt') as f:
    lines = f.readlines()

part_one = 0
all_packets = []
pair = 0
while lines:
    a = eval(lines.pop(0))
    b = eval(lines.pop(0))
    lines.pop(0) # blank line
    pair += 1

    c = mysort(a, b)
    if c <= 0: part_one += pair

    all_packets.append(a)
    all_packets.append(b)

print(part_one)

import functools
s1 = [[2]]
s2 = [[6]]
all_packets.append(s1)
all_packets.append(s2)
all_packets.sort(key=functools.cmp_to_key(mysort))

i1 = all_packets.index(s1) + 1
i2 = all_packets.index(s2) + 1
print(i1 * i2)
