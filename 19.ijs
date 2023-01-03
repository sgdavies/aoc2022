bps =. 'Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.' ; 'Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.'

NB.     or cl ob ge Robots: or,cl,ob,ge  Time remaining (minutes), best so far
state =. 0  0  0  0 ,       1  0  0  0 

getmoves =: 3 : 0
nums =. _ ". >;: ' ',>y
ore_robot =.  (-6{nums),  0,0,0,  1 0 0 0,  0,0
clay_robot =. (-12{nums), 0,0,0,  0 1 0 0,  0,0
obs_robot =.  (-18{nums), (-21{nums), 0, 0,  0 0 1 0,  0,0
geod_robot =. (-27{nums), 0,(-30{nums),  0,  0 0 0 1,  0,0
NB.ore_robot, clay_robot, obs_robot, geod_robot,: 0 0 0 0  0 0 0 0  0,0  NB. last one is "do nothing" move
geod_robot, obs_robot, clay_robot, ore_robot,: 0 0 0 0  0 0 0 0  0,0
)

NB. TODO - fix: returns the wrong answer.  Optimised version with pruning.
partone =: 4 : 0  NB. x=robots, y=state
best =. 9{y
days_left =. 8{y
if. days_left = 0 do.
  ret =. 3{y >. best
else.

  obsi_need=.-2{0{x  NB. amount of obsidian needed to make a geode rebot in this recipe
  obsi_robots=.6{y   NB. current number of obsidian robots
  clay_robots=.5{y   NB. current number of clay robots
  clay_need=.-1{1{x  NB. amount of clay needed to build another obsidian robot

    NB. Overestimate of clay we could generate - assume we add 1 new clay robot per day
    NB. if we have 8 clay now and 2 robots, then we'll have 8 now, 8+2 tomorrow, 8+2+3, 8+2+3+4 etc
    NB. Divide by clay needed per robot and take the floor, to find how many new obsidian robots you have on each day
    extra_obsi_robots =. <. %clay_need % (1{y),(1{y) + +/\ clay_robots + i.(days_left -1)
    extra_geod_robots =. <. %obsi_need % (2{y),(2{y) + +/\ obsi_robots + }:extra_obsi_robots NB. drop the extra day
    NB. Overestimate again - because we assume we can build new obs robots alongside the clay ones above
    max_geodes =. ((7{y) * days_left) + +/extra_geod_robots

  if. -. max_geodes > best do.
    ret =. best
  else.
    nextstate =. y + (4}.8{.y), 0 0 0 0, _1,0  NB. Each robot adds their collected resources, and time increments
    states =. ($x) $y  NB. repeat y=state to match length of robots list, i.e. add state to each robot row
    legalmoves =. (0 = +/ |: 0 > 4{."1 (x + states)) #x  NB. Moves which would not result in any -ve resources
    newstates =. }:"1 legalmoves + ($legalmoves) $ nextstate  NB. strip off 'best' from each
    for_state. newstates do.
      attempt =. x partone state,best
      best =. attempt >. best
    end.
    ret =. best
  end.
end.
ret
)

NB. Simpler version
partonea =: 4 : 0  NB. x=builds, y=state
NB.echo _, y
if. 0 = 8{y do.
  ret =. 3{y >. 9{y
else.
    states =. ($x) $y  NB. repeat y=state to match length of builds list, i.e. add state to each build row
    legalmoves =. (0 = +/ |: 0 > 4{."1 (x + states)) #x  NB. Moves which would not result in any -ve resources
    nextstate =. y + (4}.8{.y), 0 0 0 0, _1,0  NB. Time decrements and each robot adds their collected resources
    geodes =. x (partonea"_ 1) legalmoves + ($legalmoves) $ nextstate  NB. "_ 1 : the whole of x against each row of y
    ret =. >./ geodes
end.
ret
)

blueprints =. getmoves"0 bps
builds =. 0{blueprints
NB.echo robots
echo builds partone (state,21,0)
NB.echo builds partonea (state,19,0)

exit 0
