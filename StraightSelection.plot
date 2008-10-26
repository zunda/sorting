set title "Sorting by straight selection"
load "common.plot"
plot \
(x*x-x)/2 tit 'C' lt 1,\
floor(x*x/2)+3*(x-1) tit 'Mmax?' lt 0,\
'StraightSelection.dat' using 1:5 with lines tit 'M reverse' lt 2,\
'StraightSelection.dat' using 1:8:9 with yerrorlines tit 'M random' lt 2,\
'StraightSelection.dat' using 1:3 with lines tit 'M sorted (min)' lt 2

#'StraightSelection.dat' using 1:2 with lines tit 'C sorted' lt 1,\
#'StraightSelection.dat' using 1:4 with lines tit 'C reverse' lt 1,\
#'StraightSelection.dat' using 1:6:7 with yerrorlines tit 'C random' lt 1
