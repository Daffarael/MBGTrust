# Product Requirement Document (PRD) & Technical Roadmap
## MBGTrust — Backend Systems & Decision Support Engine

**Nama Proyek:** MBGTrust (Sistem Pendukung Keputusan Evaluasi Menu MBG & Estimasi Produksi)  
**Target Kompetisi:** GEMASTIK — Bidang Pengembangan Perangkat Lunak  
**Penulis / Arsitek Utama:** Backend Engineering Lead (Daffarael Anaqi Ali)  
**Lingkup Peran:** Arsitektur Server Express.js, Skema Prisma ORM & MySQL 8.0, SPK Engine TOPSIS, Kontrak RESTful API, & Integrasi Flutter  
**Stack Teknologi Resmi (Fixed):**  
* 📱 **Frontend Client:** Flutter 3.19 (Dart 3.3) — State Management: Provider — *Fuadi Dhiyaulhaq*  
* ⚙️ **Backend Server:** Node.js v20 LTS + Express.js v4.19 — *Daffarael Anaqi Ali*  
* 🗄️ **Database Engine:** MySQL 8.0 + **Prisma ORM v5.14**  
* 🔐 **Keamanan & Logger:** JWT, Bcrypt (12 rounds), Zod Validation, Winston Enterprise Logger, RESTful API (100% Bahasa Indonesia)  
**Versi Dokumen:** 5.0.0 (Perfect 27-Feature Mapping Edition)  
**Status:** Ditetapkan & Mengikat  

---

## 1. Ringkasan Eksekutif & Sasaran Sistem

**MBGTrust** didesain sebagai platform *Decision Support System* (DSS) berbasis *data-driven* untuk **Satuan Pelayanan Pemenuhan Gizi (SPPG)**. Platform ini bertujuan mengatasi dua masalah krusial pada Program Makan Bergizi Gratis (MBG):
1. **Evaluasi Subjektivitas & Kualitas Menu:** Mengolah umpan balik penerima manfaat (rasa, kesukaan, porsi, alasan penolakan) menjadi skor preferensi objektif menggunakan metode **TOPSIS**.
2. **Pengurangan Food Waste & Pemborosan Anggaran:** Memprediksi kebutuhan porsi produksi makanan secara presisi untuk H+1 berdasarkan data konfirmasi kehadiran dan pantangan/alergi penerima manfaat.

---

## 2. Tabel Pemetaan 1-ke-1 (27 Fitur Google Sheet vs 7 Modul API)

Berikut adalah pembuktian bahwa **seluruh 27 Fitur Fungsional** dari Google Sheets telah terpetakan 100% sempurna ke dalam 7 Modul Backend API:

| No | Fitur Fungsional (Google Sheets) | Modul Backend | HTTP Method & Endpoint API | Hak Akses (RBAC) |
| :--- | :--- | :--- | :--- | :--- |
| **1** | Registrasi akun penerima manfaat | Modul 1: Otentikasi & Akun | `POST /api/v1/otentikasi/pendaftaran` | `[PUBLIC]` |
| **2** | Login penerima manfaat | Modul 1: Otentikasi & Akun | `POST /api/v1/otentikasi/masuk` | `[PUBLIC]` |
| **3** | Pengelolaan profil akun penerima manfaat | Modul 1: Otentikasi & Akun | `GET & PATCH /api/v1/pengguna/profil-saya` | `[AUTH: PENERIMA_MANFAAT]` |
| **4** | Login khusus Admin SPPG | Modul 1: Otentikasi & Akun | `POST /api/v1/otentikasi/sppg/masuk` | `[PUBLIC]` |
| **5** | Pengelolaan profil akun Admin SPPG | Modul 1: Otentikasi & Akun | `GET & PATCH /api/v1/pengguna/profil-saya` | `[AUTH: SPPG_ADMIN]` |
| **6** | Pengelolaan data master menu MBG | Modul 2: Menu & Jadwal | `POST, GET, PATCH /api/v1/menu` | `[AUTH: SPPG_ADMIN]` |
| **7** | Menyusun jadwal menu harian SPPG | Modul 2: Menu & Jadwal | `POST /api/v1/jadwal` | `[AUTH: SPPG_ADMIN]` |
| **8** | Melihat menu MBG hari ini | Modul 2: Menu & Jadwal | `GET /api/v1/jadwal/hari-ini` | `[AUTH: SEMUA]` |
| **9** | Melihat rencana menu hari berikutnya (H+1) | Modul 2: Menu & Jadwal | `GET /api/v1/jadwal/besok` | `[AUTH: SEMUA]` |
| **10** | Konfirmasi penerimaan makanan MBG | Modul 3: Evaluasi & Konfirmasi | `POST /api/v1/jadwal/:idJadwal/evaluasi` (`menerima_porsi`) | `[AUTH: PENERIMA_MANFAAT]` |
| **11** | Penilaian rasa, kesukaan, & porsi menu | Modul 3: Evaluasi & Konfirmasi | `POST /api/v1/jadwal/:idJadwal/evaluasi` (`penilaian_rasa, kesukaan, porsi`) | `[AUTH: PENERIMA_MANFAAT]` |
| **12** | Memberikan komentar atau saran menu | Modul 3: Evaluasi & Konfirmasi | `POST /api/v1/jadwal/:idJadwal/evaluasi` (`masukan_kualitatif`) | `[AUTH: PENERIMA_MANFAAT]` |
| **13** | Konfirmasi kesediaan menu besok H+1 | Modul 3: Evaluasi & Konfirmasi | `POST /api/v1/jadwal/:idJadwal/konfirmasi` (`status: "HADIR"`) | `[AUTH: PENERIMA_MANFAAT]` |
| **14** | Memilih alasan penolakan menu H+1 | Modul 3: Evaluasi & Konfirmasi | `POST /api/v1/jadwal/:idJadwal/konfirmasi` & `GET /alasan-penolakan` | `[AUTH: PENERIMA_MANFAAT]` |
| **15** | Rekap data konfirmasi penerima manfaat | Modul 4: Perencanaan Produksi | `GET /api/v1/rencana-produksi/harian` | `[AUTH: SPPG_ADMIN]` |
| **16** | Hitung estimasi kebutuhan jumlah porsi | Modul 4: Perencanaan Produksi | `POST /api/v1/rencana-produksi/harian/hitung` | `[AUTH: SPPG_ADMIN]` |
| **17** | SPPG melihat hasil estimasi produksi | Modul 4: Perencanaan Produksi | `GET /api/v1/rencana-produksi/harian` | `[AUTH: SPPG_ADMIN]` |
| **18** | Pengelolaan status proses produksi memasak | Modul 5: Produksi & Distribusi | `GET /api/v1/produksi/aktif` & `PATCH /produksi/:id/status` | `[AUTH: SPPG_ADMIN]` |
| **19** | Pengelolaan status distribusi makanan | Modul 5: Produksi & Distribusi | `PATCH /api/v1/distribusi/:idDistribusi/status` | `[AUTH: SPPG_ADMIN, PETUGAS]` |
| **20** | Olah data evaluasi via SPK TOPSIS | Modul 6: Engine SPK TOPSIS | `POST /api/v1/spk/topsis/eksekusi` | `[AUTH: SPPG_ADMIN]` |
| **21** | Hasil rekomendasi perbaikan menu MBG | Modul 6: Engine SPK TOPSIS | `GET /api/v1/spk/topsis/rekomendasi` | `[AUTH: SPPG_ADMIN]` |
| **22** | SPPG melihat rekomendasi menu hasil SPK | Modul 6: Engine SPK TOPSIS | `GET /api/v1/spk/topsis/eksekusi/:idEksekusi` | `[AUTH: SPPG_ADMIN]` |
| **23** | SPPG lihat dashboard kepuasan penerima | Modul 7: Dasbor & Pelaporan | `GET /api/v1/analitik/ringkasan-dasbor` | `[AUTH: SPPG_ADMIN]` |
| **24** | SPPG lihat dashboard tingkat penerimaan | Modul 7: Dasbor & Pelaporan | `GET /api/v1/analitik/ringkasan-dasbor` | `[AUTH: SPPG_ADMIN]` |
| **25** | SPPG lihat dashboard efisiensi produksi | Modul 7: Dasbor & Pelaporan | `GET /api/v1/analitik/ringkasan-dasbor` | `[AUTH: SPPG_ADMIN]` |
| **26** | SPPG lihat dashboard efisiensi anggaran | Modul 7: Dasbor & Pelaporan | `GET /api/v1/analitik/ringkasan-dasbor` | `[AUTH: SPPG_ADMIN]` |
| **27** | SPPG mengunduh laporan evaluasi MBG | Modul 7: Dasbor & Pelaporan | `GET /api/v1/laporan/unduh` | `[AUTH: SPPG_ADMIN]` |

