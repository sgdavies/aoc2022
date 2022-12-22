from dataclasses import dataclass
@dataclass
class Node:
    h: int
    links: set

def dijk(start, target, nodes: dict):
    Q = set(nodes)
    dists = {n:1000000 for n in nodes}
    dists[start] = 0
    while Q:
        u = sorted(Q, key=lambda n: dists[n])[0]
        Q.remove(u)
        for v in [link for link in nodes[u].links if link in Q]:
            alt = dists[u] + 1 # cost is 1 per link
            if dists[v] is None or alt < dists[v]:
                dists[v] = alt

    return dists

test = """Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi"""
lines = test.split('\n')

with open('12.txt') as f:
    lines = f.readlines()
    pass

def val(c):
    if c=='S': return ord('a')
    elif c=='E': return ord('z')
    else: return ord(c)

#nodes = {}
back_nodes = {}
all_starts = []
for y, line in enumerate(lines):
    line = line.strip()
    for x, c in enumerate(line):
        #nodes[(x,y)] = Node(val(c), set())
        back_nodes[(x,y)] = Node(val(c), set())
        if c == 'S': start = (x,y)
        elif c == 'E': end = (x,y)
        elif c=='a': all_starts.append((x,y))

for y, line in enumerate(lines):
    line = line.strip()
    for x in range(len(line)):
        #n = nodes[(x,y)]
        #if y>0              and n.h+1 >= nodes[(x,y-1)].h: n.links.add((x,y-1))
        #if y<(len(lines)-1) and n.h+1 >= nodes[(x,y+1)].h: n.links.add((x,y+1))
        #if x>0              and n.h+1 >= nodes[(x-1,y)].h: n.links.add((x-1,y))
        #if x<(len(line)-1)  and n.h+1 >= nodes[(x+1,y)].h: n.links.add((x+1,y))

        b = back_nodes[(x,y)]
        if y>0              and b.h-1 <= back_nodes[(x,y-1)].h: b.links.add((x,y-1))
        if y<(len(lines)-1) and b.h-1 <= back_nodes[(x,y+1)].h: b.links.add((x,y+1))
        if x>0              and b.h-1 <= back_nodes[(x-1,y)].h: b.links.add((x-1,y))
        if x<(len(line)-1)  and b.h-1 <= back_nodes[(x+1,y)].h: b.links.add((x+1,y))

all_starts = [start] + all_starts

dists = dijk(end, start, back_nodes)
a_dists = [dists[a] for a in all_starts]
print(a_dists[0])
print(min(a_dists))
