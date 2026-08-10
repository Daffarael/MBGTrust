# Product Requirement Document (PRD) & Technical Roadmap
## MBGTrust — Backend Systems & Decision Support Engine

**Nama Proyek:** MBGTrust — Platform Digital Berbasis AI untuk Mitigasi Food Waste pada Program Makan Bergizi Gratis  
**Target Kompetisi:** GEMASTIK — Bidang Pengembangan Perangkat Lunak  
**Penulis / Arsitek Utama:** Backend Engineering Lead (Daffarael Anaqi Ali)  
**Lingkup Peran:** Arsitektur Server Express.js, Skema Prisma ORM & MySQL 8.0, SPK Engine TOPSIS, NLP Integration, Kontrak RESTful API, & Integrasi Flutter  
**Stack Teknologi Resmi (Fixed):**  
* 📱 **Frontend Client:** Flutter 3.19 (Dart 3.3) — State Management: Riverpod — *Fuadi Dhiyaulhaq*  
* ⚙️ **Backend Server:** Node.js v20 LTS + Express.js v4.19 — *Daffarael Anaqi Ali*  
* 🗄️ **Database Engine:** MySQL 8.0 + **Prisma ORM v7.9.1**  
* 🤖 **AI & NLP:** Google Gemini API (Narasi Rekomendasi) + NLP Sentiment Analysis (Ulasan Teks Siswa)  
* 🔐 **Keamanan & Logger:** JWT, Bcrypt (12 rounds), Zod Validation, Winston Enterprise Logger, RESTful API (100% Bahasa Indonesia)  
**Versi Dokumen:** 6.0.0 (Disesuaikan dengan Gagasan Awal — 5 Modul, 27 Fitur, 3 Peran)  
**Status:** Ditetapkan & Mengikat  

---

## 1. Ringkasan Eksekutif & Sasaran Sistem

**MBGTrust** didesain sebagai platform *Decision Support System* (DSS) berbasis *data-driven* untuk **Satuan Pelayanan Pemenuhan Gizi (SPPG)**. Platform ini mengintegrasikan **ML Sentiment Analysis** dan **SPK TOPSIS** untuk menghasilkan rekomendasi komprehensif mengenai penyesuaian porsi dan komposisi menu, sekaligus memitigasi *food waste* pada Program Makan Bergizi Gratis.

Sistem melayani **3 Peran Pengguna**:
- **Super Admin** — manajemen entitas sekolah dan akun
- **Admin SPPG** — operasional program, analitik, dan SPK
- **Penerima Manfaat (Siswa)** — pelaporan harian dan gamifikasi

---

## 2. Tabel Pemetaan 1-ke-1 (27 Fitur Asli vs 8 Modul API)

