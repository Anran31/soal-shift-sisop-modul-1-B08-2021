# soal-shift-sisop-modul-1-B08-2021

## No 1

Pada soal nomor 1, kita mempunyai data _syslog.log_ dari aplikasi _ticky_. _syslog.log_ berisikan data sebagai berikut:

```text
    ...
    Jan 31 00:16:25 ubuntu.local ticky: INFO Closed ticket [#1754] (noel)
    Jan 31 00:21:30 ubuntu.local ticky: ERROR The ticket was modified while updating (breee)
    ...
```

Setiap baris pada data tersebut memiliki format sebagai berikut:

```text
    <time> <hostname> <app_name>: <log_type> <log_message> (<username>)
```

### 1a

Pada soal 1a, Kita disuruh membuat sebuah regex untuk mengumpulkan informasi dari setiap baris pada _syslog.log_ berupa:  jenis log (ERROR/INFO), pesan log, dan username.
Untuk menyelesaikan soal pada poin ini, maka kita dapat menggunakan command:

```bash
    grep -oP "((?<=ticky\:\ ).*)" syslog.log
```

Pada command di atas, kita menggunakan grep untuk mengambil setiap baris pada _syslog.log_ yang memenuhi kondisi yang kita inginkan. Kita menggunakan _option_ `o` supaya hanya menampilkan bagian yang sesuai dengan pattern yang kita inginkan serta _option_ `P` untuk menggunakan pattern regex yang kompatibel dengan Perl.

Karena kita mengetahui data yang kita perlukan terletak setelah `ticky: `, maka Pattern yang kita gunakan adalah `"((?<=ticky\:\ ).*)"`. Regex `(?<=ticky\:\ )` berarti kata `ticky: ` harus berada di sebelum string yang mau kita ambil dan regex `.*` digunakan untuk mengambil seluruh string setelah kata `ticky: `.

Ketika kita menjalankan command di atas, maka kita akan mendapatkan hasil seperti ini:

```text
    ...
    INFO Closed ticket [#1754] (noel)
    ERROR The ticket was modified while updating (breee)
    ...
```

### 1b

Pada soal 1b, Kita disuruh menampilkan semua pesan error yang muncul beserta jumlah kemunculannya.
Untuk menyelesaikan soal pada poin ini, maka kita dapat menggunakan command:

```bash
    grep -oP "((?<=ERROR\ ).*?(?=\ \())" syslog.log | sort | uniq -c
```

Karena kita mengetahui pesan error yang kita perlukan terletak setelah kata `ERROR ` sampai sebelum ` (`, maka Pattern yang kita gunakan adalah `(?<=ERROR\ ).*?(?=\ \())`. Regex `(?<=ERROR\ )` berarti kata `ERROR ` harus berada di sebelum string yang mau kita ambil, regex `.*` digunakan untuk mengambil seluruh string setelah kata `ERROR `, dan regex `?(?=\ \()` digunakan untuk membatasi string yang kita ambil sampai sebelum bertemu dengan ` (`.

Ketika kita menjalankan ```bash grep -oP "((?<=ERROR\ ).*?(?=\ \())" syslog.log``` maka akan muncul hasil seperti ini:

```text
    ...
    Permission denied while closing ticket
    Tried to add information to closed ticket
    ...
```

Untuk menghitung jumlah kemunculan tiap error, maka hasil dari command di atas dapat kita `sort` untuk mengurutkan hasilnya kemudian menggunakan `uniq -c` untuk menghitung jumlah kemunculan setiap error message. Setelah menjalankan `grep -oP "((?<=ERROR\ ).*?(?=\ \())" syslog.log | sort | uniq -c` maka akan muncul hasil seperti ini:

```text
        13 Connection to DB failed
        10 Permission denied while closing ticket
         9 The ticket was modified while updating
         7 Ticket doesn't exist
        15 Timeout while retrieving information
        12 Tried to add information to closed ticket
```

