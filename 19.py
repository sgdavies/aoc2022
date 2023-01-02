blueprints=["Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.",
        "Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian."]

with open('19.txt') as f:
    blueprints = f.readlines()

import re,math
re_bp = re.compile("Blueprint [0-9]+: Each ore robot costs ([0-9]+) ore. Each clay robot costs ([0-9]+) ore. Each obsidian robot costs ([0-9]+) ore and ([0-9]+) clay. Each geode robot costs ([0-9]+) ore and ([0-9]+) obsidian.")

matches = [re_bp.match(row) for row in blueprints]
builds = [[
          [int(m.group(5)), 0, int(m.group(6)),0, 3],
          [int(m.group(3)), int(m.group(4)),0,0, 2],
          [int(m.group(2)), 0,0,0, 1],
          [int(m.group(1)), 0,0,0, 0],
          [0,0,0,0, None]
         ] for m in matches]

def partonea(builds, resources, robots, minleft, best):
    if minleft==0: return max(best, resources[3])

    for build in builds:
        # Estimate an upper bound for the number of geodes we might get in this branch
        lg = resources[3] + robots[3]*minleft
        c_r = robots[1]
        clay = resources[1]
        o_r = robots[2]
        obsi = resources[2]
        for ml in range(minleft, 0, -1): # stops at 1
            if obsi >= builds[0][2]:  # can build another geo robot
                lg += (ml-1) # 1 to build it
                obsi -= builds[0][2]
                n_c_r, n_o_r = c_r, o_r
            elif clay >= builds[1][1]:
                n_c_r, n_o_r = c_r, o_r+1
                clay -= builds[1][1]
            else: # Assume we can build a claybot
                n_c_r, n_o_r = c_r + 1, o_r
            clay += c_r
            obsi += o_r
            c_r, o_r = n_c_r, n_o_r

        ludicrous_geo = lg
        if ludicrous_geo <= best: continue

        if all([resources[i] >= build[i] for i in range(4)]):
            new_resources = [resources[i] + robots[i] - build[i] for i in range(4)]
            new_robots = list(robots)
            if build[4] is not None: new_robots[build[4]] += 1
            attempt = partonea(builds, new_resources, new_robots, minleft-1, best)
            if attempt > best: best = attempt

    return best

#print(partonea(builds, [0,0,0,0], [1,0,0,0], 24, 0))
total = 0
for i, build in enumerate(builds):
    n=i+1
    ans = partonea(build, [0,0,0,0], [1,0,0,0], 24, 0)
    val = n*ans
    total += val
print(total)
