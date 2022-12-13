input =. freads '03.txt'
lines =. <;._2 input   NB. each line in a box (split on newline)

NB. Method to split a line in two
mysplit =: 3 : 0
y =. >y
size =. ($y) %2
both =. (-size) [\ y
0{both
)

NB. split line and then find the common character
common =. 3 : 0
s =. mysplit y
y1 =. 0{s
y2 =. 1{s
NB. see `d8` from https://www.jsoftware.com/help/phrases/locate_select.htm
(y1 (e.i.1:) y2) { y1
)

NB. Method to convert character to value
priority =. 3 : 0
nums =. _96 + a.i. y  NB. azAZ -> 1 26 _31 _6
NB. Add 58 to get AZ -> 27 52, with a crude filter
(nums * (0 </ nums)) + ((58 + nums) * (0 >/ nums))
)

NB. sum of values of common chars of split lines of boxes of input
echo +/ priority common "0 lines

exit 0