---

## 3. Arsitektur Server & Struktur Monorepo

### 3.1 Stack Teknologi Utama
* **Frontend Client Framework:** Flutter 3.19 (Dart 3.3) — State Management: Provider v6.1 — Client API: Dio v5.4.
* **Backend Server Framework:** Node.js v20 LTS dengan Express.js v4.19 (Modular Monolith / Layered Architecture).
* **Database Engine & ORM:** MySQL 8.0 Engine + **Prisma ORM v5.14** (Data Modeling, Migrasi DDL, & Type-Safe Queries).
* **Otentikasi & Otorisasi:** JSON Web Token (JWT Access & Refresh Token) dengan Role-Based Access Control (RBAC).
* **Validasi & Keamanan:** Zod Schema Validation v3.23, Helmet, CORS, Bcrypt Hashing (12 rounds), Express Rate-Limit.
* **Logging & Monitoring:** Winston Enterprise Logger (Structured JSON Logs) + Morgan.
* **Arsitektur API:** RESTful JSON Standard (100% Bahasa Indonesia, Edit menggunakan HTTP `PATCH`).

### 3.2 Aturan Gaya Koding & Kebijakan Komentar Minimalis (Clean Code Policy)
Untuk menjaga agar repositori kode backend tetap bersih, profesional, dan mudah dibaca:
1. **Self-Documenting Code**: Nama variabel, fungsi, dan kelas WAJIB bersifat eksplisit dan deskriptif (contoh: `hitungSkorPreferensiTopsis()`, `verifikasiTokenAkses()`) sehingga fungsi kode dapat dipahami langsung tanpa komentar.
2. **Dilarang Komentar Berlebihan (No Noise Comments)**: Dilarang keras menulis komentar redundan yang hanya mengulang fungsi kode (contoh buruk: `// Ambil user dari database` tepat di atas query Prisma).
3. **Komentar Hanya untuk Logika Kompleks (*Why, Not What*)**: Komentar HANYA diperbolehkan untuk menjelaskan tahapan matematika rumit (seperti rumus TOPSIS $r_{ij}, v_{ij}, A^+/A^-$) atau latar belakang keputusan teknis khusus.

### 3.3 Struktur Arsitektur Monorepo Tunggal (Root Repository MBGTrust)
```text
MBGTrust/                           # Root Repositori Git Utama (https://github.com/accfd/MBGTrust.git)
├── .github/                        # Workflows CI/CD & Template Pull Request
├── docs/                           # Dokumentasi Spesifikasi Teknis (PRD & Kontrak API)
│   ├── backend_prd_and_roadmap.md
│   ├── api_specification_contract.md
│   └── spesifikasi_teknologi_mbgtrust.md
├── mbgtrust-backend/               # ⚙️ Node.js + Express.js + Prisma ORM + MySQL Server Core
│   ├── src/
│   │   ├── config/                 # Konfigurasi Database Prisma & JWT
│   │   ├── common/                 # Winston Logger, Error Handler, & Standard Respon
│   │   ├── middlewares/            # Auth & RBAC Guards
│   │   └── modules/                # 7 Modul Domain Utama (Modular Monolith)
│   │       ├── otentikasi/
│   │       ├── menu/
│   │       ├── evaluasi/
│   │       ├── produksi/
│   │       ├── spk-topsis/
│   │       └── analitik/
│   ├── prisma/                     # Skema Prisma (schema.prisma) & Migrasi DDL SQL
│   ├── database/                   # Seeders MySQL (Demo Gemastik)
│   ├── .env.example
│   └── package.json
├── mbgtrust-frontend/              # 📱 Flutter Application Client (Mobile & Web)
│   ├── lib/                        # Kode Utama Flutter (Dart)
│   │   ├── core/
│   │   ├── features/
│   │   └── main.dart
│   ├── android/
│   ├── ios/
│   ├── web/
│   └── pubspec.yaml
├── .gitignore                      # Gitignore Gabungan Root (Node & Flutter)
└── README.md                       # Panduan Instalasi Proyek & Dokumentasi Utama
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
         │                └─────────────────┘                │
         │                                                   │
         │                ┌─────────────────┐                │
         └───────────────>│   konfirmasi    │<───────────────┘
                          └─────────────────┘
                                     │
                          ┌──────────▼──────────┐
                          │  rencana_produksi   │
                          └──────────┬──────────┘
                                     │
                          ┌──────────▼──────────┐
                          │   eksekusi_topsis   │
                          └─────────────────────┘
```

