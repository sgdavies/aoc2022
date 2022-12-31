input =. freads '18.txt'
lines =. <;._2 input

NB. faces (a b c) creates a list of the six faces of cube a,b,c
NB. Output is x,y,z, c. x,y,z=coords of face centre
NB. c is code for face direction. 1=left (-ve x), 2=right, 3=back(-ve y), 4=fwd, 5=down(z),6=up
faces=. 3 : 0
a=.0{y
b=.1{y
c=.2{y
x=.0 0 $ 0  NB. set the shape before appending
x=.x,(a-0.5), b, c,1
x=.x,(a+0.5), b, c,2
x=.x,a, (b-0.5), c,3
x=.x,a, (b+0.5), c,4
x=.x,a, b, (c-0.5),5
x=.x,a, b, (c+0.5),6
x
)

to_nums =. 3 : 0
y=.>y
". ];._1 ',' , y
)

NB. ,/,/ to end up with a list of faces.
f=. ,/,/faces"1 to_nums"1 lines NB. $(output) is 1 13 6 3. Doing ,/ twice gets us to 1*13*6 = 78 by 3.
NB. =f gives a (len ~.f) (len) array with 1 for each index where that row appears in f
NB. Count how many times that sums to 1, i.e. that face only appears once in the list of faces
NB. echo +/ 1= +/"1 = f NB. part one (count of faces that only appear once in list)

NB. Part two - actually we want the list of surface faces
g=. 3{."1 f NB. ignore the 'face direction' column
NB. =g is (nub g) by (g). Select the rows from that where there's only a single 1 (00100,01000,etc)
NB. then use those rows to select from f (which has the face direction column)
NB. finally ,/ to got from $N 1 4 to $N 4 (N=number of surface faces)
sf=. ,/((1= +/"1 = g) # =g) # f
echo 0{ $sf NB. part one

NB. Part two algorithm: starting from a known external face, paint it and then crawl to each
NB. of its 4 connected faces.  Repeat until there are no more candidate faces.
NB. More formally: have list of all surface faces, list of candidates to check, and list of known external faces.
NB. Start with a single known external in the unpainted list (e.g. the highest surface face - must be external).
NB. While there are still unpainted faces: take a candidate and add it to the painted list; get the 4 connected faces,
NB. and for any not in the painted or unpainted lists, add it to the unpainted list.
NB. Connected faces: from each edge, potential faces go up (convex edge), along (flat), or down (concave edge).
NB. (Simple) only one of these 3 options can exist in the list of surface faces, so select it and add to the
NB. candidate list and continue.
NB. (Complex) If two boxes are stacked diagonally (with a gap beneath), then all 3 face options will exist in
NB. the surfaces list.  In that case, the 'up' surface is external, and the flat/down surfaces are internal.
NB. So if three faces match, select the 'up' one for the next candidate.
unpainted =. 1 4 $ 0{/:~sf  NB. Table (1 entry) seeded with 'lowest' surface from the list
painted =. 0 0 $ 0 NB. Empty table

part_two =. 3 : 0 NB. sf ; unpainted; painted
sf =. >0{y
up =. >1{y  NB. unpainted
pa =. >2{y  NB. painted
while. #up do.
  NB. Examine a face - remove from candidates and add to externals
  face=. 0{up
  up=. }.up
  pa=. pa,face

  NB. To get the new candidate faces:
  NB. - get the 3 potential faces from each edge (in order - concave first)
  NB. - select the first of each 3 that exists in the surface list (i.e. the external surface which links to this face)
  NB. - add the 4 new candidates to the unpainted list (if not already there / in the painted list)
  potentials =. getcandidates face
  candidates =. sf prunecandidates potentials

  candidates =. (-. candidates e. pa) # candidates  NB. Select all the ones that aren't painted yet
  up =. ~. up,candidates  NB. and add to the unpainted list
end.
pa
)

getcandidates =: 3 : 0
face=.y
x=.0{face
y=.1{face
z=.2{face
ft=. 3{face NB. face type

NB. For each edge of this face, create a list of 3 potential new faces
NB. (concave, flat, convex)
NB. Return these 4 sets of 3 faces.
NB. face => (n1,n2,n3),(e1,e2,e3),(s1,s2,s3),(w1,w2,w3)
cfs=.0 0 0 $ 0
select. ft
  case. 1 do.  NB. facing -ve x
    cfs=.cfs,((x-0.5), y, (z-0.5), 6), (x, y, (z-1), 1),: ((x+0.5), y, (z-0.5), 5)  NB. off bottom (-z) edge
    cfs=.cfs,((x-0.5), y, (z+0.5), 5), (x, y, (z+1), 1),: ((x+0.5), y, (z+0.5), 6)  NB. top (+z)
    cfs=.cfs,((x-0.5), (y-0.5), z, 4), (x, (y-1), z, 1),: ((x+0.5), (y-0.5), z, 3)  NB. back (-y)
    cfs=.cfs,((x-0.5), (y+0.5), z, 3), (x, (y+1), z, 1),: ((x+0.5), (y+0.5), z, 4)  NB. front (+y)
  case. 2 do.  NB. +ve x
    cfs=.cfs,((x+0.5), y, (z-0.5), 6), (x, y, (z-1), 2),: ((x-0.5), y, (z-0.5), 5)  NB. bottom (-z) edge
    cfs=.cfs,((x+0.5), y, (z+0.5), 5), (x, y, (z+1), 2),: ((x-0.5), y, (z+0.5), 6)  NB. top (+z)
    cfs=.cfs,((x+0.5), (y-0.5), z, 4), (x, (y-1), z, 2),: ((x-0.5), (y-0.5), z, 3)  NB. back (-y)
    cfs=.cfs,((x+0.5), (y+0.5), z, 3), (x, (y+1), z, 2),: ((x-0.5), (y+0.5), z, 4)  NB. front (+y)
  case. 3 do.  NB. -ve y
    cfs=.cfs,(x, (y-0.5), (z-0.5), 6), (x, y, (z-1), 3),: (x, (y+0.5), (z-0.5), 5)  NB. bottom (-z)
    cfs=.cfs,(x, (y-0.5), (z+0.5), 5), (x, y, (z+1), 3),: (x, (y+0.5), (z+0.5), 6)  NB. top (+z)
    cfs=.cfs,((x-0.5), (y-0.5), z, 2), ((x-1), y, z, 3),: ((x-0.5), (y+0.5), z, 1)  NB. left (-x)
    cfs=.cfs,((x+0.5), (y-0.5), z, 1), ((x+1), y, z, 3),: ((x+0.5), (y+0.5), z, 2)  NB. right (+x)
  case. 4 do.  NB. +ve y
    cfs=.cfs,(x, (y+0.5), (z-0.5), 6), (x, y, (z-1), 4),: (x, (y-0.5), (z-0.5), 5)  NB. bottom (-z)
    cfs=.cfs,(x, (y+0.5), (z+0.5), 5), (x, y, (z+1), 4),: (x, (y-0.5), (z+0.5), 6)  NB. top (+z)
    cfs=.cfs,((x-0.5), (y+0.5), z, 2), ((x-1), y, z, 4),: ((x-0.5), (y-0.5), z, 1)  NB. left (-x)
    cfs=.cfs,((x+0.5), (y+0.5), z, 1), ((x+1), y, z, 4),: ((x+0.5), (y-0.5), z, 2)  NB. right (+x)
  case. 5 do.  NB. -ve z
    cfs=.cfs,((x-0.5), y, (z-0.5), 2), ((x-1), y, z, 5),: ((x-0.5), y, (z+0.5), 1)  NB. left (-x)
    cfs=.cfs,((x+0.5), y, (z-0.5), 1), ((x+1), y, z, 5),: ((x+0.5), y, (z+0.5), 2)  NB. right (+x)
    cfs=.cfs,(x, (y-0.5), (z-0.5), 4), (x, (y-1), z, 5),: (x, (y-0.5), (z+0.5), 3)  NB. back (-y)
    cfs=.cfs,(x, (y+0.5), (z-0.5), 3), (x, (y+1), z, 5),: (x, (y+0.5), (z+0.5), 4)  NB. front (+y)
  case. 6 do.  NB. +ve z
    cfs=.cfs,((x-0.5), y, (z+0.5), 2), ((x-1), y, z, 6),: ((x-0.5), y, (z-0.5), 1)  NB. left (-x)
    cfs=.cfs,((x+0.5), y, (z+0.5), 1), ((x+1), y, z, 6),: ((x+0.5), y, (z-0.5), 2)  NB. right (+x)
    cfs=.cfs,(x, (y-0.5), (z+0.5), 4), (x, (y-1), z, 6),: (x, (y-0.5), (z-0.5), 3)  NB. back (-y)
    cfs=.cfs,(x, (y+0.5), (z+0.5), 3), (x, (y+1), z, 6),: (x, (y+0.5), (z-0.5), 4)  NB. front (+y)
  case. do.
    echo 'invalid state'
    echo ft
    echo face
    exit 1
end.
cfs
)

prunecandidates =: 4 : 0  NB. x=sf, y=4 3 4 list of candidate faces
NB. Select the first of each of these lists which exists within the surface list
NB. For candidate faces => (n1,n2,n3),(e1,e2,e3),(s1,s2,s3),(w1,w2,w3)
NB. and allsurfaces=(n1,e1,e2,e3,s2,w3), this then goes to (n1,e1,s2,w3) which is returned
faces =. 0 0 $ 0
faces =. faces,{.((0{y) e. x) # (0{y)
faces =. faces,{.((1{y) e. x) # (1{y)
faces =. faces,{.((2{y) e. x) # (2{y)
faces =. faces,{.((3{y) e. x) # (3{y)
faces
)

echo # part_two sf;unpainted;painted

exit 0
