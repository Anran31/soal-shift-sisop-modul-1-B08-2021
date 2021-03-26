# soal-shift-sisop-modul-1-B08-2021
 
### No 1
Pada soal nomor 1, kita mempunyai data _syslog.log_ dari aplikasi _ticky_. _syslog.log_ berisikan data sebagai berikut:
```text
    Jan 31 00:16:25 ubuntu.local ticky: INFO Closed ticket [#1754] (noel)
    Jan 31 00:21:30 ubuntu.local ticky: ERROR The ticket was modified while updating (breee)
    ...
```
Setiap baris pada data tersebut memiliki format sebagai berikut:
```text
    <time> <hostname> <app_name>: <log_type> <log_message> (<username>)
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