### 1c

Pada soal 1c, kita harus menampilkan jumlah kemunculan log ERROR dan INFO untuk setiap user-nya.
Untuk menyelesaikan soal pada poin ini, maka kita dapat menggunakan command:

```bash
    grep -oP "((?<=\().*?(?=\)))" syslog.log | sort | uniq | while read -r user; do
    errorCount=$(grep -w "$user" syslog.log | grep "ERROR" | wc -l)
    infoCount=$(grep -w "$user" syslog.log | grep "INFO" | wc -l)
    printf "%s,%d,%d\n" "$user" "$infoCount" "$errorCount"
    done
```

Karena kita mengetahui pada _syslog.log_ username berada pada `(<username>)`, maka kita dapat menggunakan `grep -oP "((?<=\().*?(?=\)))" syslog.log` untuk mengambil username dari setiap baris _syslog.log_. Regex `(?<=\()` berarti harus terdapat `(` sebelum string yang kita ambil, regex `.*` digunakan untuk mengambil seluruh string setelahnya, dan regex `?(?=\))` digunakan untuk membatasi string yang kita ambil sampai sebelum terdapat `)`.

Jika kita menjalankan command `grep -oP "((?<=\().*?(?=\)))" syslog.log`, maka kita akan mendapatkan hasil:

```text
    ...
    noel
    breee
    ac
    ...
```

Setelah itu, supaya tidak ada username yang duplikat, dengan menggunakkan command `sort` kemudian `uniq`, maka kita akan mendapatkan hasil:

```text
    ac
    ahmed.miller
    blossom
    bpacheco
    ...
```

Kemudian untuk mendapatkan jumlah ERROR dan INFO dari setiap username, dapat menggunakan:

```bash
    while read -r user; do
    errorCount=$(grep -w "$user" syslog.log | grep "ERROR" | wc -l)
    infoCount=$(grep -w "$user" syslog.log | grep "INFO" | wc -l)
    printf "%s,%d,%d\n" "$user" "$infoCount" "$errorCount"
```

Dengan menggunakan `while` loop untuk setiap baris pada hasil command sebelumnya, maka kita dapat menemukan jumlah ERROR yang dimiliki user tersebut menggunakan:

```bash
    errorCount=$(grep -w "$user" syslog.log | grep "ERROR" | wc -l)
```

Pada command diatas, option `w` pada `grep` berfungsi untuk mengambil string yang memiliki kata yang benar-benar sama dengan `username` yang dicari. Kemudian kita mengambil string yang terdapat kata `ERROR`, setelah itu jumlah baris hasil kedua perintah sebelumnya dihitung menggunakan command `wc -l` dan disimpan di variabel `errorCount`. Maka kita akan mendapatkan jumlah ERROR yang dimiliki oleh user tertentu.

Sedangkan untuk mendapatkan jumlah INFO yang dimiliki user tersebut, commandnya hampir sama dengan command untuk mendapatkan jumlah ERROR, tetapi command `grep "ERROR"` diganti dengan `grep "INFO"` dan disimpan di variabel `infoCount`.

### 1d

Pada soal 1d, dengan data yang kita dapatkan di poin 1b, kita harus membuat file error_message.csv dengan header Error,Count yang kemudian diikuti oleh daftar pesan error dan jumlah kemunculannya diurutkan berdasarkan jumlah kemunculan pesan error dari yang terbanyak seperti ini:

```text
    Error,Count
    Permission denied,5
    File not found,3
    Failed to connect to DB,2
```

Untuk menyelasaikan soal pada poin ini, maka dapat menggunakan:

```bash
    printf "Error,Count\n" > error_message.csv
    grep -oP '(?<=ERROR\ ).*?(?=\ \()' syslog.log | sort | uniq -c | sort -nr | while read -r line; do
    count=$(grep -oP "([0-9].*?(?=\ ))" <<< "$line")
    message=$(grep -oP "(?<=\d\ ).*\w" <<< "$line")
    printf "%s,%d\n" "$message" "$count" >> error_message.csv
    done 
```
Pertama, kita membuat file error_message.csv yang berisikan header Error,Count menggunakan:

```bash
    printf "Error,Count\n" > error_message.csv
```

Karena hasil dari poin 1b belum terurut berdasarkan jumlah kemunculan pesan error dari yang terbanyak, maka dapat menggunakan `sort -nr` untuk mengurutkannya dimana option `n` digunakan untuk mengurutkan secara numerik dan option `r` digunakan untuk mengurutkan dari yang terbesar. Akan didapatkan hasil seperti ini:

```text
        15 Timeout while retrieving information
        13 Connection to DB failed
        12 Tried to add information to closed ticket
        10 Permission denied while closing ticket
         9 The ticket was modified while updating
         7 Ticket doesn't exist
```

Dari hasil tersebut, kita menggunakan `while` loop pada setiap baris untuk menyesuaikannya sesuai format. 

```bash
    count=$(grep -oP "([0-9].*?(?=\ ))" <<< "$line")
```

Command di atas digunakan untuk mengambil jumlah kemunculan pesan error. Command `grep` dengan regex  `([0-9].*?(?=\ ))`, dimana regex tersebut digunakan untuk mengambil seluruh angka 0-9 sampai sebelum bertemu dengan spasi ` `, kemudian disimpan di variabel `count`.  

```bash
    message=$(grep -oP "(?<=\d\ ).*\w" <<< "$line")
```
Sedangkan command di atas digunakan untuk mengambil pesan error menggunakan command `grep` dengan regex `(?<=\d\ ).*\w`, dimana regex `(?<=\d\ ))` digunakan untuk mengambil string yang dimana sebelumnya berisi digit dan spasi `\d\ ` dan regex `.*\w` untuk mengambil semua string yang berisi huruf, kemudian disimpan di variabel `message`.

Setelah itu diappend ke error_message.csv sesuai dengan format menggunakan:

```bash
    printf "%s,%d\n" "$message" "$count" >> error_message.csv
```

### 1e
Pada poin 1e, kita disuruh menggunakan informasi yang didapatkan pada poin 1c untuk dituliskan ke dalam file user_statistic.csv dengan header Username,INFO,ERROR diurutkan berdasarkan username secara ascending. Untuk menyelesaikan problem poin ini, kita dapat menggunakan:

```bash
    printf "Username,INFO,ERROR\n" > user_statistic.csv
    grep -oP "((?<=\().*?(?=\)))" syslog.log | sort | uniq | while read -r user; do
    errorCount=$(grep -w "$user" syslog.log | grep "ERROR" | wc -l)
    infoCount=$(grep -w "$user" syslog.log | grep "INFO" | wc -l)
    printf "%s,%d,%d\n" "$user" "$infoCount" "$errorCount" >> user_statistic.csv
    done
```

Karena pada poin 1c kita sudah mendapatkan baris sesuai format, maka kita hanya perlu membuat file user_statistic.csv kemudian menambahkan header menggunakan:

```bash
    printf "Username,INFO,ERROR\n" > user_statistic.csv
```

Kemudian meng-append seluruh hasil dari poin 1c ke user_statistic.csv.

```bash
    printf "%s,%d,%d\n" "$user" "$infoCount" "$errorCount" >> user_statistic.csv
```

## No 2

Kita merupakan kepala gudang yang mengatur keluar masuknya barang di sebuah _startup_ bernama "TokoShiSop". Steven, Manis, dan Clemong meminta kita untuk mencari beberapa kesimpulan dari data penjualan “Laporan-TokoShiSop.tsv” kemudian seluruh hasilnya disimpan di `hasil.txt`. “Laporan-TokoShiSop.tsv” memiliki 21 kolom data yang berisikan data seperti **Row ID**, **Customer Name**,**Sales**, **Profit**, dan lain-lain.

