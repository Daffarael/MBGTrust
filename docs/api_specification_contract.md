# Kontrak Spesifikasi API RESTful Enterprise (100% Lengkap)
## MBGTrust — Dokumentasi Eksklusif Seluruh Endpoint API

**Nama Proyek:** MBGTrust (Sistem Pendukung Keputusan Program Makan Bergizi Gratis)  
**Target Kompetisi:** GEMASTIK — Bidang Pengembangan Perangkat Lunak  
**Versi API:** 3.0.0 (Exhaustive Contract - 26 Endpoints)  
**URL Utama (Base URL):** `https://api.mbgtrust.id/api/v1`  
**Standar Otentikasi:** Header Otorisasi HTTP (`Authorization: Bearer <TOKEN_JWT>`)  
**Format Data:** JSON (`Content-Type: application/json`)  

---

## 1. Standar Global API & Format Amplop Response

### 1.1 Kode Status HTTP (HTTP Status Codes)
* `200 OK`: Permintaan berhasil dieksekusi dan mengembalikan data.
* `201 Created`: Sumber daya (*resource*) baru berhasil dibuat.
* `400 Bad Request`: Format payload JSON tidak valid atau gagal validasi skema (Zod/Joi).
* `401 Unauthorized`: Token JWT tidak disertakan, kedaluwarsa, atau tidak sah.
* `403 Forbidden`: Pengguna tidak memiliki peran (*role*) yang sesuai untuk mengakses endpoint.
* `404 Not Found`: Data/Sumber daya target (menu, jadwal, pengguna) tidak ditemukan.
* `409 Conflict`: Data ganda (contoh: siswa sudah mengirim evaluasi hari ini).
* `500 Internal Server Error`: Kesalahan server internal atau query basis data.

### 1.2 Format Amplop Respon Berhasil (Global Success Envelope)
```json
{
  "sukses": true,
  "kode_status": 200,
  "pesan": "Data berhasil diambil.",
  "data": {},
  "meta": {
    "halaman": 1,
    "batas": 10,
    "total_item": 100,
    "total_halaman": 10
  }
}
```

### 1.3 Format Amplop Respon Gagal (Global Error Envelope)
```json
{
  "sukses": false,
  "kode_status": 400,
  "pesan": "Validasi input gagal.",
  "kesalahan": [
    {
      "bidang": "penilaian_rasa",
      "pesan": "penilaian_rasa harus berupa angka bulat antara 1 sampai 5."
    }
  ],
  "stempel_waktu": "2026-08-07T16:55:00Z"
}
```

---

## 2. Rincian Eksklusif Seluruh 26 Endpoint per Modul

### 🔵 Modul 1: Otentikasi & Manajemen Pengguna (IAM)

#### 1.1 Pendaftaran Penerima Manfaat (Siswa)
* **Endpoint:** `POST /api/v1/otentikasi/pendaftaran`
* **Hak Akses:** `[PUBLIC]`
* **Request Body:**
```json
{
  "nik_nisn": "3171012345670001",
  "nama_lengkap": "Budi Santoso",
  "id_sekolah": "sch_78192a8c",
  "tingkat_kelas": "5-A",
  "kata_sandi": "KataSandi123!",
  "riwayat_alergi": ["Kacang Tanah", "Udang"]
}
```
* **Respon Berhasil (201 Created):**
```json
{
  "sukses": true,
  "kode_status": 201,
  "pesan": "Pendaftaran akun penerima manfaat berhasil.",
  "data": {
    "id_pengguna": "usr_991823ab",
    "nik_nisn": "3171012345670001",
    "nama_lengkap": "Budi Santoso",
    "peran": "PENERIMA_MANFAAT",
    "nama_sekolah": "SDN 01 Menteng"
  }
}
```

