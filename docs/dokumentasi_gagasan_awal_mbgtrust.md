# Dokumentasi Gagasan Awal & Daftar Fitur MBGTrust
## Arsip Dokumentasi Resmi Kompetisi GEMASTIK

**Nama Proyek:** MBGTrust — Platform Digital Berbasis AI untuk Mitigasi Food Waste pada Program Makan Bergizi Gratis  
**Tujuan Kompetisi:** GEMASTIK — Bidang Pengembangan Perangkat Lunak  
**Sumber Dokumentasi:**
1. **Google Doc (Gagasan Awal):** `https://docs.google.com/document/d/16zvONdl_8WWl-5bjq52kQEtJUpK5I1YqzCMD0RRX3_U/edit?usp=sharing`
2. **Google Sheet (Daftar Fitur & PIC):** `https://docs.google.com/spreadsheets/d/1Of2YXLgbFil5u_ZEcvbv8WyY_kT3hZfE4JcqqaRzHpg/edit?usp=sharing`

---

## 1. Deskripsi Singkat Perangkat Lunak

**MBGTrust** adalah platform digital cerdas yang mengintegrasikan **Machine Learning (ML)** dan **Sistem Pendukung Keputusan (SPK)** untuk mitigasi *food waste* pada Program Makan Bergizi Gratis. Platform ini menggunakan ML untuk melakukan **analisis sentimen** terhadap ulasan tekstual siswa guna memahami alasan di balik sisa makanan, sementara metode **TOPSIS** digunakan untuk meranking menu berdasarkan kriteria kuantitatif. Kombinasi ini menghasilkan rekomendasi strategis bagi SPPG untuk mengoptimalkan volume produksi dan komposisi menu secara akurat dan efisien.

---

## 2. Prasyarat & Konteks Penggunaan

1. Sekolah telah terdaftar dalam program Makan Bergizi Gratis (MBG).
2. SPPG telah mendistribusikan porsi makanan kepada siswa.
3. Siswa telah selesai mengonsumsi makanan tersebut.

---

## 3. Alur Kerja Operasional

### Alur Siswa (Harian)
1. Siswa menerima dan mengonsumsi paket MBG.
2. Siswa membuka aplikasi dan menjawab: "Apakah kamu mengonsumsi MBG hari ini?"
3. Jika **Ya**: Siswa mengulas menu melalui **rating dan ulasan teks**, serta **melaporkan volume sisa makanan** (*food waste*). Input ulasan ini diproses oleh mesin **Natural Language Processing (NLP)**.
4. Jika **Tidak**: Siswa memberikan alasan spesifik (sakit, tidak hadir, pantangan, dll).
5. Siswa mendapatkan *feedback* gamifikasi berupa **poin** dan **visualisasi dampak pengurangan food waste**.

### Alur SPPG (Mingguan)
1. SPPG menerima rekapitulasi data harian dari siswa secara *real-time*.
2. Pada akhir minggu, AI menganalisis sentimen ulasan (data kualitatif) yang diintegrasikan dengan data numerik dalam SPK TOPSIS.
3. SPPG menerima rekomendasi komprehensif (**penyesuaian porsi dan perbaikan komposisi menu**) untuk operasional minggu berikutnya.
4. Proses kembali ke siklus awal (pembaruan data mingguan baru).

---

## 4. Arsitektur 3 Peran Pengguna

| Peran | Deskripsi | Cakupan Akses |
| :--- | :--- | :--- |
| **Super Admin** | Administrator sistem tertinggi | Manajemen seluruh entitas: sekolah, Admin SPPG, Penerima Manfaat |
| **Admin SPPG** | Pengelola program MBG di tingkat SPPG | Dashboard, Menu, Jadwal, Produksi, Distribusi, SPK TOPSIS |
| **Penerima Manfaat (Siswa)** | Penerima paket MBG di sekolah | Konfirmasi konsumsi, Ulasan menu, Pelaporan sisa, Gamifikasi |

---

## 5. Rincian 27 Fitur Fungsional per Modul

| No | Aktor + Fitur (Fungsional) | Modul |
| :--- | :--- | :--- |
| **1** | Super Admin melakukan login ke dalam sistem | Manajemen Pengguna |
| **2** | Super Admin mengelola profil akun | Manajemen Pengguna |
| **3** | Super Admin mengelola data master entitas sekolah | Manajemen Pengguna |
| **4** | Super Admin mengelola data master akun Admin SPPG | Manajemen Pengguna |
| **5** | Super Admin mengelola data master akun Penerima Manfaat (Siswa) | Manajemen Pengguna |
| **6** | Admin SPPG melakukan login ke dalam sistem | Manajemen Pengguna |
| **7** | Admin SPPG mengelola profil akun | Manajemen Pengguna |
| **8** | Penerima Manfaat (Siswa) melakukan login menggunakan kredensial yang diberikan | Manajemen Pengguna |
| **9** | Penerima Manfaat (Siswa) memperbarui profil dan kata sandi akun | Manajemen Pengguna |
| **10** | Penerima Manfaat (Siswa) mengonfirmasi konsumsi MBG harian | Pelaporan & Evaluasi |
| **11** | Penerima Manfaat (Siswa) memberikan rating dan ulasan teks terhadap menu | Pelaporan & Evaluasi |
| **12** | Penerima Manfaat (Siswa) melaporkan estimasi volume sisa makanan (*food waste*) | Pelaporan & Evaluasi |
| **13** | Penerima Manfaat (Siswa) memberikan alasan spesifik jika tidak mengonsumsi MBG | Pelaporan & Evaluasi |
| **14** | Penerima Manfaat (Siswa) melihat poin gamifikasi dan visualisasi dampak lingkungan | Pelaporan & Evaluasi |
| **15** | Admin SPPG melihat rekapitulasi data harian siswa secara *real-time* | Dashboard & Analitik |
| **16** | Admin SPPG melihat hasil analisis sentimen ulasan menggunakan NLP | Dashboard & Analitik |
| **17** | Admin SPPG melihat rekomendasi penyesuaian porsi dan komposisi menu dari AI | Dashboard & Analitik |
| **18** | Admin SPPG melihat tren *food waste* dan tingkat akurasi prediksi porsi | Dashboard & Analitik |
| **19** | Sistem memproses ulasan teks menggunakan Natural Language Processing (Sentiment Analysis) | Sistem Pendukung Keputusan |
| **20** | Sistem meranking menu secara otomatis menggunakan metode SPK TOPSIS | Sistem Pendukung Keputusan |
| **21** | Admin SPPG mengelola data master bahan baku makanan | Manajemen Menu & Produksi |
| **22** | Admin SPPG mengelola data master menu makanan | Manajemen Menu & Produksi |
| **23** | Admin SPPG menyusun dan menjadwalkan menu harian | Manajemen Menu & Produksi |
| **24** | Admin SPPG memantau dan mengelola status produksi serta distribusi MBG | Manajemen Menu & Produksi |
| **25** | Penerima Manfaat (Siswa) melihat daftar menu harian yang dijadwalkan | Manajemen Menu & Produksi |
| **26** | Penerima Manfaat (Siswa) melihat detail komposisi bahan pada menu | Manajemen Menu & Produksi |
| **27** | Penerima Manfaat (Siswa) mengatur preferensi makanan atau riwayat alergi bahan | Manajemen Menu & Produksi |