### 2a
Pada poin ini, Steven ingin mengapresiasi kinerja karyawannya selama ini dengan mengetahui **Row ID** dan **profit percentage terbesar** (jika hasil profit percentage terbesar lebih dari 1, maka ambil Row ID yang paling besar). Karena kamu bingung, Clemong memberikan definisi dari _profit percentage_, yaitu:

```text
Profit Percentage_ = (_Profit_/_Cost Price_) x 100
```

Cost Price_didapatkan dari pengurangan_Sales_ dengan _Profit_ (**Quantity diabaikan**)

Untuk mendapatkan **Profit Percentage terbesar**, maka kita harus mengecek dari setiap baris data yang ada, berapa besar Profit Percentage per baris. Untuk mempermudah mengerjakan soal pada nomor 2, kita dapat menggunakan `awk` seperti di bawah ini:  

```bash
    awk '
    BEGIN{FS="\t";MaxPP=0}
    {
    if (NR>1) {
	    PP=($21/($18-$21))*100
        if(PP >= MaxPP) {MaxPP=PP;MaxID=$1};};
    }
    END {printf ("Transaksi terakhir dengan profit percentage terbesar yaitu %d dengan persentase %d%%.\n",MaxID,MaxPP)}' Laporan-TokoShiSop.tsv > hasil.txt
```
Pada blok `BEGIN` terdapat `FS="\t"` untuk memberi tahu `awk` bahwa `Field Separator` yang digunakan adalah tab("\t"), kemudian kita juga menginisialisasi variabel `MaxPP` untuk menyimpan **Profit Percentage terbesar** yang ditemukan.

Kemudian `if (NR>1)` digunakan untuk mengecek setiap baris setelah header. Untuk setiap baris, kita menghitung **Profit Percentage** sesuai dengan rumus dimana `$21` merupakan kolom yang memiliki data **Profit** dan `$18` memlik data **Sales**. Jika **Profit Percentage** pada baris tertentu lebih besar daripada **Profit Percentage terbesar** yang tersimpan, maka **Profit Percentage terbesar** akan direplace, serta **Row ID** disimpan di variabel `MaxID`.

Ketika sudah mengecek sampai akhir maka pada blok `END` akan diprint sesuai format di `hasil.txt`.

### 2b
Pada poin ini, Clemong memiliki rencana promosi di Albuquerque menggunakan metode MLM. Oleh karena itu, Clemong membutuhkan **daftar nama customer pada transaksi tahun 2017 di Albuquerque**.

Untuk menyelesaikan soal poin ini, kita dapat menggunakan `awk` seperti ini:

```bash
    awk '
    BEGIN{FS="\t"}


    $2~/2017/ && $10~/Albuquerque/ {listNama[$7]++}

    END {
    printf("\nDaftar nama customer di Albuquerque pada tahun 2017 antara lain:\n");
    for (nama in listNama) {
    printf ("%s\n",nama)
  }
}' Laporan-TokoShiSop.tsv >> hasil.txt
```

Karena kita membutuhkan **daftar nama customer pada transaksi tahun 2017 di Albuquerque**, maka kita perlu memfilter baris menggunakan :

```bash
    $2~/2017/ && $10~/Albuquerque/ {listNama[$7]++}
```

`$2~/2017/` berarti di kolom 2 (**Order ID**) harus terdapat tahun 2017 dan `$10~/Albuquerque/` berarti di kolom 10 (**City**) harus berada di Albuquerque. Setelah itu supaya tidak ada nama Customer yang duplikat, Nama Customer disimpan sebagai index di map `listNama[$7]`, dimana `$7` merupakan kolom yang terdapat **Customer Name**.

Kemudian ketika sudah selesai mencari pada seluruh baris, Pada blok `END` daftar nama customer dapat diprint sesuai format ke `hasil.txt` menggunakan:

```bash
    END {
    printf("\nDaftar nama customer di Albuquerque pada tahun 2017 antara lain:\n");
    for (nama in listNama) {
    printf ("%s\n",nama)
  }
}' Laporan-TokoShiSop.tsv >> hasil.txt
```

### 2c

Pada poin ini, Clemong membutuhkan **segment customer** dan **jumlah transaksinya** yang paling sedikit. TokoShiSop berfokus tiga segment customer, antara lain: Home Office, Consumer, dan Corporate. Untuk menyelesaikan soal ini, kita dapat menggunakan `awk` seperti ini:

```bash
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
```

Untuk menghitung jumlah transaksi per segment, maka kita dapat menghitung jumlah baris data yang mengandung masing-masing segment. Karena **Segment** berada pada kolom ke 8, kita menggunakan map `listSegment` dengan indeks `$8` yang isinya akan selalu bertambah 1 ketika menemukan baris yang mengandung indeksnya.

```bash
    $8~/Consumer/||$8~/Corporate/||$8~/Home Office/ {listSegment[$8]++}
```

Kemudian ketika sudah selesai mencari pada seluruh baris, Pada blok `END` kita mencari **segment customer** dengan**jumlah transaksinya** yang paling sedikit menggunakan `for` loop yang membandingkan isi map `listSegment`. Ketika sudah ditemukan yang paling sedikit, maka akan diprint ke `hasil.txt` sesuai dengan format.

```bash
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
```

### 2d

Pada poin ini, Manis ingin mencari **wilayah bagian (region) yang memiliki total keuntungan (profit) paling sedikit dan total keuntungan wilayah tersebut**. Untuk menyelesaikan soal ini, kita dapat menggunakan `awk` seperti ini:

```bash
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
    printf("\nWilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah %s dengan total keuntungan %.2f\n",regMin,profitMin)
    }' Laporan-TokoShiSop.tsv >> hasil.txt
```

`if (NR>1)` digunakan untuk mengecek setiap baris setelah header. Untuk setiap baris, untuk menemukan region dengan profit tersedikit, maka kita dapat menghitung jumlah profit per region dari baris data yang mengandung masing-masing region. Karena **Region** berada pada kolom ke 13, kita menggunakan map `listRegProf` dengan indeks `$13` yang isinya akan selalu bertambah dengan `$21` yaitu kolom yang berisi **Profit**.

Kemudian ketika sudah selesai mencari pada seluruh baris, Pada blok `END` kita mencari **Region** dengan**Total Profit** yang paling sedikit menggunakan `for` loop yang membandingkan isi map `listRegProf`. Ketika sudah ditemukan yang paling sedikit, maka akan diprint ke `hasil.txt` sesuai dengan format.

```bash
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
    printf("\nWilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah %s dengan total keuntungan %.2f\n",regMin,profitMin)
    }' Laporan-TokoShiSop.tsv >> hasil.txt
```

### 2e
Pada poin e, kita disuruh menyatukan seluruh command dari poin a sampai poin d pada satu script bernama `soal2_generate_laporan_ihir_shisop.sh`. Setelah script tersebut dijalankan, maka akan menghasilkan file `hasil.txt` berisikan:

```text
    Transaksi terakhir dengan profit percentage terbesar yaitu 9952 dengan persentase 100%.

    Daftar nama customer di Albuquerque pada tahun 2017 antara lain:
    Benjamin Farhat
    David Wiener
    Michelle Lonsdale
    Susan Vittorini

    Tipe segmen customer yang penjualannya paling sedikit adalah Home Office dengan 1783 transaksi.

    Wilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah Central dengan total keuntungan 39706.36
```

## No 3

