lines =. <;._2 freads '15.txt'
row =. 2000000
lobox =. 0
hibox =. 4000000
NB. uncomment to run on test data:
NB. lines =. <;._2 freads '15.test'
NB. row =. 10
NB. hibox =. 20

xym =. 3 : 0 NB. sensor x, y, beacon x, y, and manhatten range for each line
chunks=. cutopen >y NB. |Sensor|at|x=2,|y=18:|closest|beacon|is|ta|x=-2,|y=15|
sx=. ". 2}.}:>2}chunks
sy=. ". 2}.}:>3}chunks
bx=. ". 2}.}:>8}chunks
by=. ". 2}.>9}chunks  NB. Don't need to curtail as no closing punctuation
sx, sy, bx, by, ((|(sx-bx)) + (|(sy-by)))
)

sensors=.xym"1 >lines NB. Nx3 array: (x1 y1 range1), (x2 y2 range2), etc.

projection =. 4 : 0 NB. Which dots on row x can be heard by sensor y
sx=.0{y
sy=.1{y
m=.4{y
if. (|(sy-x)) > m do.
 ''
else.
 rem=. m - (|(sy-x))
 sx + (i. (1+2*rem)) - rem
end.
)

NB. unique list of beacons, then how many are on the row
beacons_on_row =. +/ row = 1{"1 ~.(2 3){"1 sensors

NB. Bug: 0-padding of (x projection"1 y) means this will add 0 even if it's not part of the visible set
NB.seen_by_sensors =. #~.,row projection"1 sensors 
NB.echo seen_by_sensors - beacons_on_row

NB. Attempt at a more efficient projection calculation
proj_2 =: 4 : 0
pairs=.''
for_ijk. y do.
	sx=.0{ijk
	sy=.1{ijk
	m=.4{ijk
	if. -. (|(sy-x)) > m do.
		rem=. m - (|(sy-x))
		pairs =. pairs, ((sx - rem), (sx + rem))
	end.
end.
pairs
)

getpairs =: 4 : 0
pairs =. x proj_2 y NB. x1 y1 x2 y2 x3 y3 etc
pairs =. (((#pairs)%2),2) $ pairs NB. two columns - x1 y1, x2 y2, etc
pairs =. pairs /: 0{"1 pairs NB. now sorted by x coordinate
)

pairs =. row getpairs sensors NB. x1 y1 x2 y2 x3 y3 etc

merge =. 3 : 0 NB. pass in the pairs above. Attempt to squash together.
NB. _2 2,2 14,2 2,12 12,14 18,16 24 => _2 24 (they all overlap)
lo =. 0{0{y
hi =. 1{0{y
p =. }.y
while. #p -. 0 do.
	if. hi < 0{0{p do.
		echo (lo, hi, 0{p)
		break.
	else.
		hi =. hi >. 1{0{p
		p =. }.p
	end.
end.
lo, hi
)

NB. Part one.  Assumes well-formed input - whole row is covered
lh =. merge pairs
echo 1 + ((1{lh) - (0{lh)) - beacons_on_row

findgap =: 4 : 0 NB. x=row, y =the pairs above. Attempt to squash together.
NB. print the answer and exit if there's a gap outside the box
row=.x
lo =. 0{0{y
hi =. 1{0{y
p =. }.y
while. #p -. 0 do.
	if. hi < _1 + 0{0{p do.
		NB. echo (x, lo, hi, 0{p)
		ans =. (x:row) + (x:4000000) * (x:hi) + (x:1)  NB. x: extended precision
		echo ans
		exit 0
		break.
	else.
		hi =. hi >. 1{0{p
		p =. }.p
	end.
end.
''
)

part2 =. 4 : 0 NB. (lo hi) part2 sensors
lo=.0{x
hi=.1{x
sensors=.y

NB. as before, but add limits from -inf-lo, hi-+inf so we don't find gaps outside the box
row =. lo
while. row < hi+1 do.
pairs =. row proj_2 sensors NB. x1 y1 x2 y2 x3 y3 etc
pairs =. (((#pairs)%2),2) $ pairs NB. two columns - x1 y1, x2 y2, etc
pairs =. (__, (lo-1)), ((hi+1), _), pairs
pairs =. pairs /: 0{"1 pairs NB. now sorted by x coordinate

row findgap pairs
row=.row+1
end.
)

(lobox, hibox) part2 sensors

exit 0
