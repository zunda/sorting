set title "Sorting by straight insertion"
load "common.plot"
plot \
'StraightInsertion.dat' using 1:4 with lines tit 'C reverse (max)' lt 1,\
'StraightInsertion.dat' using 1:6:7 with yerror tit 'C random' lt 1,\
(x*x+x-2)/4 tit 'Cave' lt 1,\
'StraightInsertion.dat' using 1:2 with lines tit 'C sorted (min)' lt 1,\
'StraightInsertion.dat' using 1:5 with lines tit 'M reverse' lt 2,\
(x*x+3*x-4)/2 tit 'Mmax?' lt 0,\
'StraightInsertion.dat' using 1:8:9 with yerror tit 'M random' lt 2,\
(x*x+9*x-10)/4 tit 'Mave' lt 2,\
2*(x-1) tit 'Mmin?' lt 0,\
'StraightInsertion.dat' using 1:3 with lines tit 'M sorted' lt 2
