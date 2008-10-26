set title "Heap Sort"
load "common.plot"
plot \
'Heap.dat' using 1:2 with lines tit 'C sorted' lt 1,\
'Heap.dat' using 1:6:7 with yerror tit 'C random' lt 1,\
'Heap.dat' using 1:4 with lines tit 'C reverse' lt 1,\
'Heap.dat' using 1:3 with lines tit 'M sorted' lt 2,\
'Heap.dat' using 1:8:9 with yerror tit 'M random' lt 2,\
'Heap.dat' using 1:5 with lines tit 'M reverse' lt 2,\
x*log(x)/log(2) with lines tit 'n log2(n)' lt 0
