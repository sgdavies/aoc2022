TEST=False
if TEST:
    lines = """....#..
..###.#
#...#.#
.#...##
#.###..
##.#.##
.#..#..""".split("\n")
else:
    with open("23.txt") as f:
        lines = f.readlines()

elves = set()
for row, line in enumerate(lines):
    for col, char in enumerate(line):
        if char=='#': elves.add((row,col))

checks = [ (lambda r,c: ((r-1,c), (r-1,c-1), (r-1,c+1))), # North
           (lambda r,c: ((r+1,c), (r+1,c-1), (r+1,c+1))), # South
           (lambda r,c: ((r,c-1), (r-1,c-1), (r+1,c-1))), # West
           (lambda r,c: ((r,c+1), (r-1,c+1), (r+1,c+1))), # East
        ]
all_around = lambda r,c: ((r-1,c-1),(r-1,c),(r-1,c+1),(r,c+1),(r+1,c+1),(r+1,c),(r+1,c-1),(r,c-1))

ix = 1
while True:
    proposals = {}
    moves = []
    moved = False
    for elf in elves:
        if sum([1 if pos in elves else 0 for pos in all_around(elf[0],elf[1])]) > 0:
            for c in range(len(checks)):
                cix = (ix+c-1) % len(checks)  # -1 because we started on round=1
                pos3 = checks[cix](elf[0],elf[1])
                if sum([1 if pos in elves else 0 for pos in pos3])==0:
                    move = pos3[0]
                    if move not in proposals: proposals[move] = 0
                    proposals[move] += 1
                    moves.append((elf,move))
                    break

    # stage 2
    for elf,move in moves:
        if proposals[move] == 1:
            elves.remove(elf)
            elves.add(move)
            moved = True

    if ix==10:
        all_rows = [elf[0] for elf in elves]
        all_cols = [elf[1] for elf in elves]
        area = (1+max(all_rows)-min(all_rows))*(1+max(all_cols)-min(all_cols))
        print(area-len(elves))
    if not moved:
        if TEST:
            all_rows = [elf[0] for elf in elves]
            all_cols = [elf[1] for elf in elves]
            print("\n".join(["".join(['#' if (row,col) in elves else '.' for col in range(min(all_cols),max(all_cols)+1)]) for row in range(min(all_rows),max(all_rows)+1)]))
        print(ix)
        exit(0)
    ix+=1
