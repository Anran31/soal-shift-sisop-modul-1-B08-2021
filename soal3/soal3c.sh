#!/bin/bash

Download () {
	declare -a link
        link[0]="https://loremflickr.com/320/240/kitten"
        link[1]="https://loremflickr.com/320/240/bunny"

	for i in {1..23}; do
    	wget -a Foto.log "${link[$1]}" -O "Koleksi_$i"
    	maxCheck=$((i-1))
    		for (( a=1; a<=maxCheck; a++ ))
    		do
			if [ -f Koleksi_$a ]; then
           			if comm Koleksi_$a Koleksi_$i &> /dev/null;
	      			then rm Koleksi_$i
	           		break;
	   			fi
			fi 
    		done
	done

	for i in {1..23}; do
    		if [ ! -f Koleksi_$i ]; then
       			for (( j=23; j>i; j-- ))
       			do
	   			if [ -f Koleksi_$j ]; then
	      				mv Koleksi_$j Koleksi_$i
	      				break
	   			fi
       			done
     		fi
	done

	for i in {1..9}; do
    		if [ -f Koleksi_$i ]; then
       		mv Koleksi_$i Koleksi_0$i
    		fi
	done
	
	declare -a dirName
        dirName[0]="Kucing_$(date +"%d-%m-%Y")"
	dirName[1]="Kelinci_$(date +"%d-%m-%Y")"
	
	mkdir ${dirName[$1]}
	mv Koleksi_{01..23} ${dirName[$1]} &> /dev/null
	mv Foto.log ${dirName[$1]} 
}

jmlKuc=$(find Kucing_* -maxdepth 0 2>/dev/null | wc -l)
jmlKel=$(find Kelinci_* -maxdepth 0 2>/dev/null | wc -l)

if (( jmlKuc == jmlKel )); 
	then Download "0"
		elif (( jmlKuc > jmlKel ))
		then Download "1"
fi