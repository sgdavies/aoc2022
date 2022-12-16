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

# all possible routes is 15! ~= 10**12 - not feasible to search
# some way to cut early if we can see we can't beat current best?
# ^ turned out not to be necessary - full DFS was fast enough
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

print(explore('AA', to_open, 30, 0)) # PART ONE

# PART TWO
# currently takes ~6 minutes to run
def explore(first: str, second: str, second_delay: int,  remaining: set, time_left: int, will_release: int):
    # as before, but now with first=location of first worker, second=destination of second worker, 
    # second_delay = time until second worker has reached & finished opening the valve at 'second'
    if not remaining: return will_release

    best = will_release
    for node in remaining:
        first_delay = dists[first][node] + 1
        if first_delay >= time_left:
            # not enough time for First to get there, open the valve, and something to happen
            if second_delay >= time_left:
                continue # nor Second
            else:
                # worry: recursion without removing from 'remaining' - although time_left does reduce, so it's ok
                attempt = explore(second, first, first_delay, remaining, time_left - second_delay, will_release)
        else:
            new_remain = set(remaining); new_remain.remove(node)
            if first_delay <= second_delay:
                new_first = node
                new_second = second
                new_left = time_left - first_delay
                new_second_delay = second_delay - first_delay
            else:
                new_first = second
                new_second = node
                new_left = time_left - second_delay
                new_second_delay = first_delay - second_delay
            
            firsts_contribution = (time_left - first_delay)*nodes[node].rate
            attempt = explore(new_first,new_second,new_second_delay, new_remain, new_left, will_release + firsts_contribution)
            if attempt > best: best = attempt

    return best

print(explore('AA', 'AA', 0, to_open, 26, 0))








