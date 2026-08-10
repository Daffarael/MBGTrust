# Skema Database MBGTrust — Versi Final

**Nama Proyek:** MBGTrust — Platform Digital Berbasis AI untuk Mitigasi Food Waste pada Program Makan Bergizi Gratis  
**Database Engine:** MySQL 8.0 (via Prisma ORM v7)  
**Versi Dokumen:** 6.0.0 (Disesuaikan Gagasan Awal — 3 Peran, NLP, Kriteria TOPSIS All-Benefit)  
**Status:** ✅ **FINAL** — Source of truth adalah `mbgtrust-backend/prisma/schema.prisma`

> ⚠️ Diperbarui ke v6.0.0: Menambahkan peran Super Admin, tabel `hasil_nlp`, dan mengubah C4/C5 TOPSIS menjadi Benefit (sesuai Gagasan Awal).

---

## 1. Ringkasan Tabel (13 Tabel)

| # | Nama Tabel SQL | Model Prisma | Fungsi Utama |
|:---|:---|:---|:---|
| 1 | `pengguna` | `Pengguna` | Semua akun pengguna 3 peran + poin XP gamifikasi |
| 2 | `token_penyegar` | `TokenPenyegar` | JWT Refresh Token (rotasi otomatis) |
| 3 | `sekolah` | `Sekolah` | Data master sekolah penerima MBG (dikelola Super Admin) |
| 4 | `bahan_baku` | `BahanBaku` | Data master bahan baku makanan (dikelola Admin SPPG) |
| 5 | `menu` | `Menu` | Data master menu + info gizi + alergen + referensi bahan baku |
| 6 | `jadwal_menu` | `JadwalMenu` | Penjadwalan menu harian per sekolah |
| 7 | `evaluasi_menu` | `EvaluasiMenu` | Umpan balik siswa — sumber C1/C2/C3/C4 TOPSIS (Benefit) |
| 8 | `konfirmasi` | `Konfirmasi` | Konfirmasi kehadiran — sumber C5 TOPSIS (Benefit) |
| 9 | `alasan_penolakan` | `AlasanPenolakan` | Master alasan penolakan (4 kode standar) |
| 10 | `rencana_produksi` | `RencanaProduksi` | Estimasi porsi presisi H+1 + buffer 5% |
| 11 | `produksi` | `Produksi` | Tracking siklus memasak dapur SPPG |
| 12 | `distribusi` | `Distribusi` | Tracking pengiriman logistik ke sekolah |
| 13 | `eksekusi_topsis` | `EksekusiTopsis` | Hasil audit SPK TOPSIS disimpan permanen |
| 14 | `hasil_nlp` | `HasilNlp` | Hasil NLP Sentiment Analysis per ulasan teks siswa |

---

## 2. Diagram Relasi (ERD)

```
┌────────────────┐  N:1   ┌──────────────┐
│    pengguna    │───────►│   sekolah    │
└───────┬────────┘        └──────┬───────┘
        │ 1:N                    │ 1:N
        │              ┌─────────┴──────────┐  N:1  ┌──────┐
        │              │    jadwal_menu     │◄──────│ menu │
        │              └──┬──────────┬──────┘       └──────┘
        │                 │          │
        │      ┌──────────┤          ├─────────┬──────────────┐
        │      │ 1:N      │ 1:N      │ 1:1     │ 1:1          │ 1:N
        │      ▼          ▼          ▼         ▼              ▼
        │  konfirmasi  evaluasi  rencana_   produksi     distribusi
        │      │        _menu   _produksi
        │      │ N:1
        │      ▼
        │  alasan_
        │  penolakan
        │
        │ 1:N
        ▼
  token_penyegar

eksekusi_topsis (berdiri sendiri — tidak berelasi langsung)
```

---

## 3. Detail Setiap Tabel

### Tabel 1: `pengguna`

