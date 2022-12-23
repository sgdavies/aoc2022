lines =. <;._2 freads '15.txt'

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

row =. 2000000
NB. Bug: 0-padding of (x projection"1 y) means this will add 0 even if it's not part of the visible set
seen_by_sensors =. #~.,row projection"1 sensors 
NB. unique list of beacons, then how many are on the row
beacons_on_row =. +/ row = 1{"1 ~.(2 3){"1 sensors

echo seen_by_sensors - beacons_on_row

exit 0
