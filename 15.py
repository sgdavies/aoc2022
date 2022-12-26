lines = """Sensor at x=3907621, y=2895218: closest beacon is at x=3790542, y=2949630
Sensor at x=1701067, y=3075142: closest beacon is at x=2275951, y=3717327
Sensor at x=3532369, y=884718: closest beacon is at x=2733699, y=2000000
Sensor at x=2362427, y=41763: closest beacon is at x=2999439, y=-958188
Sensor at x=398408, y=3688691: closest beacon is at x=2275951, y=3717327
Sensor at x=1727615, y=1744968: closest beacon is at x=2733699, y=2000000
Sensor at x=2778183, y=3611924: closest beacon is at x=2275951, y=3717327
Sensor at x=2452818, y=2533012: closest beacon is at x=2733699, y=2000000
Sensor at x=88162, y=2057063: closest beacon is at x=-109096, y=390805
Sensor at x=2985370, y=2315046: closest beacon is at x=2733699, y=2000000
Sensor at x=2758780, y=3000106: closest beacon is at x=3279264, y=2775610
Sensor at x=3501114, y=3193710: closest beacon is at x=3790542, y=2949630
Sensor at x=313171, y=1016326: closest beacon is at x=-109096, y=390805
Sensor at x=3997998, y=3576392: closest beacon is at x=3691556, y=3980872
Sensor at x=84142, y=102550: closest beacon is at x=-109096, y=390805
Sensor at x=3768533, y=3985372: closest beacon is at x=3691556, y=3980872
Sensor at x=2999744, y=3998031: closest beacon is at x=3691556, y=3980872
Sensor at x=3380504, y=2720962: closest beacon is at x=3279264, y=2775610
Sensor at x=3357940, y=3730208: closest beacon is at x=3691556, y=3980872
Sensor at x=1242851, y=838744: closest beacon is at x=-109096, y=390805
Sensor at x=3991401, y=2367688: closest beacon is at x=3790542, y=2949630
Sensor at x=3292286, y=2624894: closest beacon is at x=3279264, y=2775610
Sensor at x=2194423, y=3990859: closest beacon is at x=2275951, y=3717327""".split("\n")

# Test data
if False: lines = """Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3""".split("\n")

class Sensor():
    def __init__(self, sx,sy, bx,by, idx):
        self.id = idx
        self.x = sx
        self.y = sy
        self.bx = bx
        self.by = by
        man = abs(sx-bx)+abs(sy-by)
        self.man = man
        self.len = man+1

        # Margins (1 outside the edges). y=mx+c, where m is either +1 (se,nw) or -1 (sw,ne).
        # So c = y1-x1 (se,nw) or y1+x1 (sw,ne).
        # x1,y1 defined as leftmost (W) end of the line.
        self.se = (self.x, self.y - self.len, (self.y - self.len) - self.x) # x, y, c
        self.ne = (self.x, self.y + self.len, (self.y + self.len) + self.x)
        self.nw = (self.x - self.len, self.y, self.y - (self.x - self.len))
        self.sw = (self.x - self.len, self.y, self.y + (self.x - self.len))

import re
re_line = re.compile("Sensor at x=(?P<sx>-?[0-9]+), y=(?P<sy>-?[0-9]+): closest beacon is at x=(?P<bx>-?[0-9]+), y=(?P<by>-?[0-9]+)")
sbs = []
for ii,line in enumerate(lines):
    if m:= re_line.match(line):
        sx,sy,bx,by = int(m.group('sx')), int(m.group('sy')), int(m.group('bx')), int(m.group('by'))
        sensor = Sensor(sx,sy,bx,by,ii)
        sbs.append(sensor)
    else:
        print("Didn't match line")
        exit(1)

# distress beacon is in the margin of 4 diamonds
# specifically, in the ne of one, se of another, nw of a 3rd and sw of a 4th.
# note margins overlap at the corners (so it may be in both nw & ne of one - but it'll still be in the nw(or nw) of another).
# there may be more than one candidate, if the 'hole' is fully covered by another diamond.
candidates = set()

