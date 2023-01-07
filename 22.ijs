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
echo width

NB. first and last non-spaces in line y.  end is more complicated - filter out #y = not found (e.g. no # on row)
start =: 3 : '<./ (y) i. ''.#'''
end =: 3 : '>./ ((#y) > (y i: ''.#'')) # (y i: ''.#'')'
walls =: 3 : '(y e. ''#'') # i.#y'  NB. indices of walls in this line

solve =: 3 : 0
NB. 10R5L13 -> 10R;5L;13X  The ,1 and ,'X' ensure we get the last entry as well.
instr =. ((y e. 'LR'),1) <;.2 (y,'X')
row =. 0
col =. (0{map) i. '.'  NB. Row,Column. Col is leftmost empty space (not ' ' or '#')
face =. 0  NB. 0=right,1=down,2=left,3=up
state =. row,col,face

while. #instr do.
  move =. {.instr
  result =. state domove move
  state =. >0{result
  newmove =. >1{result
  if. #newmove do. instr =. newmove;}.instr
  else. instr =. }.instr
  end.
end.

getvalue state
)

getvalue =: 3 : '(1000*1+0{y) + (4*1+1{y) + (2{y)'

domove =: 4 : 0
dist =. ".}:>y
turn =. {:>y
row =. 0{x
col =. 1{x
face =. 2{x
select. face
case. 0 do.  NB. right
    line =. row{map                  NB. '  #..x.#.#   '
    pos =. col
    seeline =. pos}.(1+ end line){.line NB. '  #..x.#.#' -> 'x.#.#'
    pve =. 1
    wrappos =. start line  NB. Replace with getwrap (row col face) -> (row col face)
    NB. TODO replace with wrapstate =. mappingfunc(row, col, end-line, face)
case. 2 do.  NB. left
    line =. row{map                    NB. '  #..x.#.#   '
    pos =. col
    seeline =. (start line)}.(1+pos){.line NB. '  #..x' -> '#..x'
    seeline =. |. seeline              NB. 'x..#'
    pve =. _1
    wrappos =. end line
case. 1 do.  NB. down (rows increasing)
    line =. col{"1 map
    pos =. row
    seeline =. pos}.(1+ end line){.line
    pve =. 1
    wrappos =. start line
case. 3 do.  NB. up
    line =. col{"1 map
    pos =. row
    seeline =. (start line)}.(1+pos){.line
    seeline =. |. seeline
    pve =. _1
    wrappos =. end line
end.
wrapchr =. wrappos{line
    
firstwall =. seeline i. '#'  NB. if no #, will be =#seeline (line length)
if. (-. dist < #seeline) *. (-. firstwall < #seeline) *. (-. wrapchr = '#') do.
  NB. we are going to wrap - set details for next line
  newpos =. wrappos
  newmove =. (":(dist-#seeline)),turn
  turn =. 'X'  NB. no-op
else.
  moved =. <./ (dist), (_1 + firstwall), (_1 + #seeline)
  newpos =. pos + pve*moved 
  newmove =. ''
end.

if. +/ (0 2) e. face do.
  col =. newpos  NB. row not changed
else.
  row =. newpos  NB. col not changed
end.

face =. 4| face + ('LRX' i. turn) { (_1 1 0)

(row,col,face);newmove
)

echo solve instructions
NB.exit 0

rearrangenet =. 3 : 0  NB. y= test?
NB. Rearrange the test net to match the real data net. lc=rotations
NB.   #    A      Af   f = F rotated twice
NB. ###  BCD  ->  D
NB.   ##   EF    cE    c = C rotate 1x ACW
NB.              b     b = B rotate 1x ACW
if. y do.
  mA =. (0, (2*width)) }. (width, (3*width)) {. map
  mB =. (width, 0) }. ((2*width), width) {. map
  mC =. (width, width) }. ((2*width), (2*width)) {. map
  mD =. (width, (2*width)) }. ((2*width), (3*width)) {. map
  mE =. ((2*width), (2*width)) }. ((3*width), (3*width)) {. map
  mF =. ((2*width), (3*width)) }. ((3*width), (4*width)) {. map
  mX =. (width,width) {. map  NB. blank tile
NB.   map -: ((mX,"1 mX),"1 mA),((mB,"1 mC),"1 mD),(((mX,"1 mX),"1 mE),"1 mF)
  mRB =. |:|."1 mB  NB. Rotate ACW = reflect then transpose
  mRC =. |:|."1 mC
  mRRF =. |:|."1 |:|."1 mF  NB. Two rotations
  ((mX,"1 mA),"1 mRRF),(mX,"1 mD),(mRC,"1 mE),mRB
else.
  map
end.
)

map =: rearrangenet TEST  NB. No-op for real data





NB. w=. (4,$map) $ _  NB. face x rows x cols matrix
NB. w=.5 (<0 15 3)}w  NB. efficient insert
NB.      (<0 15 3){w  NB. retrieval
DIRS =: 4 2 $ 0 1, 1 0, 0 _1, _1 0  NB. left,down,right,up - matches face
stitch =: 4 : 0  NB. x=len, y= (edge1, face1, edge2, face2) where edge =(row,col,direction)
for_i. i.len do.
  from =. ((0{y), (1{y)) + i * (2{y){DIRS
  to   =. ((4{y), (5{y)) + i * (6{y){DIRS
  w=: ((0{to),(1{to),(7{y)) ((0{from),(1{from),(3{y)) } w
end.
)
