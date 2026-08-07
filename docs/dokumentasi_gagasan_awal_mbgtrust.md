# Dokumentasi Gagasan Awal & Daftar Fitur MBGTrust
## Arsip Dokumentasi Resmi Kompetisi GEMASTIK

**Nama Proyek:** MBGTrust — Sistem Pendukung Keputusan Evaluasi Menu Makan Bergizi Gratis Berbasis Umpan Balik Real-Time  
**Tujuan Kompetisi:** GEMASTIK — Bidang Pengembangan Perangkat Lunak  
**Sumber Dokumentasi:**
1. **Google Doc (Gagasan Awal):** `https://docs.google.com/document/d/16zvONdl_8WWl-5bjq52kQEtJUpK5I1YqzCMD0RRX3_U/edit?usp=sharing`
2. **Google Sheet (Daftar Fitur & SPK TOPSIS):** `https://docs.google.com/spreadsheets/d/1Of2YXLgbFil5u_ZEcvbv8WyY_kT3hZfE4JcqqaRzHpg/edit?usp=sharing`

---

## 1. Deskripsi Singkat Perangkat Lunak

**MBGTrust** merupakan Sistem Pendukung Keputusan (SPK) berbasis *web* dan *mobile* yang dirancang untuk membantu **Satuan Pelayanan Pemenuhan Gizi (SPPG)** dalam mengevaluasi kualitas menu MBG sekaligus merencanakan jumlah produksi makanan berdasarkan umpan balik penerima manfaat. 

Sistem memungkinkan penerima manfaat memberikan penilaian terhadap menu yang telah dikonsumsi serta melakukan konfirmasi kesediaan menerima menu untuk hari berikutnya (H+1). Seluruh data tersebut diolah menjadi rekomendasi bagi SPPG untuk meningkatkan kualitas menu, mengurangi potensi pemborosan pangan (*food waste*), dan mendukung efisiensi penggunaan anggaran.

---

## 2. 7 Asumsi Operasional Sistem

1. **Fokus Implementasi**: Sistem hanya diimplementasikan pada penerima manfaat Program Makan Bergizi Gratis di lingkungan sekolah.
2. **Perencanaan Menu H-1**: SPPG telah menyusun dan mengunggah rencana menu minimal H-1 sebelum makanan didistribusikan.
3. **Petugas Pengelola Sekolah**: Setiap sekolah memiliki minimal satu petugas (wali kelas, operator sekolah, atau petugas MBG) yang bertanggung jawab mengelola dan menginput sistem apabila penerima manfaat tidak dapat mengaksesnya secara mandiri.
4. **Waktu Konfirmasi Presensi**: Konfirmasi kesediaan penerima manfaat dilakukan untuk menu hari berikutnya (H+1), bukan untuk menu yang sedang dikonsumsi.
5. **Data Konfirmasi Sebagai Estimasi**: Data konfirmasi digunakan sebagai dasar estimasi kebutuhan produksi, bukan sebagai satu-satunya acuan mutlak. SPPG tetap dapat melakukan penyesuaian berdasarkan kebijakan operasional.
6. **Umpan Balik Post-Konsumsi**: Umpan balik penerima manfaat diberikan setelah makanan dikonsumsi agar penilaian mencerminkan pengalaman yang sebenarnya.
7. **Integritas Data**: Seluruh data yang masuk dianggap valid dan digunakan sebagai dasar analisis oleh Sistem Pendukung Keputusan.

---

## 3. 12 Tahapan Alur Kerja Operasional (Workflow)

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                       Siklus Harian Operasional MBGTrust                    │
└──────┬──────────────┬──────────────┬──────────────┬──────────────┬──────────┘
       │              │              │              │              │
┌──────▼──────┐┌──────▼──────┐┌──────▼──────┐┌──────▼──────┐┌──────▼──────┐
│  Langkah 1  ││  Langkah 2  ││  Langkah 3  ││  Langkah 4  ││  Langkah 5  │
│ SPPG Unggah ││ Distribusi  ││ Konfirmasi  ││ Penilaian   ││ Tampil Menu │
│ Menu H+1    ││ Makanan H-0 ││ Penerimaan  ││ Post-Makan  ││ Menu H+1    │
└─────────────┘└─────────────┘└─────────────┘└─────────────┘└─────────────┘
       │              │              │              │              │