| Kolom SQL | Field Prisma | Tipe | Wajib | Keterangan |
|:---|:---|:---|:---:|:---|
| `id` | `id` | `Int @id` | ✅ | Primary Key |
| `nik_nisn` | `nikNisn` | `String? @unique` | ❌ | Login siswa via NISN 16 digit |
| `nama_lengkap` | `namaLengkap` | `String` | ✅ | Nama lengkap |
| `email` | `email` | `String? @unique` | ❌ | Login `SPPG_ADMIN` & `SUPER_ADMIN` |
| `katasandi` | `katasandi` | `String` | ✅ | Hash bcrypt 12 rounds |
| `peran` | `peran` | `Enum Peran` | ✅ | `SUPER_ADMIN` / `SPPG_ADMIN` / `PENERIMA_MANFAAT` |
| `tingkat_kelas` | `tingkatKelas` | `String?` | ❌ | Hanya siswa. Contoh: `"5-B"` |
| `riwayat_alergi` | `riwayatAlergi` | `Json?` | ❌ | Array: `["Kacang Tanah", "Udang"]` |
| `nomor_kontak` | `nomorKontak` | `String?` | ❌ | No. HP wali siswa |
| `poin_xp` | `poinXp` | `Int @default(0)` | ✅ | Gamifikasi: +50 XP per evaluasi |
| `dampak_lingkungan_gram` | `dampakLingkunganGram` | `Float @default(0)` | ✅ | Akumulasi gram food waste dicegah (visualisasi gamifikasi) |
| `id_sekolah` | `idSekolah` | `Int? (FK)` | ❌ | Relasi ke `sekolah` |
| `dibuat_pada` | `dibuatPada` | `DateTime` | ✅ | Auto timestamp |
| `diubah_pada` | `diubahPada` | `DateTime @updatedAt` | ✅ | Auto update |

---

### Tabel 2: `token_penyegar`

| Kolom SQL | Field Prisma | Tipe | Wajib | Keterangan |
|:---|:---|:---|:---:|:---|
| `id` | `id` | `Int @id` | ✅ | Primary Key |
| `id_pengguna` | `idPengguna` | `Int (FK)` | ✅ | Relasi ke `pengguna` |
| `token` | `token` | `String @unique @db.VarChar(512)` | ✅ | JWT Refresh Token — VarChar (bukan Text) agar bisa UNIQUE index |
| `kedaluwarsa` | `kedaluwarsa` | `DateTime` | ✅ | Waktu expire token |
| `dibuat_pada` | `dibuatPada` | `DateTime` | ✅ | Auto timestamp |

---

### Tabel 3: `sekolah`

| Kolom SQL | Field Prisma | Tipe | Wajib | Keterangan |
|:---|:---|:---|:---:|:---|
| `id` | `id` | `Int @id` | ✅ | Primary Key |
| `nama` | `nama` | `String` | ✅ | Nama sekolah |
| `alamat` | `alamat` | `String?` | ❌ | Alamat lengkap |
| `dibuat_pada` | `dibuatPada` | `DateTime` | ✅ | Auto timestamp |

---

### Tabel 4: `menu`

| Kolom SQL | Field Prisma | Tipe | Wajib | Keterangan |
|:---|:---|:---|:---:|:---|
| `id` | `id` | `Int @id` | ✅ | Primary Key |
| `nama_menu` | `namaMenu` | `String` | ✅ | Contoh: `"Nasi Ayam Bakar Kecap"` |
| `kategori` | `kategori` | `Enum KategoriMenu` | ✅ | `MAKANAN_BERAT` / `SNACK` / `MINUMAN` |
| `deskripsi` | `deskripsi` | `String?` | ❌ | Komposisi detail |
| `kalori_kkal` | `kaloriKkal` | `Float?` | ❌ | Kalori total |
| `protein_gram` | `proteinGram` | `Float?` | ❌ | Protein (gram) |
| `karbohidrat_gram` | `karbohidratGram` | `Float?` | ❌ | Karbohidrat (gram) |
| `lemak_gram` | `lemakGram` | `Float?` | ❌ | Lemak (gram) |
| `komposisi_bahan` | `komposisiBahan` | `Json?` | ❌ | Array: `["Dada Ayam", "Nasi"]` |
| `potensi_alergen` | `potensiAlergen` | `Json?` | ❌ | Array: `["Kedelai", "Susu"]` |
| `estimasi_biaya_per_porsi` | `estimasiHargaPerPorsi` | `Int?` | ❌ | Rupiah per porsi |
| `gambar_url` | `gambarUrl` | `String?` | ❌ | URL foto menu |
| `dibuat_pada` | `dibuatPada` | `DateTime` | ✅ | Auto timestamp |
| `diubah_pada` | `diubahPada` | `DateTime @updatedAt` | ✅ | Auto update |

