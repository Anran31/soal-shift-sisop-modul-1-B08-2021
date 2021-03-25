#!/bin/bash

cd /home/anran/sisop/shift1/soal3
dirName="$(date +%d)-$(date +%m)-$(date +%Y)"
mkdir $dirName

bash /home/anran/sisop/shift1/soal3/soal3a.sh
mv *.jpg $dirName
mv Foto.log $dirName

