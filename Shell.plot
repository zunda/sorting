set title "Shell Sort"
load "common.plot"
plot \
'Shell.dat' using 1:4 with lines tit 'C reverse' lt 1,\
'Shell.dat' using 1:6:7 with yerror tit 'C random' lt 1,\
'Shell.dat' using 1:2 with lines tit 'C sorted' lt 1,\
'Shell.dat' using 1:5 with lines tit 'M reverse' lt 2,\
'Shell.dat' using 1:8:9 with yerror tit 'M random' lt 2,\
'Shell.dat' using 1:3 with lines tit 'M sorted' lt 2,\
x**1.2 with lines tit 'n**1.2' lt 0
