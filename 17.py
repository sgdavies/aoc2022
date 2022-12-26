class Tetroid:
    points: set
    def __init__(self, highest: int):
        assert(False) # must override

    def puff(self, direction: chr, world: set):
        if direction=='<':
            new_points = set([(x-1,y) for (x,y) in self.points])
        else:
            new_points = set([(x+1,y) for (x,y) in self.points])
            
        if self.check_new(new_points, world):
            self.points = new_points

    def drop(self, world: set):
        new_points = set([(x,y-1) for (x,y) in self.points])
        if self.check_new(new_points, world):
            self.points = new_points
            return True # dropped
        else:
            world.update(self.points) # before the drop
            return False # couldn't drop

    def check_new(self, new_points, world):
        if any([x in world for x in new_points]):
            return False # would overlap with existing block
        elif any([x<=0 for (x,y) in new_points]):
            return False # hitting left edge
        elif any([x>=8 for (x,_) in new_points]):
            return False # hitting left edge
        elif any([y<=0 for (_,y) in new_points]):
            return False # don't fall through the floor
        else:
            return True # Can make this move

    def __str__(self):
        return " ".join(["%d,%d"%(x,y) for (x,y) in self.points])

class Dash(Tetroid):
    def __init__(self, highest):
        y = highest+4 # gap of 3
        self.points = set([(3,y),(4,y),(5,y),(6,y)])

class Plus(Tetroid):
    def __init__(self, highest):
        y = highest+4
        self.points = set([(3,y+1),(4,y+1),(5,y+1), (4,y), (4,y+2)])

class L(Tetroid):
    def __init__(self, highest):
        y = highest+4
        self.points = set([(3,y),(4,y),(5,y), (5,y+1), (5,y+2)])

class I(Tetroid):
    def __init__(self, highest):
        y = highest+4
        self.points = set([(3,y),(3,y+1),(3,y+2),(3,y+3)])

class Box(Tetroid):
    def __init__(self, highest):
        y = highest+4
        self.points = set([(3,y),(4,y),(3,y+1),(4,y+1)])

def print_world(world, highest, tetroid=None):
    if tetroid:
        highest = max(highest, max([y for (_,y) in tetroid.points]))
    grid = [['|'] + ['.' for _ in range(7)] + ['|'] for _ in range(highest+1)]
    for (x,y) in world:
        grid[y][x] = '#'
    if tetroid is not None:
        for (x,y) in tetroid.points:
            grid[y][x] = '@'
        
    grid = ['+-------+'] + grid[1:]
    grid.reverse()
    print("\n".join(["".join(str(c) for c in row) for row in grid]))

puffs = ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"
with open('17.txt') as f:
    puffs = f.readlines()[0].strip()
    #print(len(puffs))
    pass

tetroids = [Dash,Plus,L,I,Box]
world = set()
highest = 0
pi = 0
last = 0
# Empirically, we get a repeating pattern after a while
# ti   pi  ti% pi% highest change_in_highest
# 1706 10091 1 0 2660      2660
# 3406 20182 1 0 5302      2642
# 5106 30273 1 0 7944      2642
# 6806 40364 1 0 10586     2642
# So do 1706 blocks to get a height of 2660
# Then every 1700 blocks after that, add on 2642
# Test data:
# 36 200 1 0 61    61
# 71 400 1 0 114   53
# 106 600 1 0 167          53
# 141 800 1 0 220          53
# 176 1000 1 0 273         53
nblocks = 1000000000000
#nblocks = 2022
sti, sdh = 1706, 2660
rti, rdh = 1700, 2642
#sti, sdh = 36, 61
#rti, rdh = 35, 53
nrepeats = (nblocks - sti) // rti
remaining = (nblocks - sti) - (rti * nrepeats)
end = sti + remaining
for ti in range(end):
    if ti==2022:print(highest)
    #print(ti, highest); import time; time.sleep(0.1)
    tetroid = tetroids[ti%len(tetroids)](highest)

    while True: # Until it lands
        if ti>0 and (ti%len(tetroids)==1) and pi%len(puffs)==0:
            #print(ti, pi, ti%len(tetroids), pi%len(puffs), highest, '\t', highest-last)
            last=highest
        tetroid.puff(puffs[pi%len(puffs)], world)
        pi += 1
        #time.sleep(0.1); print_world(world,highest, tetroid)
        landed = not tetroid.drop(world)
        #time.sleep(0.1); print_world(world,highest, tetroid)
        if landed:
            highest = max(highest, max([y for (_,y) in tetroid.points]))
            #print_world(world,highest)
            break

print(highest + (nrepeats*rdh))