#### 1.2 Otentikasi / Masuk Akun Penerima Manfaat
* **Endpoint:** `POST /api/v1/otentikasi/masuk`
* **Hak Akses:** `[PUBLIC]`
* **Request Body:**
```json
{
  "nik_nisn": "3171012345670001",
  "kata_sandi": "KataSandi123!"
}
```
* **Respon Berhasil (200 OK):**
```json
{
  "sukses": true,
  "kode_status": 200,
  "pesan": "Autentikasi berhasil.",
  "data": {
    "token_akses": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "token_penyegar": "def50293847291a0cde...",
    "jenis_token": "Bearer",
    "kadaluwarsa_dalam_detik": 86400,
    "pengguna": {
      "id_pengguna": "usr_991823ab",
      "nama_lengkap": "Budi Santoso",
      "peran": "PENERIMA_MANFAAT",
      "id_sekolah": "sch_78192a8c"
    }
  }
}
```

#### 1.3 Otentikasi / Masuk Akun Admin SPPG (Fitur #4)
* **Endpoint:** `POST /api/v1/otentikasi/sppg/masuk`
* **Hak Akses:** `[PUBLIC]`
* **Request Body:**
```json
{
  "username_email": "admin.sppg@mbgtrust.id",
  "kata_sandi": "AdminSPPG2026!"
}
```
* **Respon Berhasil (200 OK):**
```json
{
  "sukses": true,
  "kode_status": 200,
  "pesan": "Autentikasi Admin SPPG berhasil.",
  "data": {
    "token_akses": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "token_penyegar": "def50293847291a0cde...",
    "jenis_token": "Bearer",
    "kadaluwarsa_dalam_detik": 86400,
    "pengguna": {
      "id_pengguna": "usr_admin_001",
      "nama_lengkap": "Pengelola SPPG Wilayah Jakarta",
      "peran": "SPPG_ADMIN"
    }
  }
}
```

#### 1.4 Perbarui Token Sesi (Refresh Token)
* **Endpoint:** `POST /api/v1/otentikasi/perbarui-token`
* **Hak Akses:** `[PUBLIC]`
* **Request Body:**
```json
{
  "token_penyegar": "def50293847291a0cde..."
}
```
* **Respon Berhasil (200 OK):**
```json
{
  "sukses": true,
  "kode_status": 200,
  "pesan": "Token akses berhasil diperbarui.",
  "data": {
    "token_akses": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9_NEW...",
    "jenis_token": "Bearer",
    "kadaluwarsa_dalam_detik": 86400
  }
}
```

#### 1.5 Ambil Profil Pengguna Aktif
* **Endpoint:** `GET /api/v1/pengguna/profil-saya`
* **Hak Akses:** `[AUTH: SEMUA]`
* **Respon Berhasil (200 OK):**
```json
{
  "sukses": true,
  "kode_status": 200,
  "pesan": "Profil pengguna berhasil diambil.",
  "data": {
    "id_pengguna": "usr_991823ab",
    "nik_nisn": "3171012345670001",
    "nama_lengkap": "Budi Santoso",
    "peran": "PENERIMA_MANFAAT",
    "id_sekolah": "sch_78192a8c",
    "nama_sekolah": "SDN 01 Menteng",
    "tingkat_kelas": "5-A",
    "riwayat_alergi": ["Kacang Tanah", "Udang"],
    "nomor_telepon": "081234567890"
  }
}
```

#### 1.6 Perbarui Profil Pengguna
* **Endpoint:** `PATCH /api/v1/pengguna/profil-saya`
* **Hak Akses:** `[AUTH: SEMUA]`
* **Request Body:**
```json
{
  "nama_lengkap": "Budi Santoso Wijaya",
  "tingkat_kelas": "5-B",
  "riwayat_alergi": ["Kacang Tanah", "Udang", "Telur"],
  "nomor_telepon": "081299998888"
}
```
* **Respon Berhasil (200 OK):**
```json
{
  "sukses": true,
  "kode_status": 200,
  "pesan": "Profil pengguna berhasil diperbarui.",
  "data": {
    "id_pengguna": "usr_991823ab",
    "nama_lengkap": "Budi Santoso Wijaya",
    "tingkat_kelas": "5-B"
  }
}
```

---

### 🟢 Modul 2: Manajemen Menu & Penjadwalan