| No | Fitur Fungsional (Gagasan Awal) | Modul Backend | HTTP Method & Endpoint API | Hak Akses (RBAC) |
| :--- | :--- | :--- | :--- | :--- |
| **1** | Super Admin login | Modul 0: Super Admin | `POST /api/v1/admin/masuk` | `[PUBLIC]` |
| **2** | Super Admin kelola profil | Modul 0: Super Admin | `GET & PATCH /api/v1/admin/profil-saya` | `[AUTH: SUPER_ADMIN]` |
| **3** | Super Admin kelola master sekolah | Modul 0: Super Admin | `POST, GET, PATCH, DELETE /api/v1/admin/sekolah` | `[AUTH: SUPER_ADMIN]` |
| **4** | Super Admin kelola akun Admin SPPG | Modul 0: Super Admin | `POST, GET, PATCH /api/v1/admin/sppg-admin` | `[AUTH: SUPER_ADMIN]` |
| **5** | Super Admin kelola akun Penerima Manfaat | Modul 0: Super Admin | `POST, GET, PATCH /api/v1/admin/penerima-manfaat` | `[AUTH: SUPER_ADMIN]` |
| **6** | Admin SPPG login | Modul 1: Otentikasi & Akun | `POST /api/v1/otentikasi/sppg/masuk` | `[PUBLIC]` |
| **7** | Admin SPPG kelola profil | Modul 1: Otentikasi & Akun | `GET & PATCH /api/v1/pengguna/profil-saya` | `[AUTH: SPPG_ADMIN]` |
| **8** | Penerima Manfaat login dengan kredensial | Modul 1: Otentikasi & Akun | `POST /api/v1/otentikasi/masuk` | `[PUBLIC]` |
| **9** | Penerima Manfaat perbarui profil & kata sandi | Modul 1: Otentikasi & Akun | `PATCH /api/v1/pengguna/profil-saya` | `[AUTH: PENERIMA_MANFAAT]` |
| **10** | Siswa konfirmasi konsumsi MBG harian | Modul 3: Evaluasi & Konfirmasi | `POST /api/v1/jadwal/:idJadwal/konfirmasi` | `[AUTH: PENERIMA_MANFAAT]` |
| **11** | Siswa beri rating & ulasan teks menu | Modul 3: Evaluasi & Konfirmasi | `POST /api/v1/jadwal/:idJadwal/evaluasi` | `[AUTH: PENERIMA_MANFAAT]` |
| **12** | Siswa laporkan volume sisa makanan | Modul 3: Evaluasi & Konfirmasi | `POST /api/v1/jadwal/:idJadwal/evaluasi` (`volume_sisa`) | `[AUTH: PENERIMA_MANFAAT]` |
| **13** | Siswa beri alasan jika tidak konsumsi MBG | Modul 3: Evaluasi & Konfirmasi | `POST /api/v1/jadwal/:idJadwal/konfirmasi` (`alasan_penolakan`) | `[AUTH: PENERIMA_MANFAAT]` |
| **14** | Siswa lihat poin gamifikasi & dampak lingkungan | Modul 1: Otentikasi & Akun | `GET /api/v1/pengguna/profil-saya` (`poin_xp`, `dampak_lingkungan`) | `[AUTH: PENERIMA_MANFAAT]` |
| **15** | Admin SPPG lihat rekap data harian real-time | Modul 7: Dasbor & Pelaporan | `GET /api/v1/analitik/ringkasan-dasbor` | `[AUTH: SPPG_ADMIN]` |
| **16** | Admin SPPG lihat hasil analisis sentimen NLP | Modul 7: Dasbor & Pelaporan | `GET /api/v1/analitik/hasil-nlp` | `[AUTH: SPPG_ADMIN]` |
| **17** | Admin SPPG lihat rekomendasi porsi & komposisi AI | Modul 6: Engine SPK TOPSIS | `GET /api/v1/spk/topsis/rekomendasi` | `[AUTH: SPPG_ADMIN]` |
| **18** | Admin SPPG lihat tren food waste & akurasi prediksi | Modul 7: Dasbor & Pelaporan | `GET /api/v1/analitik/tren-food-waste` | `[AUTH: SPPG_ADMIN]` |
| **19** | Sistem proses ulasan teks via NLP Sentiment Analysis | Modul 6: Engine SPK TOPSIS | (Background job — dipicu otomatis setelah evaluasi masuk) | `[SISTEM]` |
| **20** | Sistem ranking menu otomatis via SPK TOPSIS | Modul 6: Engine SPK TOPSIS | `POST /api/v1/spk/topsis/eksekusi` | `[AUTH: SPPG_ADMIN]` |
| **21** | Admin SPPG kelola master bahan baku | Modul 2: Menu & Jadwal | `POST, GET, PATCH /api/v1/bahan-baku` | `[AUTH: SPPG_ADMIN]` |
| **22** | Admin SPPG kelola master menu | Modul 2: Menu & Jadwal | `POST, GET, PATCH /api/v1/menu` | `[AUTH: SPPG_ADMIN]` |
| **23** | Admin SPPG susun & jadwalkan menu harian | Modul 2: Menu & Jadwal | `POST /api/v1/jadwal`, `GET /api/v1/jadwal/hari-ini` | `[AUTH: SPPG_ADMIN]` |
| **24** | Admin SPPG pantau status produksi & distribusi | Modul 5: Produksi & Distribusi | `GET & PATCH /api/v1/produksi/:id/status`, `PATCH /api/v1/distribusi/:id/status` | `[AUTH: SPPG_ADMIN]` |
| **25** | Siswa lihat daftar menu harian terjadwal | Modul 2: Menu & Jadwal | `GET /api/v1/jadwal/hari-ini`, `GET /api/v1/jadwal/besok` | `[AUTH: SEMUA]` |
| **26** | Siswa lihat detail komposisi bahan menu | Modul 2: Menu & Jadwal | `GET /api/v1/menu/:idMenu/bahan-baku` | `[AUTH: SEMUA]` |
| **27** | Siswa atur preferensi makanan & riwayat alergi | Modul 1: Otentikasi & Akun | `PATCH /api/v1/pengguna/profil-saya` (`riwayat_alergi`) | `[AUTH: PENERIMA_MANFAAT]` |

