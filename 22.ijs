TEST=:0
getlines=. 3 : 0
if. y do.
  lines =. <;._2 freads '22.test'
else.
  lines =. <;._2 freads '22.txt'
end.
)
lines =. getlines TEST
instructions =. >{:lines
map =: >}:}:lines
width =: %: 6%~ +/+/ -. ' ' = map  NB. width of each tile (sqrt of area of each of the 6 faces)

NB. first and last non-spaces in line y.  end is more complicated - filter out #y = not found (e.g. no # on row)
start =: 3 : '<./ (y) i. ''.#'''
end =: 3 : '>./ ((#y) > (y i: ''.#'')) # (y i: ''.#'')'
walls =: 3 : '(y e. ''#'') # i.#y'  NB. indices of walls in this line

solve =: 4 : 0  NB. x=parttwo? y=instructions string.  Relies on global map.
NB. 10R5L13 -> 10R;5L;13X  The ,1 and ,'X' ensure we get the last entry as well.
instr =. ((y e. 'LR'),1) <;.2 (y,'X')
row =. 0
col =. (0{map) i. '.'  NB. Row,Column. Col is leftmost empty space (not ' ' or '#')
face =. 0  NB. 0=right,1=down,2=left,3=up
state =. row,col,face

while. #instr do.
  move =. >{.instr
  result =. (state,x) domove move
  state =. >0{result
  newmove =. >1{result
  if. #newmove do. instr =. newmove;}.instr
  else. instr =. }.instr
  end.
end.

getvalue state
)

getvalue =: 3 : '(1000*1+0{y) + (4*1+1{y) + (2{y)'

domove =: 4 : 0  NB. x=state (row,col,face,parttwo?), y=instr ('10R')
dist =. ".}:>y
turn =. {:>y
row =. 0{x
col =. 1{x
face =. 2{x
isparttwo =. 3{x
select. face
case. 0 do.  NB. right
    line =. row{map                  NB. '  #..x.#.#   '
    pos =. col
    seeline =. pos}.(1+ end line){.line NB. '  #..x.#.#' -> 'x.#.#'
    pve =. 1
    if. isparttwo do. wrappos =. mapping (row, col, face)
    else. wrappos =. (row, (start line), face) end.
case. 2 do.  NB. left
    line =. row{map                    NB. '  #..x.#.#   '
    pos =. col
    seeline =. (start line)}.(1+pos){.line NB. '  #..x' -> '#..x'
    seeline =. |. seeline              NB. 'x..#'
    pve =. _1
    if. isparttwo do. wrappos =. mapping (row, col, face)
    else. wrappos =. (row, (end line), face) end.
case. 1 do.  NB. down (rows increasing)
    line =. col{"1 map
    pos =. row
    seeline =. pos}.(1+ end line){.line
    pve =. 1
    if. isparttwo do. wrappos =. mapping (row, col, face)
    else. wrappos =. ((start line), col, face) end.
case. 3 do.  NB. up
    line =. col{"1 map
    pos =. row
    seeline =. (start line)}.(1+pos){.line
    seeline =. |. seeline
    pve =. _1
    if. isparttwo do. wrappos =. mapping (row, col, face)
    else. wrappos =. ((end line), col, face) end.
end.
wrapchr =. (<2{.wrappos){map
    
firstwall =. seeline i. '#'  NB. if no #, will be =#seeline (line length)
if. (-. dist < #seeline) *. (-. firstwall < #seeline) *. (-. wrapchr = '#') do.
  NB. we are going to wrap - set details for next line
  row =. 0{wrappos
  col =. 1{wrappos
  face =. 2{wrappos
  newmove =. (":(dist-#seeline)),turn
else.
  moved =. <./ (dist), (_1 + firstwall), (_1 + #seeline)
  newpos =. pos + pve*moved 
  if. +/ (0 2) e. face do.
    col =. newpos  NB. row not changed
  else.
    row =. newpos  NB. col not changed
  end.
  newmove =. ''
face =. 4| face + ('LRX' i. turn) { (_1 1 0)
end.

(row,col,face);newmove
)

echo 0 solve instructions
NB.exit 0

NB. Part two.  How you move from tile to tile depends on the net arrangement.
NB. To make things simpler, rearrange the test net so it matches the real net.
NB. Then we can test the wrapping (tile-to-tile) solution, without having to
NB. code up all possible nets (there are 11, plus rotations & reflections).

rearrangenet =. 3 : 0  NB. y= test?
NB. Rearrange the test net to match the real data net.
NB.   #    A      Af   f = F rotated twice
NB. ###  BCD  ->  D
NB.   ##   EF    cE    c = C rotate 1x ACW
NB.              b     b = B rotate 1x ACW
if. y do.  NB. only rearrange the test data - real data is already correct
  mA =. (0, (2*width)) }. (width, (3*width)) {. map
  mB =. (width, 0) }. ((2*width), width) {. map
  mC =. (width, width) }. ((2*width), (2*width)) {. map
  mD =. (width, (2*width)) }. ((2*width), (3*width)) {. map
  mE =. ((2*width), (2*width)) }. ((3*width), (3*width)) {. map
  mF =. ((2*width), (3*width)) }. ((3*width), (4*width)) {. map
  mX =. (width,width) {. map  NB. blank tile
NB.   map -: ((mX,"1 mX),"1 mA),((mB,"1 mC),"1 mD),(((mX,"1 mX),"1 mE),"1 mF)
  mRB =.  |:|."1 mB  NB. Rotate ACW = reflect then transpose
  mRC =.  |:|."1 mC
  mRRF =. |:|."1 |:|."1 mF  NB. Two rotations
  ((mX,"1 mA),"1 mRRF),(mX,"1 mD),(mRC,"1 mE),mRB
else.
  map
end.
)

mapping =: 3 : 0  NB. y=(row,col,face)
row=.0{y   NB.   AF  14 cases/edges, fully determined by face & position
col=.1{y   NB.   D
face=.2{y  NB.  CE
NB.        NB.  B
select. face
  case. 0 do.  NB. facing right
    if. row < width do.  NB. F->E (in from right)
      nrow =. (3*width) - 1+row
      ncol =. (2*width) - 1
      nface =. 2  NB. left
    elseif. row < 2*width do.  NB. D->F (in from bottom)
      nrow =. width -1
      ncol =. (2*width) + (row-width)
      nface =. 3  NB. up
    elseif. row < 3*width do.  NB. E->F (in from right) [2w:3w-1 -> w-1:0]
      nrow =. (width) - (1 + row -2*width)
      ncol =. (3*width) - 1
      nface =. 2  NB. left
    else.  NB. B->E (from below)
      nrow =. (3*width) -1
      ncol =. (row - 3*width) + width
      nface =. 3  NB. up
    end.
  case. 1 do.  NB. facing down
    if. col < width do.  NB. B->F (in from above)
      nrow =. 0
      ncol =. col + 2*width
      nface =. 1  NB. down
    elseif. col < 2*width do.  NB. E->B (from the right)
      nrow =. (3*width) + (col - width)
      ncol =. width -1
      nface =. 2  NB. left
    else.  NB. F->D (from the right)
      nrow =. width + (col - 2*width)
      ncol =. (2*width) -1
      nface =. 2  NB. left
    end.
  case. 2 do.  NB. facing left
    if. row < width do.  NB. A->C (from the left)
      nrow =. (3*width) - (1+row)
      ncol =. 0
      nface =. 0  NB. right
    elseif. row < 2*width do.  NB. D->C (from above)
      nrow =. 2*width
      ncol =. row - width
      nface =. 1  NB. down
    elseif. row < 3*width do.  NB. C->A (from left)
      nrow =. (3*width) - (1+row)
      ncol =. width
      nface =. 0  NB. right
    else.  NB. B->A (from above)
      nrow =. 0
      ncol =. (row - 3*width) + width
      nface =. 1  NB. down
    end.
  case. 3 do.  NB. facing up
    if. col < width do.  NB. C->D (from left)
      nrow =. width + col
      ncol =. width
      nface =. 0  NB. right
    elseif. col < 2*width do.  NB. A->B (from left)
      nrow =. (col - width) + 3*width
      ncol =. 0
      nface =. 0  NB. right
    else.  NB. F->B (from below)
      nrow =. (4*width) -1
      ncol =. col - 2*width
      nface =. 3  NB. up
    end.
end.
nrow, ncol, nface
)

map =: rearrangenet TEST  NB. No-op for real data

echo 1 solve instructions  NB. using new mapping function when wrapping

exit 0