#### 2.1 Tambah Master Menu MBG
* **Endpoint:** `POST /api/v1/menu`
* **Hak Akses:** `[AUTH: SPPG_ADMIN]`
* **Request Body:**
```json
{
  "nama_menu": "Nasi Ayam Bakar Kecap & Tumis Buncis",
  "kategori": "MAKANAN_BERAT",
  "kalori_kkal": 550,
  "protein_gram": 28.5,
  "karbohidrat_gram": 65.0,
  "lemak_gram": 14.2,
  "komposisi_bahan": ["Dada Ayam", "Nasi Putih", "Buncis", "Wortel"],
  "potensi_alergen": ["Kedelai"],
  "estimasi_biaya_per_porsi": 15000
}
```
* **Respon Berhasil (201 Created):**
```json
{
  "sukses": true,
  "kode_status": 201,
  "pesan": "Master menu MBG berhasil ditambahkan.",
  "data": {
    "id_menu": "mnu_441209cc",
    "nama_menu": "Nasi Ayam Bakar Kecap & Tumis Buncis"
  }
}
```

#### 2.2 Ambil Daftar Master Menu MBG (Daftar & Pencarian)
* **Endpoint:** `GET /api/v1/menu`
* **Hak Akses:** `[AUTH: SEMUA]`
* **Query Parameters:** `?halaman=1&batas=10&cari=Ayam`
* **Respon Berhasil (200 OK):**
```json
{
  "sukses": true,
  "kode_status": 200,
  "pesan": "Daftar menu MBG berhasil diambil.",
  "data": [
    {
      "id_menu": "mnu_441209cc",
      "nama_menu": "Nasi Ayam Bakar Kecap & Tumis Buncis",
      "kategori": "MAKANAN_BERAT",
      "kalori_kkal": 550,
      "estimasi_biaya_per_porsi": 15000
    }
  ],
  "meta": {
    "halaman": 1,
    "batas": 10,
    "total_item": 1,
    "total_halaman": 1
  }
}
```

#### 2.3 Ambil Rincian Detail Menu
* **Endpoint:** `GET /api/v1/menu/:idMenu`
* **Hak Akses:** `[AUTH: SEMUA]`
* **Respon Berhasil (200 OK):**
```json
{
  "sukses": true,
  "kode_status": 200,
  "pesan": "Detail menu berhasil diambil.",
  "data": {
    "id_menu": "mnu_441209cc",
    "nama_menu": "Nasi Ayam Bakar Kecap & Tumis Buncis",
    "kalori_kkal": 550,
    "protein_gram": 28.5,
    "karbohidrat_gram": 65.0,
    "lemak_gram": 14.2,
    "komposisi_bahan": ["Dada Ayam", "Nasi Putih", "Buncis", "Wortel"],
    "potensi_alergen": ["Kedelai"],
    "estimasi_biaya_per_porsi": 15000
  }
}
```

#### 2.4 Perbarui Data Master Menu
* **Endpoint:** `PATCH /api/v1/menu/:idMenu`
* **Hak Akses:** `[AUTH: SPPG_ADMIN]`
* **Request Body:**
```json
{
  "nama_menu": "Nasi Ayam Bakar Madu & Tumis Buncis",
  "estimasi_biaya_per_porsi": 16000
}
```
* **Respon Berhasil (200 OK):**
```json
{
  "sukses": true,
  "kode_status": 200,
  "pesan": "Master menu berhasil diperbarui.",
  "data": {
    "id_menu": "mnu_441209cc",
    "nama_menu": "Nasi Ayam Bakar Madu & Tumis Buncis"
  }
}
```

#### 2.5 Plotting Jadwal Menu Harian
* **Endpoint:** `POST /api/v1/jadwal`
* **Hak Akses:** `[AUTH: SPPG_ADMIN]`
* **Request Body:**
```json
{
  "id_menu": "mnu_441209cc",
  "daftar_id_sekolah": ["sch_78192a8c"],
  "tanggal_jadwal": "2026-08-08",
  "target_total_porsi": 450
}
```
* **Respon Berhasil (201 Created):**
```json
{
  "sukses": true,
  "kode_status": 201,
  "pesan": "Jadwal menu MBG berhasil dipublikasikan.",
  "data": {
    "id_jadwal": "schd_10928374",
    "tanggal_jadwal": "2026-08-08"
  }
}
```