---

## 3. Arsitektur Server & Struktur Monorepo

### 3.1 Stack Teknologi Utama
* **Frontend Client Framework:** Flutter 3.19 (Dart 3.3) — State Management: Riverpod v2.5 — Client API: Dio v5.4.
* **Backend Server Framework:** Node.js v20 LTS dengan Express.js v4.19 (Modular Monolith / Layered Architecture).
* **Database Engine & ORM:** MySQL 8.0 Engine + **Prisma ORM v7.9.1** (Data Modeling, Migrasi DDL, & Type-Safe Queries).
* **AI & NLP Integration:** Google Gemini API (narasi rekomendasi TOPSIS) + NLP Sentiment Analysis Engine (pemrosesan ulasan teks siswa).
* **Otentikasi & Otorisasi:** JSON Web Token (JWT Access & Refresh Token) dengan Role-Based Access Control (RBAC) 3 peran.
* **Validasi & Keamanan:** Zod Schema Validation v3.23, Helmet, CORS, Bcrypt Hashing (12 rounds), Express Rate-Limit.
* **Logging & Monitoring:** Winston Enterprise Logger (Structured JSON Logs) + Morgan.
* **Arsitektur API:** RESTful JSON Standard (100% Bahasa Indonesia).

### 3.2 Aturan Gaya Koding (Clean Code Policy)
1. **Self-Documenting Code**: Nama variabel, fungsi, dan kelas WAJIB bersifat eksplisit dan deskriptif.
2. **Dilarang Komentar Berlebihan**: Dilarang komentar redundan yang hanya mengulang fungsi kode.
3. **Komentar Hanya untuk Logika Kompleks**: Komentar HANYA untuk tahapan matematika TOPSIS atau logika NLP.

### 3.3 Struktur Direktori Backend
```text
mbgtrust-backend/
├── src/
│   ├── config/         # Konfigurasi Database Prisma & JWT
│   ├── common/         # Winston Logger, Error Handler, Standard Respon
│   ├── middlewares/    # Auth & RBAC Guards (3 peran)
│   └── modules/        # 8 Modul Domain Utama
│       ├── admin/      # Modul 0: Super Admin
│       ├── otentikasi/ # Modul 1: Auth & Akun
│       ├── menu/       # Modul 2: Menu & Jadwal & Bahan Baku
│       ├── evaluasi/   # Modul 3: Evaluasi & Konfirmasi
│       ├── produksi/   # Modul 4: Rencana Produksi
│       ├── distribusi/ # Modul 5: Produksi & Distribusi
│       ├── spk-topsis/ # Modul 6: SPK TOPSIS + NLP Engine
│       └── analitik/   # Modul 7: Dasbor & Pelaporan (termasuk NLP results)
├── prisma/             # Schema Prisma & Migrasi DDL SQL
└── package.json
```