┌──────▼──────┐┌──────▼──────┐┌──────▼──────┐┌──────▼──────┐┌──────▼──────┐
│  Langkah 6  ││  Langkah 7  ││  Langkah 8  ││  Langkah 9  ││ Langkah 10-12│
│ Input Alasan││ Rekapitulasi││ Dasar       ││ Belanja &   ││ Distribusi & │
│ Penolakan   ││ Porsi H+1   ││ Bahan Baku  ││ Memasak     ││ Processing   │
└─────────────┘└─────────────┘└─────────────┘└─────────────┘└─────────────┘
```

1. **SPPG Menyusun Menu**: SPPG menyusun dan mengunggah rencana menu MBG untuk hari berikutnya ke dalam sistem.
2. **Distribusi Makanan Hari Berjalan**: Penerima manfaat menerima makanan MBG sesuai menu pada hari berjalan.
3. **Konfirmasi Penerimaan**: Penerima manfaat melakukan konfirmasi bahwa makanan telah diterima.
4. **Penilaian Umpan Balik**: Setelah selesai makan, penerima manfaat memberikan penilaian terhadap menu yang dikonsumsi (rasa, kesukaan, porsi, dan masukan/komentar).
5. **Tampilan Menu H+1**: Sistem menampilkan rencana menu hari berikutnya agar penerima manfaat dapat mengonfirmasi kesediaan menerima menu tersebut.
6. **Input Alasan Penolakan**: Apabila penerima manfaat tidak dapat mengonsumsi menu H+1, mereka memilih alasan (alergi, pantangan makanan, sakit, atau izin/absen).
7. **Kalkulasi Estimasi Porsi**: Sistem merekap seluruh data konfirmasi dan menghitung estimasi kebutuhan porsi presisi H+1.
8. **Dasar Pengadaan SPPG**: SPPG menggunakan hasil rekapitulasi sebagai dasar pengadaan bahan baku dan perencanaan jumlah makanan yang diproduksi.
9. **Proses Memasak**: SPPG melakukan Pembelian bahan pangan dan proses memasak sesuai estimasi kebutuhan presisi.
10. **Pengiriman Makanan**: Makanan didistribusikan kepada penerima manfaat sesuai jumlah porsi yang telah diproduksi.
11. **Eksekusi Engine SPK**: Sistem mengolah data penilaian dan konfirmasi menggunakan SPK TOPSIS untuk menghasilkan rekomendasi perbaikan menu.
12. **Siklus Sustained**: Proses kembali ke langkah pertama sehingga evaluasi, perencanaan, dan produksi berlangsung secara berkelanjutan setiap hari.

---

## 4. 7 Catatan & Analitik Utama Sistem

1. **Dashboard Kepuasan & Penerimaan**: Menampilkan tingkat kepuasan penerima manfaat, tingkat penerimaan menu, alasan penolakan, serta tren penilaian dari waktu ke waktu.
2. **Laporan Efisiensi Produksi (*Food Waste Reduction*)**: Perbandingan jumlah porsi yang diproduksi dengan porsi yang diterima serta estimasi kg makanan tercegah dari pemborosan.
3. **Analisis Efisiensi Anggaran**: Estimasi penghematan nominal rupiah akibat produksi porsi yang presisi dan tepat sasaran.
4. **Output Rekomendasi Keputusan SPK**: Menghasilkan rekomendasi menu otomatis: **Dipertahankan**, **Diperbaiki/Dievaluasi**, atau **Diganti**.
5. **Unduh Laporan Multi-Periode**: Laporan harian, mingguan, dan bulanan dapat diunduh (PDF/Excel) oleh SPPG maupun instansi terkait sebagai bahan audit.
6. **Mekanisme Ganda Pengumpulan Data**: Mendukung pengisian mandiri oleh siswa atau secara kolektif oleh petugas sekolah (wali kelas/operator).
7. **Implementasi Proyek Percontohan (*Pilot Project*)**: Penerapan tahap awal di beberapa sekolah percontohan sebelum diperluas ke seluruh satuan pendidikan.

---

## 5. Profil Tim & Pembagian Tugas (*Jobdesk*)

* **Front-End Lead:** Fuadi Dhiyaulhaq (Flutter Mobile & Web)
* **Back-End Lead:** Daffarael Anaqi Ali (Node.js ExpressJS + MySQL Database)
* **Video & UI/UX Design:** Dhyva Aulia Hendri
* **Sistematika Proposal:** Ditulis secara bersama-sama oleh seluruh anggota tim.

---

## 6. Rincian 27 Fitur Fungsional per Modul

| No | Nama Fitur Fungsional | Modul Sistem | Hak Akses Utama |
| :--- | :--- | :--- | :--- |
| 1 | Penerima manfaat melakukan registrasi akun | Manajemen Pengguna | Siswa |
| 2 | Penerima manfaat melakukan login ke dalam sistem | Manajemen Pengguna | Siswa |
| 3 | Penerima manfaat mengelola profil akun | Manajemen Pengguna | Siswa |
| 4 | SPPG melakukan login ke dalam sistem | Manajemen Pengguna | Admin SPPG |
| 5 | SPPG mengelola profil akun | Manajemen Pengguna | Admin SPPG |
| 6 | SPPG mengelola data master menu MBG | Manajemen Menu | Admin SPPG |
| 7 | SPPG menyusun jadwal menu harian SPPG | Manajemen Menu | Admin SPPG |
| 8 | Penerima manfaat melihat menu MBG hari ini | Manajemen Menu | Siswa / Publik |
| 9 | Penerima manfaat melihat rencana menu besok | Manajemen Menu | Siswa / Publik |
| 10 | Penerima manfaat mengonfirmasi penerimaan makanan | Konfirmasi & Evaluasi | Siswa |
| 11 | Penerima manfaat memberikan penilaian terhadap menu | Konfirmasi & Evaluasi | Siswa |
| 12 | Penerima manfaat memberikan komentar atau saran | Konfirmasi & Evaluasi | Siswa |
| 13 | Penerima manfaat mengonfirmasi kesediaan menu besok | Konfirmasi & Evaluasi | Siswa |
| 14 | Penerima manfaat memilih alasan jika tidak bisa menerima menu | Konfirmasi & Evaluasi | Siswa |
| 15 | Sistem merekap data konfirmasi penerima manfaat | Perencanaan Produksi | Sistem Otomatis |
| 16 | Sistem menghitung estimasi kebutuhan jumlah porsi | Perencanaan Produksi | Sistem Otomatis |
| 17 | SPPG melihat hasil estimasi kebutuhan produksi | Perencanaan Produksi | Admin SPPG |
| 18 | SPPG mengelola status proses produksi makanan | Produksi & Distribusi | Admin SPPG |
| 19 | SPPG mengelola status distribusi makanan | Produksi & Distribusi | Admin SPPG / Petugas |
| 20 | Sistem mengolah data evaluasi menggunakan SPK TOPSIS | SPK TOPSIS | Sistem Otomatis |
| 21 | Sistem menghasilkan rekomendasi perbaikan menu MBG | SPK TOPSIS | Sistem Otomatis |
| 22 | SPPG melihat rekomendasi menu hasil SPK | SPK TOPSIS | Admin SPPG |
| 23 | SPPG melihat dashboard kepuasan penerima manfaat | Dashboard & Pelaporan | Admin SPPG |
| 24 | SPPG melihat dashboard tingkat penerimaan menu | Dashboard & Pelaporan | Admin SPPG |
| 25 | SPPG melihat dashboard efisiensi produksi | Dashboard & Pelaporan | Admin SPPG |
| 26 | SPPG melihat dashboard efisiensi anggaran | Dashboard & Pelaporan | Admin SPPG |
| 27 | SPPG mengunduh laporan evaluasi MBG | Dashboard & Pelaporan | Admin SPPG |

---

## 7. Formulasi Sistem Pendukung Keputusan (TOPSIS)

**TOPSIS (*Technique for Order of Preference by Similarity to Ideal Solution*)** memilih alternatif menu terbaik berdasarkan jarak Euclidean terdekat dari Solusi Ideal Positif ($A^+$) dan jarak terjauh dari Solusi Ideal Negatif ($A^-$).

### Matriks Kriteria & Pembobotan ($W$)
Total akumulasi bobot: `Σ w_j = 1.0 (100%)`

| Kode | Kriteria | Sifat (*Attribute*) | Bobot ($w_j$) | Keterangan & Sumber Data |
| :--- | :--- | :--- | :--- | :--- |
| **C1** | Penilaian Rasa | **Benefit** | 20% (0.20) | Rata-rata skor rasa (skala 1-5) dari siswa |
| **C2** | Tingkat Kesukaan | **Benefit** | 15% (0.15) | Rata-rata skor kesukaan umum (skala 1-5) |
| **C3** | Kesesuaian Porsi | **Benefit** | 10% (0.10) | Rata-rata kecukupan porsi (skala 1-5) |
| **C4** | Potensi Food Waste | **Cost** | 30% (0.30) | Persentase makanan tersisa/dibuang (%) |
| **C5** | Tingkat Penolakan | **Cost** | 25% (0.25) | Persentase siswa menolak menu H+1 (%) |

---

## 8. Sistematika Penulisan Proposal GEMASTIK

Dokumen proposal resmi Gemastik Bidang Pengembangan Perangkat Lunak mengikuti struktur berikut:
* **a) Judul / Nama Perangkat Lunak**
* **b) Latar Belakang Ide Perangkat Lunak**
* **c) Tujuan dan Manfaat Dikembangkannya Perangkat Lunak**
* **d) Batasan Perangkat Lunak yang Dikembangkan**
* **e) Metodologi Pengembangan Perangkat Lunak**
* **f) Analisis Kebutuhan dan Desain Solusi Perangkat Lunak**
* **g) Implementasi Perangkat Lunak**
* **h) Screenshot Mockup Interface Perangkat Lunak**
* **i) Dokumentasi Cara Penggunaan Perangkat Lunak**

---
*Akhir dari Arsip Dokumentasi Resmi Gagasan Awal MBGTrust*