#### 2.6 Ambil Menu Hari Ini
* **Endpoint:** `GET /api/v1/jadwal/hari-ini`
* **Hak Akses:** `[AUTH: SEMUA]`
* **Query Parameters:** `?idSekolah=sch_78192a8c`
* **Respon Berhasil (200 OK):**
```json
{
  "sukses": true,
  "kode_status": 200,
  "pesan": "Menu hari ini berhasil diambil.",
  "data": {
    "id_jadwal": "schd_10928374",
    "tanggal_jadwal": "2026-08-07",
    "menu": {
      "id_menu": "mnu_441209cc",
      "nama_menu": "Nasi Ayam Bakar Kecap & Tumis Buncis",
      "kalori_kkal": 550
    },
    "status_evaluasi_pengguna": {
      "sudah_evaluasi": false
    }
  }
}
```

#### 2.7 Ambil Rencana Menu Besok (H+1)
* **Endpoint:** `GET /api/v1/jadwal/besok`
* **Hak Akses:** `[AUTH: SEMUA]`
* **Query Parameters:** `?idSekolah=sch_78192a8c`
* **Respon Berhasil (200 OK):**
```json
{
  "sukses": true,
  "kode_status": 200,
  "pesan": "Rencana menu besok berhasil diambil.",
  "data": {
    "id_jadwal": "schd_10928375",
    "tanggal_jadwal": "2026-08-08",
    "menu": {
      "id_menu": "mnu_551902aa",
      "nama_menu": "Nasi Semur Daging Sapi & Sup Sayur",
      "kalori_kkal": 580
    },
    "status_konfirmasi_pengguna": {
      "sudah_konfirmasi": true,
      "status_kehadiran": "HADIR"
    }
  }
}
```

---

### 🟡 Modul 3: Umpan Balik & Konfirmasi Presensi

#### 3.1 Kirim Evaluasi Menu (Siswa)
* **Endpoint:** `POST /api/v1/jadwal/:idJadwal/evaluasi`
* **Hak Akses:** `[AUTH: PENERIMA_MANFAAT]`
* **Request Body:**
```json
{
  "menerima_porsi": true,
  "penilaian_rasa": 5,
  "penilaian_kesukaan": 4,
  "penilaian_porsi": 4,
  "persentase_sisa_makanan": 10.0,
  "masukan_kualitatif": "Daging ayamnya empuk."
}
```
* **Respon Berhasil (201 Created):**
```json
{
  "sukses": true,
  "kode_status": 201,
  "pesan": "Umpan balik evaluasi menu berhasil disimpan.",
  "data": {
    "id_evaluasi": "eval_88712390"
  }
}
```

#### 3.2 Kirim Evaluasi Kolektif (Petugas Sekolah)
* **Endpoint:** `POST /api/v1/jadwal/:idJadwal/evaluasi-kolektif`
* **Hak Akses:** `[AUTH: PETUGAS_SEKOLAH]`
* **Request Body:**
```json
{
  "id_sekolah": "sch_78192a8c",
  "tingkat_kelas": "5-A",
  "daftar_evaluasi": [
    {
      "nisn_siswa": "3171012345670002",
      "menerima_porsi": true,
      "penilaian_rasa": 4,
      "penilaian_kesukaan": 4,
      "penilaian_porsi": 3,
      "persentase_sisa_makanan": 25.0
    }
  ]
}
```
* **Respon Berhasil (201 Created):**
```json
{
  "sukses": true,
  "kode_status": 201,
  "pesan": "Evaluasi kolektif berhasil direkam.",
  "data": {
    "jumlah_data_berhasil": 1
  }
}
```

#### 3.3 Konfirmasi Kesediaan Menu H+1
* **Endpoint:** `POST /api/v1/jadwal/:idJadwal/konfirmasi`
* **Hak Akses:** `[AUTH: PENERIMA_MANFAAT]`
* **Request Body:**
```json
{
  "status_kehadiran": "MENOLAK",
  "kode_alasan_penolakan": "ALERGI",
  "catatan_khusus": "Alergi udang"
}
```
* **Respon Berhasil (200 OK):**
```json
{
  "sukses": true,
  "kode_status": 200,
  "pesan": "Konfirmasi kehadiran H+1 berhasil dicatat.",
  "data": {
    "id_konfirmasi": "conf_33190284",
    "status_kehadiran": "MENOLAK"
  }
}
```