---

## 4. Peta Entitas Basis Data (Core ERD Overview)

```
┌─────────────────┐       ┌─────────────────┐       ┌─────────────────┐
│    pengguna     │───────│     sekolah     │───────│   jadwal_menu   │
└────────┬────────┘       └─────────────────┘       └────────┬────────┘
         │                                                   │
         │                ┌─────────────────┐                │
         ├───────────────>│  evaluasi_menu  │<───────────────┤
         │                └────────┬────────┘                │
         │                         │                         │
         │                ┌────────▼────────┐                │
         │                │  hasil_nlp      │                │
         │                └─────────────────┘                │
         │                                                   │
         │                ┌─────────────────┐                │
         └───────────────>│   konfirmasi    │<───────────────┘
                          └────────┬────────┘
                                   │
                          ┌────────▼────────┐
                          │ rencana_produksi│
                          └────────┬────────┘
                                   │
                          ┌────────▼────────┐
                          │ eksekusi_topsis │
                          └─────────────────┘
```

---

## 5. Algoritma SPK TOPSIS Engine Specifications

### Kriteria & Pembobotan (Weight Vector)
Total Akumulasi Bobot: `Σ w_j = 1.0 (100%)`

> ⚠️ **PENTING:** Seluruh 5 kriteria bersifat **Benefit** — semakin tinggi nilainya semakin baik.

| Kode | Nama Kriteria | Sifat (*Attribute*) | Bobot (w_j) | Sumber Data |
| :--- | :--- | :--- | :--- | :--- |
| **C1** | Rasa | **Benefit** (Makin tinggi makin baik) | 0.20 (20%) | Rata-rata rating rasa dari penerima manfaat (1-5) |
| **C2** | Tingkat Kesukaan | **Benefit** (Makin tinggi makin baik) | 0.15 (15%) | Rata-rata rating kesukaan umum (1-5) |
| **C3** | Kesesuaian Porsi | **Benefit** (Makin tinggi makin baik) | 0.10 (10%) | Rata-rata kesesuaian porsi (1-5) |
| **C4** | Tingkat Konsumsi Makanan | **Benefit** (Makin tinggi makin baik) | 0.30 (30%) | Persentase makanan yang dikonsumsi / tidak tersisa (%) |
| **C5** | Tingkat Penerimaan MBG | **Benefit** (Makin tinggi makin baik) | 0.25 (25%) | Persentase siswa yang menerima dan mengonsumsi MBG (%) |

### NLP Sentiment Analysis Integration
Ulasan teks siswa (dari field `ulasan_teks` di tabel `evaluasi_menu`) diproses oleh mesin NLP untuk:
1. Mengidentifikasi sentimen positif/negatif per ulasan.
2. Mengekstrak kata kunci alasan *food waste* (tekstur, rasa, aroma, dll).
3. Menghasilkan laporan sentimen agregat per menu untuk ditampilkan di dashboard SPPG.

---

## 6. Rincian Langkah Atomik Eksekusi Backend (9 Tahap Mikro)

### TAHAP 0: Modul Super Admin
* [ ] **Tugas 0.1**: Endpoint login Super Admin (`POST /api/v1/admin/masuk`).
* [ ] **Tugas 0.2**: CRUD master sekolah (`POST, GET, PATCH, DELETE /api/v1/admin/sekolah`).
* [ ] **Tugas 0.3**: CRUD master akun Admin SPPG & Penerima Manfaat.

### TAHAP 1: Fondasi Proyek & Setup Prisma ORM Server
* [ ] **Tugas 1.1**: Setup Repositori, Packages, `.env`, `.gitignore`.
* [ ] **Tugas 1.2**: Struktur folder `src/`, entry point `server.js` & `app.js`.
* [ ] **Tugas 1.3**: Prisma schema 12+ tabel (termasuk `bahan_baku`, `hasil_nlp`), `npx prisma migrate dev`.
* [ ] **Tugas 1.4**: Global Response Formatter, Winston Logger, Error Handler, `/health`.