---

### Tabel 4: `bahan_baku` (Master Bahan Baku Makanan)

> Dikelola oleh Admin SPPG. Fitur 21 dari Gagasan Awal.

| Kolom SQL | Field Prisma | Tipe | Wajib | Keterangan |
|:---|:---|:---|:---:|:---|
| `id` | `id` | `Int @id` | ✅ | Primary Key |
| `nama_bahan` | `namaBahan` | `String` | ✅ | Contoh: `"Dada Ayam"` |
| `satuan` | `satuan` | `String` | ✅ | Contoh: `"gram"`, `"ml"`, `"butir"` |
| `kalori_per_100g` | `kaloriPer100g` | `Float?` | ❌ | Nilai gizi per 100 gram |
| `protein_per_100g` | `proteinPer100g` | `Float?` | ❌ | Protein per 100 gram |
| `potensi_alergen` | `potensiAlergen` | `Boolean @default(false)` | ✅ | Apakah berpotensi alergen? |
| `harga_per_satuan` | `hargaPerSatuan` | `Int?` | ❌ | Harga dalam Rupiah per satuan |
| `dibuat_pada` | `dibuatPada` | `DateTime` | ✅ | Auto timestamp |
| `diubah_pada` | `diubahPada` | `DateTime @updatedAt` | ✅ | Auto update |

---

### Tabel 5: `jadwal_menu`

| Kolom SQL | Field Prisma | Tipe | Wajib | Keterangan |
|:---|:---|:---|:---:|:---|
| `id` | `id` | `Int @id` | ✅ | Primary Key |
| `id_menu` | `idMenu` | `Int (FK)` | ✅ | Relasi ke `menu` |
| `id_sekolah` | `idSekolah` | `Int (FK)` | ✅ | Relasi ke `sekolah` |
| `tanggal` | `tanggal` | `DateTime @db.Date` | ✅ | Tanggal penyajian menu |
| `target_total_porsi` | `targetTotalPorsi` | `Int?` | ❌ | Input awal admin saat plotting |
| `dibuat_pada` | `dibuatPada` | `DateTime` | ✅ | Auto timestamp |

> **Constraint Unik:** `(id_sekolah, tanggal)` — Satu sekolah = satu menu per hari.  
> **Index:** `tanggal` (query harian), `id_menu`

---

### Tabel 7: `evaluasi_menu`

Sumber data **4 dari 5 kriteria TOPSIS** (C1, C2, C3, C4). Ulasan teks diproses oleh NLP.

| Kolom SQL | Field Prisma | Tipe | Wajib | Keterangan |
|:---|:---|:---|:---:|:---|
| `id` | `id` | `Int @id` | ✅ | Primary Key |
| `id_pengguna` | `idPengguna` | `Int (FK)` | ✅ | Siapa yang mengevaluasi |
| `id_jadwal` | `idJadwal` | `Int (FK)` | ✅ | Jadwal menu yang dievaluasi |
| `menerima_porsi` | `menerimaPorsi` | `Boolean?` | ❌ | Apakah makanan diterima? |
| `penilaian_rasa` | `penilaianRasa` | `Int?` | ❌ | Rating 1–5 → **C1 TOPSIS (Benefit)** |
| `tingkat_kesukaan` | `tingkatKesukaan` | `Int?` | ❌ | Rating 1–5 → **C2 TOPSIS (Benefit)** |
| `kesesuaian_porsi` | `kesesuaianPorsi` | `Int?` | ❌ | Rating 1–5 → **C3 TOPSIS (Benefit)** |
| `persentase_dikonsumsi` | `persentaseDikonsumsi` | `Float?` | ❌ | 0.0–100.0% makanan yang dikonsumsi → **C4 TOPSIS (Benefit)** |
| `volume_sisa_gram` | `volumeSisaGram` | `Float?` | ❌ | Estimasi volume sisa makanan dalam gram (laporan food waste) |
| `ulasan_teks` | `ulasanTeks` | `String?` | ❌ | Ulasan teks bebas siswa → diproses oleh **NLP Sentiment Analysis** |
| `dibuat_pada` | `dibuatPada` | `DateTime` | ✅ | Auto timestamp |