---

## 6. Ringkasan Pembagian 5 Modul

| Modul | Deskripsi Singkat | Jumlah Fitur |
| :--- | :--- | :--- |
| **1. Manajemen Pengguna** | Autentikasi 3 peran, manajemen entitas sekolah, akun Admin SPPG, dan Penerima Manfaat | 9 |
| **2. Pelaporan & Evaluasi** | Konfirmasi konsumsi, ulasan teks + rating, pelaporan sisa makanan, gamifikasi | 5 |
| **3. Dashboard & Analitik** | Rekapitulasi data real-time, hasil NLP, rekomendasi AI, tren food waste | 4 |
| **4. Sistem Pendukung Keputusan** | Pemrosesan NLP Sentiment Analysis + perankingan TOPSIS | 2 |
| **5. Manajemen Menu & Produksi** | Master bahan baku, master menu, jadwal, distribusi, preferensi siswa | 7 |
| **Total** | | **27** |

---

## 7. Sistem Pendukung Keputusan (SPK) Berbasis AI

### Pilar 1 — ML Sentiment Analysis (Fitur 19)
Komponen AI menggunakan *Sentiment Analysis* untuk mengolah ulasan teks siswa, guna mengidentifikasi alasan spesifik mengapa *food waste* terjadi (misalnya: tekstur keras, rasa terlalu asin, atau aroma tidak sedap). Output analisis ML dikonversi menjadi **input kualitatif** yang memperkuat data kuantitatif dalam TOPSIS.

### Pilar 2 — SPK TOPSIS (Fitur 20)
Metode TOPSIS (*Technique for Order of Preference by Similarity to Ideal Solution*) meranking menu berdasarkan 5 kriteria. Sistem menghasilkan rekomendasi: menu dipertahankan, dimodifikasi porsinya, atau diganti.

### Tabel Kriteria Penilaian TOPSIS

| Kode | Nama Kriteria | Sifat | Bobot (W) | Sumber Data |
| :--- | :--- | :--- | :--- | :--- |
| **C1** | Rasa | **Benefit** | 20% (0.20) | Rata-rata rating rasa dari siswa (skala 1–5) |
| **C2** | Tingkat Kesukaan | **Benefit** | 15% (0.15) | Rata-rata rating kesukaan umum (skala 1–5) |
| **C3** | Kesesuaian Porsi | **Benefit** | 10% (0.10) | Rata-rata kesesuaian porsi (skala 1–5) |
| **C4** | Tingkat Konsumsi Makanan | **Benefit** | 30% (0.30) | Rata-rata persentase makanan yang dikonsumsi (%) |
| **C5** | Tingkat Penerimaan MBG | **Benefit** | 25% (0.25) | Persentase siswa yang mengonsumsi MBG (%) |

> **Catatan Penting:** Seluruh 5 kriteria bersifat **Benefit** — semakin tinggi nilainya semakin baik kualitas menu tersebut.

---

## 8. Catatan Desain Sistem

1. **Dashboard SPPG** berfokus pada visualisasi tren *food waste* dan akurasi prediksi porsi.
2. **Fitur gamifikasi siswa** mencakup papan peringkat kontribusi lingkungan (*leaderboard*) dan klaim poin hadiah.
3. **Siklus data tertutup** memastikan perbaikan berkelanjutan:
   - Input ulasan siswa (data mentah)
   → Analisis Sentimen ML (NLP)
   → Pembobotan SPK TOPSIS
   → Rekomendasi produksi SPPG
   → Implementasi di lapangan
   → Siklus berikutnya

---

## 9. Profil Tim & Pembagian Tugas (*Jobdesk*)

* **Front-End Lead:** Fuadi Dhiyaulhaq (Flutter Mobile)
* **Back-End Lead:** Daffarael Anaqi Ali (Node.js ExpressJS + MySQL Database)
* **Video & UI/UX Design:** Dhyva Aulia Hendri
* **Sistematika Proposal:** Ditulis secara bersama-sama oleh seluruh anggota tim.

---
*Arsip Dokumentasi Resmi Gagasan Awal MBGTrust — Sesuai Google Doc & Spreadsheet Asli*