### TAHAP 2: Modul 1 — Otentikasi & Manajemen Pengguna (IAM)
* [ ] **Tugas 2.1**: Zod schemas login 3 peran.
* [ ] **Tugas 2.2**: Util Bcrypt Hashing & JWT Token (Akses & Penyegar).
* [ ] **Tugas 2.3**: Layer Repository (Prisma), Service, Controller, & Rute Otentikasi.
* [ ] **Tugas 2.4**: Middleware Auth & RBAC Guards 3 peran + Profil.

### TAHAP 3: Modul 2 — Manajemen Bahan Baku, Menu & Penjadwalan
* [ ] **Tugas 3.1**: CRUD Master Bahan Baku (`POST, GET, PATCH /api/v1/bahan-baku`).
* [ ] **Tugas 3.2**: CRUD Master Menu dengan referensi bahan baku.
* [ ] **Tugas 3.3**: Penjadwalan menu harian per sekolah.

### TAHAP 4: Modul 3 — Engine Umpan Balik & Konfirmasi
* [ ] **Tugas 4.1**: Evaluasi menu siswa (`POST /jadwal/:id/evaluasi`) + volume sisa makanan.
* [ ] **Tugas 4.2**: Konfirmasi konsumsi & alasan penolakan.

### TAHAP 5: Modul 4 & 5 — Perencanaan Produksi & Logistik
* [ ] **Tugas 5.1**: Kalkulasi estimasi porsi berbasis data konfirmasi.
* [ ] **Tugas 5.2**: Tracking status produksi & distribusi.

### TAHAP 6: Modul 6 — Engine SPK TOPSIS + NLP
* [ ] **Tugas 6.1**: Implementasi fungsi TOPSIS murni (semua 5 kriteria Benefit).
* [ ] **Tugas 6.2**: Integrasi NLP Sentiment Analysis untuk ulasan teks siswa.
* [ ] **Tugas 6.3**: Mapper keputusan otomatis & narasi AI Gemini.
* [ ] **Tugas 6.4**: Endpoints eksekusi & rekomendasi TOPSIS.

### TAHAP 7: Modul 7 — Dasbor Analitik & Generator Laporan
* [ ] **Tugas 7.1**: Prisma aggregate queries dasbor (rekap harian, tren food waste).
* [ ] **Tugas 7.2**: Endpoint hasil analisis NLP per menu.
* [ ] **Tugas 7.3**: Generator dokumen laporan (PDF & Excel).

### TAHAP 8: Integrasi & Seeding Demo
* [ ] **Tugas 8.1**: Export Postman Collection & dokumentasi API.
* [ ] **Tugas 8.2**: Skrip Seeder demo (3 Sekolah, 150 Siswa, 10 Menu, 30 Hari Data).
* [ ] **Tugas 8.3**: End-to-End Testing integrasi Flutter <-> ExpressJS.

### TAHAP 9: Optimasi & Dokumen GEMASTIK
* [ ] **Tugas 9.1**: Prisma @@index & Latency benchmark (< 500 ms).
* [ ] **Tugas 9.2**: Rate limiting & audit keamanan.
* [ ] **Tugas 9.3**: Penulisan draft dokumen teknis GEMASTIK.

---

## 7. Panduan Operasional Git & Strategi Kolaborasi Tim

Untuk koordinasi di repositori tunggal GitHub:
* **Backend Lead**: Bekerja di dalam folder `mbgtrust-backend/` pada branch `feat/backend-...`.
* **Frontend Lead**: Bekerja di dalam folder `mbgtrust-frontend/` pada branch `feat/frontend-...`.
* **Protokol Tanpa Menunggu**: Frontend menggunakan `api_specification_contract.md` sebagai acuan mock data.

---
*Akhir dari Master Blueprint Execution Plan MBGTrust (v6.0.0) — Disesuaikan dengan Gagasan Awal*
