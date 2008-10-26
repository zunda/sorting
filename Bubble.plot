set title "Bubble Sort"
load "common.plot"
plot \
x*(x-1)/2 tit 'C' lt 1,\
'Bubble.dat' using 1:5 with lines tit 'M reverse (max)' lt 2,\
3*x*(x-1)/4 tit 'Move' lt 2,\
'Bubble.dat' using 1:8:9 with yerror tit 'M random' lt 2,\
'Bubble.dat' using 1:3 with lines tit 'M sorted (zero, min)' lt 2
#'Bubble.dat' using 1:2 with lines tit 'C sorted' lt 1,\
#'Bubble.dat' using 1:4 with lines tit 'C reverse' lt 3,\
#'Bubble.dat' using 1:6:7 with yerrorlines tit 'C random' lt 5
