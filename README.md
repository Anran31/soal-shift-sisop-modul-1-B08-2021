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

### No 2

Kita merupakan kepala gudang yang mengatur keluar masuknya barang di sebuah _startup_ bernama "TokoShiSop". Steven, Manis, dan Clemong meminta kita untuk mencari beberapa kesimpulan dari data penjualan “Laporan-TokoShiSop.tsv”.

* Steven ingin mengapresiasi kinerja karyawannya selama ini dengan mengetahui **Row ID** dan **profit percentage terbesar** (jika hasil profit percentage terbesar lebih dari 1, maka ambil Row ID yang paling besar). Karena kamu bingung, Clemong memberikan definisi dari _profit percentage_, yaitu:

    _Profit Percentage_ = (_Profit_/_Cost Price_) x 100

    _Cost Price_ didapatkan dari pengurangan _Sales_ dengan _Profit_ (**Quantity diabaikan**)

```bash
awk '
BEGIN{FS="\t";MaxPP=0}
{
    PP=($21/($18-$21))*100
    if(PP >= MaxPP) {MaxPP=PP;MaxID=$1};
}
END {printf ("Transaksi terakhir dengan profit percentage terbesar yaitu %d dengan persentase %d%%.\n",MaxID,MaxPP)}' Laporan-TokoShiSop.tsv > hasil.tx
```

### No 3