---

## 5. Algoritma SPK TOPSIS Engine Specifications

Sebagai penyedia logika SPK di backend, algoritma TOPSIS diimplementasikan secara murni (*pure function*) pada Service Layer.

### Kriteria & Pembobotan (Weight Vector)
* Total Akumulasi Bobot: `Σ w_j = 1.0 (100%)`

| Kode | Nama Kriteria | Sifat (*Attribute*) | Bobot (w_j) | Sumber Data |
| :--- | :--- | :--- | :--- | :--- |
| **C1** | Penilaian Rasa | **Benefit** (Makin tinggi makin baik) | 0.20 (20%) | Rata-rata rating rasa dari penerima manfaat (1-5) |
| **C2** | Tingkat Kesukaan | **Benefit** (Makin tinggi makin baik) | 0.15 (15%) | Rata-rata rating kesukaan umum (1-5) |
| **C3** | Kesesuaian Porsi | **Benefit** (Makin tinggi makin baik) | 0.10 (10%) | Rata-rata kesesuaian porsi (1-5) |
| **C4** | Potensi Food Waste | **Cost** (Makin tinggi makin buruk) | 0.30 (30%) | Persentase makanan tersisa/dibuang (%) |
| **C5** | Tingkat Penolakan | **Cost** (Makin tinggi makin buruk) | 0.25 (25%) | Persentase siswa menolak menu H+1 (%) |

---

## 6. Rincian Langkah Atomik Eksekusi Backend (9 Tahap Mikro)

### 🧩 TAHAP 1: Fondasi Proyek & Setup Prisma ORM Server
* [ ] **Tugas 1.1**: Setup Repositori, Packages (`express`, `@prisma/client`, `mysql2`, `zod`, `jwt`, `winston`), `.env`, `.gitignore`.
* [ ] **Tugas 1.2**: Buat struktur folder `src/`, entry point `server.js` & `app.js`.
* [ ] **Tugas 1.3**: Prisma init, skema `schema.prisma` 8 tabel, & `npx prisma migrate dev`.
* [ ] **Tugas 1.4**: Global Response Formatter, Winston Logger, Error Handler, & `/health`.

### 🧩 TAHAP 2: Modul 1 — Otentikasi & Manajemen Pengguna (IAM)
* [ ] **Tugas 2.1**: Zod schemas pendaftaran siswa & login.
* [ ] **Tugas 2.2**: Util Bcrypt Hashing & JWT Token (Akses & Penyegar).
* [ ] **Tugas 2.3**: Layer Repository (Prisma), Service, Controller, & Rute Otentikasi (`POST /pendaftaran`, `POST /masuk`, `POST /sppg/masuk`, `POST /perbarui-token`).
* [ ] **Tugas 2.4**: Middleware Auth & RBAC Guards + Profil (`GET & PATCH /pengguna/profil-saya`).

