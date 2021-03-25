#!/bin/bash

for i in {1..23}; do
    wget -a Foto.log https://loremflickr.com/320/240/kitten -O "Koleksi_$i.jpg"
    maxCheck=$((i-1))
    for (( a=1; a<=maxCheck; a++ ))
    do
	if [ -f Koleksi_$a.jpg ]; then
           if comm Koleksi_$a.jpg Koleksi_$i.jpg &> /dev/null;
	      then rm Koleksi_$i.jpg
	           break;
	   fi
	fi 
    done
done

for i in {1..23}; do
    if [ ! -f Koleksi_$i.jpg ]; then
       for (( j=23; j>i; j-- ))
       do
	   if [ -f Koleksi_$j.jpg ]; then
	      mv Koleksi_$j.jpg Koleksi_$i.jpg
	      break
	   fi
       done
     fi
done

for i in {1..9}; do
    if [ -f Koleksi_$i.jpg ]; then
       mv Koleksi_$i.jpg Koleksi_0$i.jpg
    fi
done