> **Constraint Unik:** `(id_pengguna, id_jadwal)` — Satu siswa = satu evaluasi per jadwal.

---

### Tabel 8: `konfirmasi`

Sumber data **kriteria C5 TOPSIS** (Tingkat Penerimaan MBG — Benefit).  
Formula C5: `COUNT(HADIR) / COUNT(total konfirmasi) × 100` ← persentase yang **menerima** MBG

| Kolom SQL | Field Prisma | Tipe | Wajib | Keterangan |
|:---|:---|:---|:---:|:---|
| `id` | `id` | `Int @id` | ✅ | Primary Key |
| `id_pengguna` | `idPengguna` | `Int (FK)` | ✅ | Siswa yang konfirmasi |
| `id_jadwal` | `idJadwal` | `Int (FK)` | ✅ | Jadwal menu H+1 |
| `status` | `status` | `Enum StatusKonfirmasi` | ✅ | `HADIR` / `TIDAK_HADIR` / `BELUM_KONFIRMASI` |
| `id_alasan_penolakan` | `idAlasanPenolakan` | `Int? (FK)` | ❌ | Wajib jika status = `TIDAK_HADIR` |
| `catatan_khusus` | `catatanKhusus` | `String?` | ❌ | Catatan tambahan siswa |
| `dibuat_pada` | `dibuatPada` | `DateTime` | ✅ | Auto timestamp |
| `diubah_pada` | `diubahPada` | `DateTime @updatedAt` | ✅ | Update jika siswa ubah konfirmasi |

> **Constraint Unik:** `(id_pengguna, id_jadwal)` — Satu siswa = satu konfirmasi per jadwal.

---

### Tabel 8: `alasan_penolakan`

| Kolom SQL | Field Prisma | Tipe | Wajib | Keterangan |
|:---|:---|:---|:---:|:---|
| `id` | `id` | `Int @id` | ✅ | Primary Key |
| `kode` | `kode` | `String @unique` | ✅ | Kode unik. Contoh: `"ALERGI"` |
| `label` | `label` | `String` | ✅ | Teks tampil. Contoh: `"Alergi Makanan / Pantangan Medis"` |

**Data Seeder (4 Alasan Standar):**

| ID | Kode | Label |
|:---|:---|:---|
| 1 | `ALERGI` | Alergi Makanan / Pantangan Medis |
| 2 | `SAKIT` | Sakit / Tidak Masuk Sekolah |
| 3 | `PANTANGAN_AGAMA` | Pantangan Agama / Keyakinan |
| 4 | `IZIN_ABSEN` | Izin / Pulang Lebih Awal |

---

### Tabel 9: `rencana_produksi`

| Kolom SQL | Field Prisma | Tipe | Wajib | Keterangan |
|:---|:---|:---|:---:|:---|
| `id` | `id` | `Int @id` | ✅ | Primary Key |
| `id_jadwal` | `idJadwal` | `Int @unique (FK)` | ✅ | 1 jadwal = 1 rencana produksi |
| `estimasi_porsi` | `estimasiPorsi` | `Int` | ✅ | Total porsi yang harus dimasak (sudah termasuk buffer) |
| `total_hadir` | `totalHadir` | `Int` | ✅ | Total siswa konfirmasi HADIR |
| `total_tidak_hadir` | `totalTidakHadir` | `Int` | ✅ | Total siswa konfirmasi TIDAK_HADIR |
| `buffer_persentase` | `bufferPersentase` | `Float @default(5.0)` | ✅ | Cadangan porsi. Default: **5%** |
| `dibuat_pada` | `dibuatPada` | `DateTime` | ✅ | Auto timestamp |
| `diubah_pada` | `diubahPada` | `DateTime @updatedAt` | ✅ | Auto update |