for sei in range(len(sbs)):
    se = sbs[sei].se
    sel = sbs[sei].len
    sex,sey,sec = se[0], se[1], se[2]

    for nei in [i for i in range(len(sbs)) if not i==sei]:
        ne = sbs[nei].ne
        nel = sbs[nei].len
        nex,ney,nec = ne[0], ne[1], ne[2]
        # Assume both lines infitinely long, and find x-point
        # y1 = m.x1 + c1 crosses at y2 = m.x2 + c2, where m=+1 for se, -1 for ne
        # cross at x,y: y = sec+x = nec-x => x = (nec-sec)//2
        cx = (nec - sec) // 2
        if cx != (nec-sec)/2: continue # off-by-one - don't actually cross
        cy = cx + sec

        # Now filter out if the x-point is outside either line
        if not se[0] <= cx <= se[0]+sel: continue
        if not se[1] <= cy <= se[1]+sel: continue

        if not ne[0] <= cx <= ne[0]+nel: continue
        if not ne[1]-nel <= cy <= ne[1]: continue

        for nwi in [i for i in range(len(sbs)) if not (i==sei or i==nei)]:
            nw = sbs[nwi].nw
            nwl = sbs[nwi].len
            # Is the candidate point on this line?
            # Does m.xc +c equal yc? m, c from nw line (which slopes up, so m=+1)
            if cy == cx + nw[2]: # Yes!
                if not nw[0] <= cx <= nw[0]+nwl: continue
                if not nw[1] <= cy <= nw[1]+nwl: continue
                # OK, so now filter again on the final line
                for swi in [i for i in range(len(sbs)) if not (i==sei or i==nei or i==nwi)]:
                    sw = sbs[swi].sw
                    swl = sbs[swi].len
                    if cy == -cx + sw[2]: # m=-1 as sw slopes down
                        if not sw[0] <= cx <= sw[0]+swl: continue
                        if not sw[1]-swl <= cy <= sw[1]: continue
                        candidates.add((cx,cy))

# For debugging - various options to print the state. Don't use with the real data!
if False:
    #sbs=sbs[:1] # for debugging
    world = {}
    for sb in sbs:
        if False: # fill
            c = chr(ord('a') + sb.id)
            for mx in range(0, sb.man+1):
                for my in range(sb.man+1 - mx): # continue
                    world[(sb.x+mx, sb.y+my)] = c
                    world[(sb.x-mx, sb.y+my)] = c
                    world[(sb.x+mx, sb.y-my)] = c
                    world[(sb.x-mx, sb.y-my)] = c
        if False: # margins (1 outside the sensor diamond)
            c = chr(ord('A') + sb.id)
            for s in range(sb.len+1):
                world[(sb.se[0] +s, sb.se[1] +s)] = c
                world[(sb.ne[0] +s, sb.ne[1] -s)] = c
                world[(sb.nw[0] +s, sb.nw[1] +s)] = c
                world[(sb.sw[0] +s, sb.sw[1] -s)] = c
    for sb in sbs:
        world[(sb.bx, sb.by)] = '@'
        world[(sb.x, sb.y)] = chr(ord('A') + sb.id)
    for (cx,cy) in candidates:
        world[(cx,cy)] = 'X'
    world[(0,0)] = '0'

    minx = min([k[0] for k in world.keys()]) - 2
    maxx = max([k[0] for k in world.keys()]) + 2
    miny = min([k[1] for k in world.keys()]) - 2
    maxy = max([k[1] for k in world.keys()]) + 2

    grid = [ [' ' for _ in range(minx,maxx+1)] for _ in range(miny,maxy+1)]
    for (wx,wy),c in world.items():
        grid[wy -miny][wx - minx] = c
    grid.reverse() # print row 0 at the bottom
    print("\n".join(["".join([c for c in row]) for row in grid]))

# have list of candidates. Should filter them now (only keep those in the box)
for x,y in candidates:
    print(x,y, 4000000*x+y)

