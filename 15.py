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

import re
re_line = re.compile("Sensor at x=(?P<sx>-?[0-9]+), y=(?P<sy>-?[0-9]+): closest beacon is at x=(?P<bx>-?[0-9]+), y=(?P<by>-?[0-9]+)")
sbs = []
for line in lines:
    if m:= re_line.match(line):
        sx,sy,bx,by = int(m.group('sx')), int(m.group('sy')), int(m.group('bx')), int(m.group('by'))
        man = abs(sx-bx)+abs(sy-by)
        
        # margins - the pixels one beyond the diamond
        # 4 lines for each - the SE, NE, NW and SW edges
        # Each line defined as: start point (x, y), x_delta, y_delta. Note y_delta = +/- x_delta.
        # All lines defined left-to-right
        length = man + 1
        se = (sx, sy-length, length, length)
        ne = (sx, sy+length, length, -length)
        nw = (sx-length, sy, length, length)
        sw = (sx-length, sy, length, -length)

        sbs.append([(sx,sy,man), (bx,by), (se,ne,nw,sw)])
    else:
        print("Didn't match line")
        exit(1)

# distress beacon is in the margin of 4 diamonds
# specifically, in the ne of one, se of another, nw of a 3rd and sw of a 4th.
# note margins overlap at the corners (so it may be in both nw & ne of one - but it'll still be in the nw(or nw) of another).
# there may be more than one candidate, if the 'hole' is fully covered by another diamond.
candidates = set()

# could filter lines by range now - or just do it later

for sei in range(len(sbs)):
    se = sbs[sei][2][0]
    sex,sey,sel = ne[0], ne[1], ne[2]
    # First find optional single points where it crosses the first set of right-angled lines
    for nei in [i for i in range(len(sbs)) if not i==sei]:
        ne = sbs[nei][2][0]
        nex,ney,nel = ne[0], ne[1], ne[2]

        # y1 = m1.x + c1, y2 = m2.x + c2
        # => m1.x + c1 = m2.x + c2
        # => (m1-m2)x = c2-c1 => x = (c2-c1)/(m1-m2)
        # for se, m1=+1; for ne, m2=-1
        # to find c: y=mx+c, so at px,py: py=m.px+c => c = py-m.px
        # for se, c = sey - sex
        # for ne, c = ney + nex
        sec = sey-sex
        nec = ney+nex

        intx = (nec-sec)//2
        if intx != (nec-sec)/2: continue # out of step - margins don't overlap
        inty = 1*intx + sec

        # Reject the point if it's outside either of the lines (we assumed infinite length)
        if intx < sex or intx < nex: continue
        if intx > sex+sel or intx > nex+nel: continue
        if inty < sey or inty < ney+nel: continue  # careful with nel as it slopes down
        if inty > sey+sel or inty > ney: continue

        # now filter by if the point appears on another diamond's nw line
        for nwi in [i for i in range(len(sbs)) if not (i==sei or i==nei)]:
            nw = sbs[nwi][2][0]
            nwx,nwy,nwl = nw[0], nw[1], nw[2]

            # reject if it's outside the line's range
            if intx < nwx or intx > nwx+nwl: continue
            if inty < nwy or inty > nwy+nwl: continue

            # is it actually on the line? yes, if the x-delta and y-delta match
            if (intx-nwx) == (inty-nwy):
                # finally check vs the sw line
                for swi in [i for i in range(len(sbs)) if not (i==sei or i==nei or i==nwi)]:
                    sw = sbs[swi][2][0]
                    swx,swy,swl = sw[0], sw[1], sw[2]
                    # reject if it's outside the line's range
                    if intx < swx or intx > swx+swl: continue
                    elif inty < swy or inty > swy+swl: continue
                    # is it actually on the line? yes, if the x-delta and y-delta match
                    if (intx-swx) == (inty-swy):
                        candidates.add((intx,inty))

# have list of candidates. Now filter - first by box, then by coverage
BOX = 20
#new_candidates = set()
#for candidate in candidates:
#    x,y = candidate[0],candidate[1]
#    if x>=0 and x<=BOX and y>=0 and y<=BOX:
       
for x,y in candidates:
    print(x,y)

print("done")

