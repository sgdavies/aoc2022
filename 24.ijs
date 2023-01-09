input=._8[\'#.#######>>.<^<##.<..<<##>v.><>##<^v^^>#######.#'  NB. Test input
snow =. }:"1}."1}:}.input  NB. Trim borders
limits =: $snow
snows =: >,=& snow each '<>^v'  NB. Split into components - left, right, up, down

NB. Validate no snow will blow into entrance or exit
updown =. +./ 2{.snows  NB. either up or down
assert. 0= +/ {.updown
assert. 0= +/ {:updown

msl =: 3 : '1|."1 y'  NB. Move snow left
msr =: 3 : '_1|."1 y'
msu =: 3 : '1|. y'
msd =: 3 : '_1|. y'
NB. Free path in minute y= '-.' not of '+./' or of each movement '"2' applied plane-by-plane '^:y' y-times
path =: 3 : '-.+./(ml`mr`mu`md)"2 ^:y snows'
paths =: ,: path 0  NB.  List of tables of open spaces, indexed by minute
getpath =: 3 : 0  NB. y=minute.  Relies on being called sequentially (no gaps)
 if. y = #paths do. paths =: (path y),paths end.
 y{paths
)

start =. _1 0
end =. limits - 1  NB. Last square in valley - not the exit square.

adjacents =: 3 : 'y +"1 (_1 0),(1 0),(0 _1),(0 1),:(0 0)'
neighbours =: 4 : 0  NB. x=limits, y=(row,col)
 maxrow=.0{x
 maxcol=.1{x
 adjs =. adjacents y
 adjs =. (_1<0{"1 adjs) #adjs  NB. Filter out any where row<0
 adjs =. (maxrow=0{"1 adjs) #adjs  NB. Filter out any where row=max (i.e. outside limit of box)
 adjs =. (_1<1{"1 adjs) #adjs  NB. col
 adjs =. (maxcol=1{"1 adjs) #adjs
 NB. If we're on (_1 0) or (0 0) we can also step [back] into the entrance, which we'll have just filtered out
 if. (_1 0 -: y) + (0 0 -: y) do. adjs =. (_1 0), adjs end.
 adjs
)

NB. TODO continue -- A* algorithm. h(x) = manhattan to exit.