Kuuhaku adalah orang yang sangat suka mengoleksi foto-foto digital, namun Kuuhaku juga merupakan seorang yang pemalas sehingga ia tidak ingin repot-repot mencari foto, selain itu ia juga seorang pemalu, sehingga ia tidak ingin ada orang yang melihat koleksinya tersebut, sayangnya ia memiliki teman bernama Steven yang memiliki rasa kepo yang luar biasa. Kuuhaku pun memiliki ide agar Steven tidak bisa melihat koleksinya, serta untuk mempermudah hidupnya, yaitu dengan meminta bantuan kalian. Idenya adalah:

### 3a
Membuat script untuk **mengunduh** 23 gambar dari "https://loremflickr.com/320/240/kitten" serta **menyimpan log-nya** ke file "Foto.log". Karena gambar yang diunduh acak, ada kemungkinan gambar yang sama terunduh lebih dari sekali, oleh karena itu kalian harus **menghapus gambar yang sama** (tidak perlu mengunduh gambar lagi untuk menggantinya). Kemudian **menyimpan** gambar-gambar tersebut dengan nama "Koleksi_XX" dengan nomor yang **berurutan tanpa ada nomor yang hilang** (contoh : Koleksi_01, Koleksi_02, ...)

Untuk menyelesaikan soal pada poin ini, maka kita dapat membuat script seperti di bawah ini:

```bash
    #!/bin/bash

    for i in {1..23}; do
        wget -a Foto.log https://loremflickr.com/320/240/kitten -O "Koleksi_$i"
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
```

#### Penjelasan

```bash
    for i in {1..23}; do
        wget -a Foto.log https://loremflickr.com/320/240/kitten -O "Koleksi_$i"
```

Kode di atas digunakan untuk mendownload gambar dari `https://loremflickr.com/320/240/kitten` sebanyak 23 dan log-nya ditulis pada `Foto.log` serta gambar yang didownload direname menjadi Koleksi_1,Koleksi_2, dan seterusnya.

```bash
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
```

Kode di atas digunakan untuk mengecek menggunakan `comm Koleksi_$a Koleksi_$i` apakah gambar yang baru didownload merupakan duplikat dari sebuah gambar yang pernah kita download. Jika ternyata merupakan sebuah duplikat, maka gambar yang barusan kita download akan dihapus dan berhenti melakukan pengecekan.

```bash
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
```

Kode di atas digunakan untuk mengecek apakah ada nama gambar yang tidak berurutan karena terhapus. Maka kita akan merename file yang paling terakhir di urutan untuk mengisi nomor yang hilang karena terhapus tadi.

```bash
    for i in {1..9}; do
        if [ -f Koleksi_$i ]; then
        mv Koleksi_$i Koleksi_0$i
        fi
    done
```

Dan kode bagian terakhir ini digunakan untuk merename file yang masih berformat `Koleksi_X` menjadi `Koleksi_XX`.

### 3b
Karena Kuuhaku malas untuk menjalankan script tersebut secara manual, ia juga meminta kalian untuk menjalankan script tersebut **sehari sekali pada jam 8 malam** untuk tanggal-tanggal tertentu setiap bulan, yaitu dari **tanggal 1 tujuh hari sekali (1,8,...)**, serta dari **tanggal 2 empat hari sekali(2,6,...)**. Supaya lebih rapi, gambar yang telah diunduh beserta log-nya, dipindahkan ke folder dengan nama tanggal unduhnya dengan format "DD-MM-YYYY" (contoh : "13-03-2023").

Karena pada script poin a kita belum membuat sebuah folder untuk menampung seluruh gambar yang kita download, maka kita harus membuat script baru seperti ini:

```bash
    #!/bin/bash

    cd /home/anran/sisop/shift1/soal3
    dirName=$(date +"%d-%m-%Y")

    if [ ! -d "$dirName" ]; then
        mkdir $dirName

        bash /home/anran/sisop/shift1/soal3/soal3a.sh
        mv Koleksi_{01..23} $dirName &> /dev/null
        mv Foto.log $dirName
    fi
```

Karena ingin menjalankan script di atas secara terjadwal, maka kita dapat menggunakan crontab dengan crontab seperti:

```text
    0 20 1-31/7 * * /bin/bash /home/anran/sisop/shift1/soal3/soal3b.sh
    0 20 2-31/4 * * /bin/bash /home/anran/sisop/shift1/soal3/soal3b.sh
```

#### Penjelasan

```bash
    cd /home/anran/sisop/shift1/soal3
    dirName=$(date +"%d-%m-%Y")
```

Bagian `cd` digunakan untuk memindah lokasi script kita bekerja ke directory tempat kita menjalankan script 3a. Varibel `dirName` digunakan untuk menyimpan format tanggal sesuai keinginan yang nantinya akan digunakan sebagai nama directory tempat kita menyimpan seluruh gambar yang telah kita download.

```bash
    if [ ! -d "$dirName" ]; then
        mkdir $dirName

        bash /home/anran/sisop/shift1/soal3/soal3a.sh
        mv Koleksi_{01..23} $dirName &> /dev/null
        mv Foto.log $dirName
    fi
```

Karena kita hanya perlu menjalankan script ini sekali saja, maka pada bagian di atas digunakan untuk mengecek apakah pada suatu hari kita sudah pernah membuat direktori dengan nama `$dirName`. Jika iya maka tidak perlu menjalankan apa-apa, tetapi jika belum, maka kita akan membuat direktori baru bernama `$dirName` yaitu tanggal hari tersebut, kemudian kita menjalankan script yang ada pada poin 3a, kemudian memindahkan seluruh foto yang terdownload beserta log nya ke direktori yang barusan dibuat.

### 3c

Agar kuuhaku tidak bosan dengan gambar anak kucing, ia juga memintamu untuk mengunduh gambar kelinci dari "https://loremflickr.com/320/240/bunny". Kuuhaku memintamu **mengunduh** gambar kucing dan kelinci **secara bergantian** (yang pertama bebas. contoh : tanggal 30 kucing > tanggal 31 kelinci > tanggal 1 kucing > ... ). Untuk membedakan folder yang berisi gambar kucing dan gambar kelinci, **nama folder diberi awalan "Kucing_" atau "Kelinci_"** (contoh : "Kucing_13-03-2023").

Untuk menyelasaik soal pada poin c ini, maka kita bisa menggabungkan script pada poin 3a dan 3b serta memodifikasinya menjadi:

```bash
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
```

#### Penjelasan

```bash
    jmlKuc=$(find Kucing_* -maxdepth 0 2>/dev/null | wc -l)
    jmlKel=$(find Kelinci_* -maxdepth 0 2>/dev/null | wc -l)
    if (( jmlKuc == jmlKel )); 
        then Download "0"
            elif (( jmlKuc > jmlKel ))
            then Download "1"
    fi
```

Pada bagian kode di atas, kita menghitung jumlah folder yang berawalan `Kucing_` dan `Kelinci_` serta menghitung jumlahnya masing-masing. Jika jumlah folder keduanya sama, maka akan menjalankan fungsi Download dengan argumen `0`, tetapi jika jumlah folder kucing lebih banyak, maka akan menjalankan fungsi Download dengan argumen `1`.

```bash
    Download () {
        declare -a link
            link[0]="https://loremflickr.com/320/240/kitten"
            link[1]="https://loremflickr.com/320/240/bunny"

        for i in {1..23}; do
            wget -a Foto.log "${link[$1]}" -O "Koleksi_$i"
    ............
    ............
    ............
        declare -a dirName
            dirName[0]="Kucing_$(date +"%d-%m-%Y")"
        dirName[1]="Kelinci_$(date +"%d-%m-%Y")"
        
        mkdir ${dirName[$1]}
        mv Koleksi_{01..23} ${dirName[$1]} &> /dev/null
        mv Foto.log ${dirName[$1]} 
    }
```

