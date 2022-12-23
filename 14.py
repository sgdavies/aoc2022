walls = set()

lines = """498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9""".split('\n')
with open('14.txt') as f:
    lines = f.readlines()
    pass

lowest = 0
for line in lines:
    points = line.strip().split(" -> ")
    for ii in range(1,len(points)):
        p1,p2 = sorted([points[ii-1], points[ii]])
        p1 = p1.split(',')
        p2 = p2.split(',')
        x1, y1 = int(p1[0]), int(p1[1])
        x2, y2 = int(p2[0]), int(p2[1])

        if x1==x2:
            for y in range(y1,y2+1):
                walls.add((x1,y))
        else:
            for x in range(x1,x2+1):
                walls.add((x,y1))

        if y2>lowest: lowest = y2

cave = set(walls)

sand_count = 1
sx = 500
sy = 0

while True:
    if False and sand_count > 23:
        print(sand_count, sx, sy)
        import time; time.sleep(0.1)
    if sy+1 > lowest:
        break # We've entered the abyss
    elif (sx,sy+1) not in cave:
        sy+=1
    elif (sx-1,sy+1) not in cave:
        sx -= 1
        sy += 1
    elif (sx+1,sy+1) not in cave:
        sx += 1
        sy += 1
    else:  # Comes to rest
        cave.add((sx,sy))
        sand_count += 1
        sx = 500
        sy = 0

print(sand_count -1)

cave = set(walls)
sand_count = 1
sx = 500
sy = 0

while True:
    if False and sand_count > 24 and sy > 7:
        print(sand_count, sx, sy)
        import time; time.sleep(0.1)
    if (sx,sy+1) not in cave and sy+1<lowest+2:
        sy+=1
    elif (sx-1,sy+1) not in cave and sy+1<lowest+2:
        sx -= 1
        sy += 1
    elif (sx+1,sy+1) not in cave and sy+1<lowest+2:
        sx += 1
        sy += 1
    else:  # Comes to rest
        cave.add((sx,sy))
        if sx==500 and sy==0:
            break
        sand_count += 1
        sx = 500
        sy = 0

print(sand_count)

