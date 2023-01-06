lines =. <;._2 freads '22.txt'
instructions =. >{:lines
map =: >}:}:lines

NB. first and last non-spaces in line y.  end is more complicated - filter out #y = not found (e.g. no # on row)
start =: 3 : '<./ (y) i. ''.#'''
end =: 3 : '>./ ((#y) > (y i: ''.#'')) # (y i: ''.#'')'
walls =: 3 : '(y e. ''#'') # i.#y'  NB. indices of walls in this line

partone =: 3 : 0
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
    wrappos =. start line
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

echo partone instructions
exit 0