### 🧩 TAHAP 3: Modul 2 — Manajemen Master Menu & Penjadwalan Harian
* [ ] **Tugas 3.1**: CRUD Master Menu MBG (`POST, GET, PATCH /menu`).
* [ ] **Tugas 3.2**: Penjadwalan menu harian per sekolah (`POST /jadwal`, `GET /jadwal/hari-ini`, `GET /jadwal/besok`).

### 🧩 TAHAP 4: Modul 3 — Engine Umpan Balik & Konfirmasi Presensi H+1
* [ ] **Tugas 4.1**: Evaluasi Mandiri Siswa (`POST /jadwal/:idJadwal/evaluasi`) + Prisma Unique Constraint.
* [ ] **Tugas 4.2**: Evaluasi Kolektif Petugas Sekolah (`POST /jadwal/:idJadwal/evaluasi-kolektif`) transaction batch.
* [ ] **Tugas 4.3**: Daftar alasan penolakan & Konfirmasi presensi H+1 (`POST /jadwal/:idJadwal/konfirmasi`).

### 🧩 TAHAP 5: Modul 4 & 5 — Logic Engine Perencanaan Produksi & Tracking Logistik
* [ ] **Tugas 5.1**: Agregasi Prisma & kalkulator presisi porsi H+1 (`GET & POST /rencana-produksi/harian`).
* [ ] **Tugas 5.2**: Endpoints tracking workflow memasak (`PATCH /produksi/:id/status`) & armada pengiriman (`PATCH /distribusi/:id/status`).

### 🧩 TAHAP 6: Modul 6 — Engine SPK TOPSIS Murni (Mathematical Service)
* [ ] **Tugas 6.1**: Implementasi fungsi murni $r_{ij}$, $v_{ij}$, $A^+/A^-$, $D_i^+/D_i^-$, dan $V_i$.
* [ ] **Tugas 6.2**: Mapper keputusan otomatis (`DIPERTAHANKAN`, `DIEVALUASI`, `DIGANTI`).
* [ ] **Tugas 6.3**: Endpoints eksekusi & rekomendasi TOPSIS (`POST /eksekusi`, `GET /eksekusi/:id`, `GET /rekomendasi`).

### 🧩 TAHAP 7: Modul 7 — Dasbor Analitik & Generator Laporan Audit
* [ ] **Tugas 7.1**: Prisma aggregate queries dasbor (Food Waste Tercegah & Efisiensi Anggaran).
* [ ] **Tugas 7.2**: Generator dokumen laporan (`pdfkit` & `exceljs` download).

### 🧩 TAHAP 8: Integrasi Kontrak API dengan Fuad & Seeding Data Demo
* [ ] **Tugas 8.1**: Export Postman Collection v2.1 & dokumentasi JSON ke Fuad.
* [ ] **Tugas 8.2**: Skrip Seeder demo (3 Sekolah, 150 Siswa, 10 Menu, 30 Hari Data Evaluasi).
* [ ] **Tugas 8.3**: End-to-End Testing integrasi Flutter <-> ExpressJS.

### 🧩 TAHAP 9: Optimasi Performa, Sanitasi Keamanan, & Dokumen Gemastik
* [ ] **Tugas 9.1**: Prisma @@index & Latency benchmark (< 500 ms).
* [ ] **Tugas 9.2**: Rate limiting & audit sanitasi keamanan.
* [ ] **Tugas 9.3**: Penulisan draft Bab f & Bab g untuk Proposal Gemastik.

---

## 7. Panduan Operasional Git & Strategi Kolaborasi Tim

Untuk koordinasi antara Anda (**Backend Lead**) dan Fuad (**Frontend Lead**) di repositori tunggal GitHub `https://github.com/accfd/MBGTrust.git`, ikuti SOP Feature Branching:
* **Anda (Backend)**: Bekerja di dalam folder `mbgtrust-backend/` pada branch `feat/backend-...`.
* **Fuad (Frontend)**: Bekerja di dalam folder `mbgtrust-frontend/` pada branch `feat/frontend-...`.
* **Protokol Tanpa Menunggu**: Fuad menggunakan `api_specification_contract.md` sebagai acuan mock data di Flutter.

---
*Akhir dari Master Blueprint Execution Plan MBGTrust (v5.0.0)*
