input =. freads '02.txt'

NB. Part one
score =. 3 : 0
select. 3{. y
case. 'A X' do. 4
case. 'B X' do. 1
case. 'C X' do. 7
case. 'A Y' do. 8
case. 'B Y' do. 5
case. 'C Y' do. 2
case. 'A Z' do. 3
case. 'B Z' do. 9
case. 'C Z' do. 6
end.
)

NB. (sum of) (score applied to each row in array) (input split into array 4 chars at a time)
echo +/ score "1 ] _4 [\ input

NB. Part two
score2 =. 3 : 0
select. 3{. y
case. 'A X' do. 3
case. 'B X' do. 1
case. 'C X' do. 2
case. 'A Y' do. 4
case. 'B Y' do. 5
case. 'C Y' do. 6
case. 'A Z' do. 8
case. 'B Z' do. 9
case. 'C Z' do. 7
end.
)

echo +/ score2 "1 ] _4 [\ input

exit 0
