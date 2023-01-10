input=._8[\'#.#######>>.<^<##.<..<<##>v.><>##<^v^^>#######.#'  NB. Test input
input=. ];._2 freads '24.txt'
snow =. }:"1}."1}:}.input  NB. Trim borders
LIMITS =: $snow
snows =: >,=& snow each '<>^v'  NB. Split into components - left, right, up, down

NB. Validate no snow will blow into entrance or exit
validate =. 3 : 0  NB. y=snows
updown =. +./ 2}.y NB. either up or down
assert. 0= +/ {."(2 1) updown  NB. "1 last col of "2 each plane (up,down) in array
assert. 0= +/ {:"(2 1) updown
)
validate snows

msl =: 3 : '1|."1 y'  NB. Move snow left
msr =: 3 : '_1|."1 y'
msu =: 3 : '1|. y'
msd =: 3 : '_1|. y'
NB. Free path in minute y= '-.' not of '+./' or of each movement '"2' applied plane-by-plane '^:y' y-times
genpath =: 3 : '-.+./(msl`msr`msu`msd)"2 ^:y snows'
paths =: ,: genpath 0  NB.  List of tables of open spaces, indexed by minute
getpath =: 3 : 0  NB. y=minute.
 if. -. y < #paths do.
   getpath y-1
   paths =: paths, genpath y
 end.
 y{paths
)

START =: _1 0
END =: LIMITS - 1  NB. Last square in valley - not the exit square.
START2 =: END + (1 0)
END2 =: 0 0

adjacents =: 3 : 'y +"1 (_1 0),(1 0),(0 _1),(0 1),:(0 0)'
neighbours =: 4 : 0  NB. x=limits, y=(row,col)
 maxrow=.0{x
 maxcol=.1{x
 adjs =. adjacents y
 adjs =. (_1<0{"1 adjs) #adjs  NB. Filter out any where row<0
 adjs =. (maxrow>0{"1 adjs) #adjs  NB. Filter out any where maxrow is not less than row (i.e. outside limit of box)
 adjs =. (_1<1{"1 adjs) #adjs  NB. col
 adjs =. (maxcol>1{"1 adjs) #adjs
 NB. If we're on (_1 0) or (0 0) we can also step [back] into the entrance, which we'll have just filtered out
 if. (_1 0 -: y) + (0 0 -: y) do. adjs =. (_1 0), adjs end.
 if. (START2 -: y) + (END -: y) do. adjs =. (END), adjs end.  NB. part two
 adjs
)

NB. A* algorithm. h(x) = manhattan distance to exit.
NB. solved = known (fixed (g))
NB. from ?? get connected nodes
NB. calculate g & h for each
NB. remove node with lowest (g,h) and continue
a_star =: 4 : 0  NB. x=minute, y=start,end
 start=.2{.y
 end=.2}.y
 candidates =. 1 4 $ start, x, |+/ end-start  NB. row,col,g,(g+h)  g=dist to node, h=min dist to end
 while. #candidates do.
   candidate =. {.candidates
   if. end -: 2{.candidate do. break. end.  NB. We've found the answer!
   potentialsteps =. LIMITS neighbours 2{.candidate
   minute =. 1+2{candidate
   nextpath =. getpath minute
   opensteps =. (1 = (<"1 potentialsteps){nextpath) # potentialsteps  NB. filters off start point
   opensteps =. opensteps,start  NB. not quite correct - but we'll never go back to start unless it's the only option.
   manhattans =. |+/"1 end-"1 opensteps  NB. Magnitude of difference
   newcandidates =. (opensteps,"1 minute),. minute+ manhattans
   candidates =. ~. newcandidates, }.candidates
   candidates =. (/: {:"1 candidates) { candidates  NB. Sort based on {: - last column (g+h)
 end. 
 2{candidate
)

there =. 1+     0 a_star START,END
echo there
back  =. 1+ there a_star START2,END2
again =. 1+  back a_star START,END
echo again
exit 0