> **Formula:** `estimasi_porsi = CEIL(total_hadir × (1 + buffer_persentase / 100))`

---

### Tabel 10: `produksi`

| Kolom SQL | Field Prisma | Tipe | Wajib | Keterangan |
|:---|:---|:---|:---:|:---|
| `id` | `id` | `Int @id` | ✅ | Primary Key |
| `id_jadwal` | `idJadwal` | `Int @unique (FK)` | ✅ | 1 jadwal = 1 siklus produksi |
| `status` | `status` | `Enum StatusProduksi` | ✅ | `PERSIAPAN` → `MEMASAK` → `SELESAI` |
| `jumlah_dimasak` | `jumlahDimasak` | `Int?` | ❌ | Realisasi porsi yang dimasak |
| `catatan_dapur` | `catatanDapur` | `String?` | ❌ | Catatan chef dapur |
| `dibuat_pada` | `dibuatPada` | `DateTime` | ✅ | Auto timestamp |
| `diubah_pada` | `diubahPada` | `DateTime @updatedAt` | ✅ | Auto update |

---

### Tabel 11: `distribusi`

| Kolom SQL | Field Prisma | Tipe | Wajib | Keterangan |
|:---|:---|:---|:---:|:---|
| `id` | `id` | `Int @id` | ✅ | Primary Key |
| `id_jadwal` | `idJadwal` | `Int (FK)` | ✅ | Relasi ke `jadwal_menu` |
| `status` | `status` | `Enum StatusDistribusi` | ✅ | `DISIAPKAN` → `DIKIRIM` → `TIBA_DI_SEKOLAH` |
| `waktu_tiba` | `waktuTiba` | `DateTime?` | ❌ | Dicatat otomatis saat status = `TIBA_DI_SEKOLAH` |
| `catatan_kurir` | `catatanKurir` | `String?` | ❌ | Catatan kurir pengiriman |
| `dibuat_pada` | `dibuatPada` | `DateTime` | ✅ | Auto timestamp |
| `diubah_pada` | `diubahPada` | `DateTime @updatedAt` | ✅ | Auto update |

> **Catatan:** 1 jadwal bisa memiliki beberapa record distribusi (multi-armada).

---

### Tabel 12: `eksekusi_topsis`

| Kolom SQL | Field Prisma | Tipe | Wajib | Keterangan |
|:---|:---|:---|:---:|:---|
| `id` | `id` | `Int @id` | ✅ | Primary Key |
| `periode_awal` | `periodeAwal` | `DateTime @db.Date` | ✅ | Tanggal mulai rentang evaluasi |
| `periode_akhir` | `periodeAkhir` | `DateTime @db.Date` | ✅ | Tanggal selesai rentang evaluasi |
| `hasil_json` | `hasilJson` | `Json` | ✅ | Matriks lengkap: r_ij, v_ij, A+, A-, D+, D-, V_i |
| `rekomendasi_json` | `rekomendasiJson` | `Json` | ✅ | Peringkat menu + label DIPERTAHANKAN/DIEVALUASI/DIGANTI |
| `dibuat_pada` | `dibuatPada` | `DateTime` | ✅ | Auto timestamp |

> **Tidak berelasi langsung** ke tabel lain — hasil TOPSIS bersifat snapshot audit yang tersimpan permanen.  
> **Index:** `(periode_awal, periode_akhir)` untuk query rekomendasi terbaru.

---

## 4. Tabel Tambahan: `hasil_nlp`

Hasil analisis NLP Sentiment Analysis per ulasan teks siswa.

| Kolom SQL | Field Prisma | Tipe | Wajib | Keterangan |
|:---|:---|:---|:---:|:---|
| `id` | `id` | `Int @id` | ✅ | Primary Key |
| `id_evaluasi` | `idEvaluasi` | `Int (FK)` | ✅ | Relasi ke `evaluasi_menu` |
| `id_jadwal` | `idJadwal` | `Int (FK)` | ✅ | Relasi ke `jadwal_menu` |
| `sentimen` | `sentimen` | `Enum SentimenNlp` | ✅ | `POSITIF` / `NEGATIF` / `NETRAL` |
| `kata_kunci` | `kataKunci` | `Json?` | ❌ | Array kata kunci yang diekstrak |
| `skor_sentimen` | `skorSentimen` | `Float?` | ❌ | Skor confidence NLP (0.0–1.0) |
| `dibuat_pada` | `dibuatPada` | `DateTime` | ✅ | Auto timestamp |

