#!/bin/bash
export LC_ALL=C 

awk '
BEGIN{FS="\t";MaxPP=0}
{
PP=($21/($18-$21))*100
if(PP >= MaxPP) {MaxPP=PP;MaxID=$1};
}
END {printf ("Transaksi terakhir dengan profit percentage terbesar yaitu %d dengan persentase %d%%.\n",MaxID,MaxPP)}' Laporan-TokoShiSop.tsv > hasil.txt

export LC_ALL= 
awk '
BEGIN{FS="\t"}

$2~/2017/ && $10~/Albuquerque/ {listNama[$7]++}

END {
  printf("\nDaftar nama customer di Albuquerque pada tahun 2017 antara lain:\n");
  for (nama in listNama) {
    printf ("%s\n",nama)
  }
}' Laporan-TokoShiSop.tsv >> hasil.txt

awk '
BEGIN{FS="\t"}

$8~/Consumer/||$8~/Corporate/||$8~/Home Office/ {listSegment[$8]++}

END {
i=0;
orderMin;
segMin;
  for (seg in listSegment) {
    if(i==0){
    	orderMin=listSegment[seg];
	segMin=seg;
	i++;
    }
    else if(listSegment[seg]<orderMin){
	orderMin=listSegment[seg];
	segMin=seg
    }
  }
printf("\nTipe segmen customer yang penjualannya paling sedikit adalah %s dengan %d transaksi.\n",segMin,orderMin)
}' Laporan-TokoShiSop.tsv >> hasil.txt

awk '
BEGIN{FS="\t"}

{if(NR>1){listRegProf[$13]+=$21}}

END {
i=0;
profitMin;
regMin;
  for (reg in listRegProf) {
    if(i==0){
        profitMin=listRegProf[reg];
        regMin=reg;
        i++;
    }
    else if(listRegProf[reg]<profitMin){
        profitMin=listRegProf[reg];
        regMin=reg
    }
  }
printf("\nWilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah %s dengan total keuntungan %d\n",regMin,profitMin)
}' Laporan-TokoShiSop.tsv >> hasil.txt
