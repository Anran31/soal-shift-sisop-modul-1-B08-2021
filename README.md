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

Untuk menghitung jumlah kemunculan tiap error, maka hasil dari command di atas dapat kita ```bash sort``` untuk mengurutkan hasilnya kemudian menggunakan ```bash uniq -c``` untuk menghitung jumlah kemunculan setiap error message. Setelah menjalankan ```bash  grep -oP "((?<=ERROR\ ).*?(?=\ \())" syslog.log | sort | uniq -c``` maka akan muncul hasil seperti ini:

```text
        13 Connection to DB failed
        10 Permission denied while closing ticket
         9 The ticket was modified while updating
         7 Ticket doesn't exist
        15 Timeout while retrieving information
        12 Tried to add information to closed ticket
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