#### 3.4 Ambil Opsi Alasan Penolakan Baku
* **Endpoint:** `GET /api/v1/alasan-penolakan`
* **Hak Akses:** `[AUTH: SEMUA]`
* **Respon Berhasil (200 OK):**
```json
{
  "sukses": true,
  "kode_status": 200,
  "pesan": "Daftar alasan penolakan berhasil diambil.",
  "data": [
    { "kode": "ALERGI", "label": "Alergi Makanan / Pantangan Medis" },
    { "kode": "SAKIT", "label": "Sakit / Tidak Masuk Sekolah" },
    { "kode": "PANTANGAN_AGAMA", "label": "Pantangan Kepercayaan / Agama" },
    { "kode": "IZIN_ABSEN", "label": "Izin / Kegiatan Luar Sekolah" }
  ]
}
```

---

### 🟣 Modul 4 & 5: Perencanaan Produksi & Tracking Logistik

#### 4.1 Rekapitulasi Presisi Porsi Produksi H+1
* **Endpoint:** `GET /api/v1/rencana-produksi/harian`
* **Hak Akses:** `[AUTH: SPPG_ADMIN]`
* **Query Parameters:** `?tanggal=2026-08-08`
* **Respon Berhasil (200 OK):**
```json
{
  "sukses": true,
  "kode_status": 200,
  "pesan": "Rekapitulasi presisi porsi H+1 berhasil diambil.",
  "data": {
    "tanggal_target": "2026-08-08",
    "total_porsi_dasar": 500,
    "total_siswa_konfirmasi_hadir": 450,
    "total_siswa_menolak": 50,
    "total_porsi_presisi_wajib_dimasak": 450
  }
}
```

#### 4.2 Hitung Ulang Estimasi Produksi
* **Endpoint:** `POST /api/v1/rencana-produksi/harian/hitung`
* **Hak Akses:** `[AUTH: SPPG_ADMIN]`
* **Request Body:**
```json
{
  "tanggal_target": "2026-08-08"
}
```
* **Respon Berhasil (200 OK):**
```json
{
  "sukses": true,
  "kode_status": 200,
  "pesan": "Hitung ulang estimasi produksi berhasil diproses.",
  "data": {
    "porsi_presisi_terbaru": 448
  }
}
```

#### 5.1 Ambil Daftar Siklus Produksi Aktif Hari Ini
* **Endpoint:** `GET /api/v1/produksi/aktif`
* **Hak Akses:** `[AUTH: SPPG_ADMIN]`
* **Respon Berhasil (200 OK):**
```json
{
  "sukses": true,
  "kode_status": 200,
  "pesan": "Siklus produksi aktif berhasil diambil.",
  "data": [
    {
      "id_produksi": "prod_771029",
      "nama_menu": "Nasi Ayam Bakar Kecap",
      "status_produksi": "PERSIAPAN",
      "total_porsi_dimasak": 450
    }
  ]
}
```

#### 5.2 Update Status Memasak Produksi
* **Endpoint:** `PATCH /api/v1/produksi/:idProduksi/status`
* **Hak Akses:** `[AUTH: SPPG_ADMIN]`
* **Request Body:**
```json
{
  "status_produksi": "MEMASAK"
}
```
* **Respon Berhasil (200 OK):**
```json
{
  "sukses": true,
  "kode_status": 200,
  "pesan": "Status produksi berhasil diperbarui.",
  "data": {
    "id_produksi": "prod_771029",
    "status_produksi": "MEMASAK"
  }
}
```

#### 5.3 Update Status Pengiriman Armada Distribusi
* **Endpoint:** `PATCH /api/v1/distribusi/:idDistribusi/status`
* **Hak Akses:** `[AUTH: SPPG_ADMIN, PETUGAS_SEKOLAH]`
* **Request Body:**
```json
{
  "status_distribusi": "TIBA_DI_SEKOLAH",
  "waktu_tiba": "2026-08-07T11:15:00Z"
}
```
* **Respon Berhasil (200 OK):**
```json
{
  "sukses": true,
  "kode_status": 200,
  "pesan": "Status pengiriman berhasil diperbarui.",
  "data": {
    "id_distribusi": "dist_990182",
    "status_distribusi": "TIBA_DI_SEKOLAH"
  }
}
```

