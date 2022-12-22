import sys
from dataclasses import dataclass
@dataclass
class Point:
    x: int
    y: int

lines = None
fname = '09.txt' if len(sys.argv) == 1 else sys.argv[1]
with open(fname) as f:
    lines = f.readlines()

def solve(rope_len):
    rope = []
    for _ in range(rope_len):
        rope.append(Point(0,0))
    track = set()

    for line in lines:
        direction, distance = line.split(' ')
        distance = int(distance)

        for _ in range(distance):
            # move H
            h = rope[0]
            if direction == 'U': h.y+=1
            elif direction == 'D': h.y-=1
            elif direction == 'L': h.x-=1
            elif direction == 'R': h.x+=1
            else: print(direction);exit(1)

            # move T
            for ti in range(1, rope_len):
                t = rope[ti]
                prev = rope[ti-1]
                xd = prev.x - t.x
                yd = prev.y - t.y

                if abs(xd)<=1 and abs(yd)<=1:
                    # touching or same location
                    pass
                elif abs(xd)>1:
                    t.x += (xd // abs(xd))  # one unit in this direction
                    if yd != 0: # diagonal - go also one step up/down
                        t.y += (yd // abs(yd))
                elif abs(yd)>1:
                    t.y += (yd // abs(yd))
                    if xd != 0:
                        t.x += (xd // abs(xd))
                else:
                    print(xd,yd); exit(1)

            # add new T location to track
            t = rope[-1]
            track.add((t.x,t.y))

            # debug: print it (only for size=5)
            if False:
                print(line)
                state = [['.' for _ in range(6)] for _ in range(5)]
                for p in track:
                    state[p[1]][p[0]] = '#'
                state[0][0] = 's'
                state[t.y][t.x] = 'T'
                state[h.y][h.x] = 'H'
                state.reverse() # y at the bottom
                print('\n'.join(["".join([x for x in row]) for row in state]))

    return len(track)

print(solve(2))
print(solve(10))
