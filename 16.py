import re, sys
from dataclasses import dataclass

# read input
fname = sys.argv[1] if len(sys.argv) > 1 else '16.txt'
with open(fname) as f: lines = f.readlines()
line_re = re.compile(r"Valve (?P<id>[A-Z]+) has flow rate=(?P<rate>[0-9]+); tunnel(s)? lead(s)? to valve(s)? (?P<links>.+)$")

# output: dict of 'id' : node_objects
@dataclass
class Node:
    id: str
    rate: int
    links: list

nodes = {}
for line in lines:
    if m := line_re.match(line):
        nodes[m.group("id")] = Node(m.group("id"), int(m.group("rate")), m.group("links").split(", "))
    else:
        print("Didn't match:", line)
        exit(1)

# create list of to_open nodes - nodes with flow that are currently closed
to_open = set(filter(lambda x: nodes[x].rate > 0, list(nodes)))

#print(nodes)
#print(to_open)

# possibly: calculate all fastest routes between nodes-with-flow (and AA) - will probably need this later
def dijk(start: str, targets: list, nodes: set):
    # return dict {target:distance}
    Q = set(nodes)
    dist = {n:None for n in nodes}
    dist = {n:1000000 for n in nodes}
    dist[start] = 0
    while Q:
        u = sorted(Q, key=lambda n: dist[n])[0]
        Q.remove(u)
        for v in [link for link in nodes[u].links if link in Q]:
            alt = dist[u] + 1 # cost is 1 per tunnel
            if dist[v] is None or alt < dist[v]:
                dist[v] = alt

    return dist

# double map: for shortest distance between a,b look up dists[a][b]
# or dists[b][a] - we calculate both (which is a slight waste of CPU time, but not developer time)
dists = {'AA': dijk('AA', list(to_open), nodes)}
for node in to_open:
    dists[node] = dijk(node, list(to_open), nodes)

# main algo: some kind of modified djikstra? cost(/benefit?) of next node is (30 - now - travel_time)*flow_rate
# all possible routes is 15! ~= 10**12 - not feasible to search
# some way to cut early if we can see we can't beat current best?
def explore(current: str, remaining: set, time_left: int, will_release: int):
    # current node, remaining nodes with valves, how many minutes remain, total amount of 
    # pressure that will be released by minute 30 with the set of valves that are currently open
    if not remaining: return will_release

    best = will_release
    for node in remaining:
        t = dists[current][node]
        if t+1 >= time_left:
            continue # not enough time to get there, open the valve, and something to happen
        new_left = time_left -t -1
        new_remain = set(remaining); new_remain.remove(node)
        attempt = explore(node, new_remain, new_left, will_release + new_left*nodes[node].rate)
        if attempt > best: best = attempt

    return best

print(explore('AA', to_open, 30, 0))
