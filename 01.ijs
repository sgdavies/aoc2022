a =. ];._2 freads '01.txt'    NB. read file as string, split on last char (LF)
a =. 0 ". a                   NB. turn into array of numbers, replacing NaN (blank) with 0
a =. > +/ each (0 = a) <;.1 a NB. cut (into box) based on which elements are zero; then sum each and unbox
echo  >./ a                   NB. Part one - max from array
echo  +/ 3{.(\:a){a           NB. Part two - sum (take 3) from (sorted index)(of b)
exit 0
