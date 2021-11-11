#!/bin/sh

LEDGER_TERM="qt size 1280,720 persist"

THIS_MONTH=`date +%m`

hledger bal -M ^Expenses --cumulative --no-total | sed 's/¥/ /g; 1,2d; 4d; $d; 3s/ /x/2; s/ //1; s/||//g' > ledgeroutput1.tmp

(cat <<EOF) | gnuplot
  set terminal $LEDGER_TERM
  set style data linespoints
  set key outside horizontal Left samplen 2 autotitle columnhead
  set xtics nomirror scale 0 rotate by -45
  set ytics scale 0
  set grid ytics
  set border 1
  set ylabel "Amount"
plot "ledgeroutput1.tmp" using 2:xticlabels(1) title "Jan", for [i=3:$THIS_MONTH+1] '' using i title strftime('%b', strptime('%m', sprintf("%i", i-1)))
EOF

rm ledgeroutput*.tmp