---

## 5. Enum

### `Peran`
| Nilai | Keterangan |
|:---|:---|
| `SUPER_ADMIN` | Administrator sistem tertinggi — kelola sekolah, Admin SPPG, Penerima Manfaat |
| `SPPG_ADMIN` | Admin Satuan Pelayanan Pemenuhan Gizi (akses operasional penuh) |
| `PENERIMA_MANFAAT` | Siswa/siswi sekolah penerima program MBG |

### `SentimenNlp`
| Nilai | Keterangan |
|:---|:---|
| `POSITIF` | Ulasan menunjukkan sentimen positif terhadap menu |
| `NEGATIF` | Ulasan menunjukkan sentimen negatif / keluhan |
| `NETRAL` | Ulasan bersifat netral atau informatif |

### `KategoriMenu`
| Nilai | Keterangan |
|:---|:---|
| `MAKANAN_BERAT` | Nasi + lauk pauk |
| `SNACK` | Camilan / kudapan |
| `MINUMAN` | Susu, jus, minuman bergizi |

### `StatusKonfirmasi`
| Nilai | Keterangan |
|:---|:---|
| `HADIR` | Siswa konfirmasi hadir & menerima menu |
| `TIDAK_HADIR` | Siswa menolak / tidak hadir |
| `BELUM_KONFIRMASI` | Default — belum ada respons |

### `StatusProduksi`
| Nilai | Keterangan |
|:---|:---|
| `PERSIAPAN` | Rencana dibuat, bahan disiapkan |
| `MEMASAK` | Sedang dalam proses memasak |
| `SELESAI` | Makanan selesai, siap didistribusi |
| `DIBATALKAN` | Produksi dibatalkan |

### `StatusDistribusi`
| Nilai | Keterangan |
|:---|:---|
| `DISIAPKAN` | Dikemas, belum dikirim |
| `DIKIRIM` | Dalam perjalanan ke sekolah |
| `TIBA_DI_SEKOLAH` | Sudah tiba & diterima di sekolah |
| `GAGAL` | Pengiriman gagal |

---

## 6. Kriteria TOPSIS & Sumber Data

> ⚠️ **PENTING:** Seluruh 5 kriteria bersifat **Benefit** — semakin tinggi nilai = semakin baik kualitas menu.

| Kode | Nama Kriteria | Sifat | Bobot | Sumber Kolom |
|:---|:---|:---|:---|:---|
| C1 | Rasa | **Benefit** ↑ | 0.20 | `evaluasi_menu.penilaian_rasa` (avg, skala 1–5) |
| C2 | Tingkat Kesukaan | **Benefit** ↑ | 0.15 | `evaluasi_menu.tingkat_kesukaan` (avg, skala 1–5) |
| C3 | Kesesuaian Porsi | **Benefit** ↑ | 0.10 | `evaluasi_menu.kesesuaian_porsi` (avg, skala 1–5) |
| C4 | Tingkat Konsumsi Makanan | **Benefit** ↑ | 0.30 | `evaluasi_menu.persentase_dikonsumsi` (avg, %) |
| C5 | Tingkat Penerimaan MBG | **Benefit** ↑ | 0.25 | `konfirmasi` COUNT(HADIR) / COUNT(total) × 100 (%) |

---

## 6. Cara Setup Database

```bash
# 1. Buat database
mysql -u root -p -e "CREATE DATABASE mbgtrust CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# 2. Set environment
cp .env.example .env
# Edit DATABASE_URL di .env

# 3. Jalankan migrasi
npm run db:migrate

# 4. Jalankan seeder (alasan_penolakan + data demo)
npm run db:seed
```

---

*Dokumen ini diperbarui secara otomatis — sumber kebenaran tunggal adalah `prisma/schema.prisma`.*