Fungsi download adalah gabungan dari script 3a dan 3b, tetapi yang membedakannya hanyalah kita menyimpan `link` dan `dirName` dalam sebuah array agar kita dapat memanggil sesuai dengan argumen yang diinputkan. Jika menerima argumen `0` akan mendownload gambar kucing dan membuat direktori bernama `Kucing_XX-XX-XXXX` kemudian memindahkan Foto.log, seluruh gambar kucing ke direktori tersebut. Jika menerima argumen `1` maka kucing akan diganti dengan kelinci.

### 3d

Untuk mengamankan koleksi Foto dari Steven, Kuuhaku memintamu untuk membuat script yang akan **memindahkan seluruh folder ke zip** yang diberi nama “Koleksi.zip” dan mengunci **zip** tersebut dengan **password** berupa tanggal saat ini dengan format "MMDDYYYY" (contoh : “03032003”).

Untuk menyelesaikan soal pada poin d, maka kita dapat membuat script seperti ini:

```bash
    #!/bin/bash

    pass=$(date +"%m%d%Y")
    cd /home/anran/sisop/shift1/soal3
    for dirName in K*_*; do
	zip -q -P $pass -r Koleksi $dirName
        rm -r $dirName
        done
```
#### Penjelasan

```bash
    pass=$(date +"%m%d%Y")
    cd /home/anran/sisop/shift1/soal3
```

Pertama, kita simpan password untuk zip kita di variabel `pass`, kemudian kita berpindah diektori ke direktori dimana folder Kelinci dan Kucing tersimpan menggunakan `cd`. Setelah itu, untuk semua direktori yang terdapat huruh `K` dan `_` maka direktori itu akan kita jadikan satu zip pada `Koleksi.zip` menggunakan command `zip -q -P $pass -r Koleksi $dirName` dan folder yang sudah dimasukkan ke dalam zip dihapus menggunakan `rm -r $dirName`.

### 3e

Karena kuuhaku hanya bertemu Steven pada saat kuliah saja, yaitu setiap hari kecuali sabtu dan minggu, dari jam 7 pagi sampai 6 sore, ia memintamu untuk membuat koleksinya ter-zip saat kuliah saja, selain dari waktu yang disebutkan, ia ingin koleksinya ter-unzip dan tidak ada file zip sama sekali.

Untuk menyelesaikan soal ini, maka kita hanya perlu membuat tugas untuk dijalankan crontab seperti ini:

```bash
    0 18 * * 1-5 cd /home/anran/sisop/shift1/soal3 && pass=$(date +"\%m\%d\%Y") && unzip -P $pass=$(date +"\%m\%d\%Y") && unzip -P $pass Koleksi.zip && rm Koleksi.zip
    0 7 * * 1-5 /bin/bash /home/anran/sisop/shift1/soal3/soal3d.sh
```
#### Penjelasan

```bash
    0 7 * * 1-5 /bin/bash /home/anran/sisop/shift1/soal3/soal3d.sh
```

Karena kuuhaku meminta untuk men-zip seluruh foldernya pada jam 7 pagi setiap hari senin-jumat, maka kita hanya perlu menjalankan script pada soal poin 3d.

```bash
    0 18 * * 1-5 cd /home/anran/sisop/shift1/soal3 && pass=$(date +"\%m\%d\%Y") && unzip -P $pass=$(date +"\%m\%d\%Y") && unzip -P $pass Koleksi.zip && rm Koleksi.zip
```
Sedangkan saat jam 18.00 setiap hari senin-jumat, akan menjalankan crontab di atas. Pertama, kita harus pindah ke direktori tempat kita menyimpan Koleksi.zip menggunakan `cd /home/anran/sisop/shift1/soal3`. Kedua, kita menginisialisasi variabel `pass` yang berisi password untuk meng-unzip Koleksi.zip. Kemudian kita meng-unzip `Koleksi.zip` menggunakan command `unzip -P $pass Koleksi.zip` dan setelah itu menghapus `Koleksi.zip` setelah selesai meng-unzip.