---

### 🔴 Modul 6: Sistem Pendukung Keputusan (SPK TOPSIS Engine)

#### 6.1 Eksekusi Perhitungan SPK TOPSIS
* **Endpoint:** `POST /api/v1/spk/topsis/eksekusi`
* **Hak Akses:** `[AUTH: SPPG_ADMIN]`
* **Request Body:**
```json
{
  "tanggal_mulai": "2026-08-01",
  "tanggal_selesai": "2026-08-07",
  "daftar_id_menu": ["mnu_441209cc", "mnu_551902aa"]
}
```
* **Respon Berhasil (200 OK):**
```json
{
  "sukses": true,
  "kode_status": 200,
  "pesan": "Kalkulasi SPK TOPSIS selesai dieksekusi.",
  "data": {
    "id_eksekusi": "topsis_exec_990182",
    "peringkat_menu": [
      {
        "peringkat": 1,
        "nama_menu": "Nasi Ayam Bakar Kecap",
        "skor_preferensi_v": 0.8425,
        "rekomendasi": "DIPERTAHANKAN"
      }
    ]
  }
}
```

#### 6.2 Ambil Detail Matriks Perhitungan TOPSIS
* **Endpoint:** `GET /api/v1/spk/topsis/eksekusi/:idEksekusi`
* **Hak Akses:** `[AUTH: SPPG_ADMIN]`
* **Respon Berhasil (200 OK):**
```json
{
  "sukses": true,
  "kode_status": 200,
  "pesan": "Rincian matriks TOPSIS berhasil diambil.",
  "data": {
    "id_eksekusi": "topsis_exec_990182",
    "solusi_ideal_positif_A_plus": [0.142, 0.105, 0.071, 0.045, 0.032],
    "solusi_ideal_negatif_A_minus": [0.080, 0.050, 0.030, 0.150, 0.120]
  }
}
```

#### 6.3 Ambil Daftar Rekomendasi Kebijakan Menu Otomatis
* **Endpoint:** `GET /api/v1/spk/topsis/rekomendasi`
* **Hak Akses:** `[AUTH: SPPG_ADMIN]`
* **Respon Berhasil (200 OK):**
```json
{
  "sukses": true,
  "kode_status": 200,
  "pesan": "Daftar rekomendasi menu berhasil diambil.",
  "data": {
    "menu_dipertahankan": [{ "nama_menu": "Nasi Ayam Bakar Kecap", "skor": 0.8425 }],
    "menu_dievaluasi": [{ "nama_menu": "Nasi Semur Daging Sapi", "skor": 0.5120 }],
    "menu_diganti": [{ "nama_menu": "Nasi Ikan Kembung Goreng", "skor": 0.2840 }]
  }
}
```

---

### 🟣 Modul 7: Analitik Dasbor & Pelaporan Audit

#### 7.1 Ambil Metrik Ringkasan Dasbor
* **Endpoint:** `GET /api/v1/analitik/ringkasan-dasbor`
* **Hak Akses:** `[AUTH: SPPG_ADMIN]`
* **Query Parameters:** `?tanggalMulai=2026-08-01&tanggalSelesai=2026-08-07`
* **Respon Berhasil (200 OK):**
```json
{
  "sukses": true,
  "kode_status": 200,
  "pesan": "Metrik ringkasan analitik berhasil diambil.",
  "data": {
    "skor_kepuasan_keseluruhan": 4.52,
    "persentase_tingkat_penerimaan_menu": 91.4,
    "food_waste_tercegah_kg": 142.5,
    "estimasi_efisiensi_anggaran_rupiah": 2137500
  }
}
```

#### 7.2 Unduh Laporan Laporan Evaluasi & Audit Program (PDF / Excel)
* **Endpoint:** `GET /api/v1/laporan/unduh`
* **Hak Akses:** `[AUTH: SPPG_ADMIN]`
* **Query Parameters:** `?format=pdf&tanggalMulai=2026-08-01&tanggalSelesai=2026-08-07`
* **Respon Berhasil (200 OK - Binary File Stream):**
* *(Mengembalikan berkas `Content-Type: application/pdf` atau `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet`)*

---

### 🟢 Modul 2.B: Manajemen Master Bahan Makanan Sehat (CRUD Master Bahan)

#### 2.7 Tambah Master Bahan Makanan Sehat Baru
* **Endpoint:** `POST /api/v1/bahan`
* **Hak Akses:** `[AUTH: SPPG_ADMIN]`
* **Request Body:**
```json
{
  "nama_bahan": "Dada Ayam Bakar Kecap",
  "kategori_bahan": "PROTEIN_HEWANI",
  "subjudul_nutrisi": "Sumber Utama Protein & Zat Besi",
  "takaran_default": "80 gram",
  "kalori_per_100g": 165,
  "potensi_alergen": []
}
```
* **Respon Berhasil (201 Created):**
```json
{
  "sukses": true,
  "kode_status": 201,
  "pesan": "Master bahan makanan sehat berhasil ditambahkan.",
  "data": {
    "id_bahan": "bhn_10293847",
    "nama_bahan": "Dada Ayam Bakar Kecap"
  }
}
```

#### 2.8 Ambil Daftar Master Bahan Makanan Sehat (Katalog & Pencarian)
* **Endpoint:** `GET /api/v1/bahan`
* **Hak Akses:** `[AUTH: SEMUA]`
* **Query Parameters:** `?halaman=1&batas=10&kategori=PROTEIN_HEWANI&cari=Ayam`
* **Respon Berhasil (200 OK):**
```json
{
  "sukses": true,
  "kode_status": 200,
  "pesan": "Daftar master bahan makanan sehat berhasil diambil.",
  "data": [
    {
      "id_bahan": "bhn_10293847",
      "nama_bahan": "Dada Ayam Bakar Kecap",
      "kategori_bahan": "PROTEIN_HEWANI",
      "subjudul_nutrisi": "Sumber Utama Protein & Zat Besi",
      "takaran_default": "80 gram",
      "kalori_per_100g": 165
    }
  ],
  "meta": {
    "halaman": 1,
    "batas": 10,
    "total_item": 12,
    "total_halaman": 2
  }
}
```

#### 2.9 Ambil Detail Master Bahan Makanan Sehat
* **Endpoint:** `GET /api/v1/bahan/:idBahan`
* **Hak Akses:** `[AUTH: SEMUA]`
* **Respon Berhasil (200 OK):**
```json
{
  "sukses": true,
  "kode_status": 200,
  "pesan": "Detail master bahan makanan sehat berhasil diambil.",
  "data": {
    "id_bahan": "bhn_10293847",
    "nama_bahan": "Dada Ayam Bakar Kecap",
    "kategori_bahan": "PROTEIN_HEWANI",
    "subjudul_nutrisi": "Sumber Utama Protein & Zat Besi",
    "takaran_default": "80 gram",
    "kalori_per_100g": 165,
    "potensi_alergen": []
  }
}
```

#### 2.10 Perbarui Data Master Bahan Makanan Sehat
* **Endpoint:** `PATCH /api/v1/bahan/:idBahan`
* **Hak Akses:** `[AUTH: SPPG_ADMIN]`
* **Request Body:**
```json
{
  "subjudul_nutrisi": "Sumber Tinggi Protein Organik & Zat Besi",
  "takaran_default": "85 gram"
}
```
* **Respon Berhasil (200 OK):**
```json
{
  "sukses": true,
  "kode_status": 200,
  "pesan": "Master bahan makanan sehat berhasil diperbarui.",
  "data": {
    "id_bahan": "bhn_10293847",
    "nama_bahan": "Dada Ayam Bakar Kecap"
  }
}
```

#### 2.11 Hapus Master Bahan Makanan Sehat
* **Endpoint:** `DELETE /api/v1/bahan/:idBahan`
* **Hak Akses:** `[AUTH: SPPG_ADMIN]`
* **Respon Berhasil (200 OK):**
```json
{
  "sukses": true,
  "kode_status": 200,
  "pesan": "Master bahan makanan sehat berhasil dihapus."
}
```

---
*Akhir dari Dokumen Kontrak Spesifikasi API Eksklusif (v3.1.0 — 31 Endpoints)*
