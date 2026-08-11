# DESIGN.md — MBGTrust Mobile Architecture & Design Specification

Dokumen ini merupakan panduan arsitektur, sistem desain, dan spesifikasi fungsional utama untuk aplikasi **MBGTrust Mobile Frontend**, disarikan langsung dari **Dokumen Proposal GEMASTIK XIX Software Development** dan spesifikasi teknis proyek.

---

## 1. Visi & Informasi Proyek

- **Nama Platform**: MBGTrust
- **Judul Resmi**: *Platform Digital Berbasis AI untuk Mitigasi Food Waste pada Program Makan Bergizi Gratis (MBG)*
- **Target Kompetisi**: GEMASTIK XIX 2026 — Divisi VIII Pengembangkan Perangkat Lunak (*Software Development*)
- **Institusi**: Universitas Andalas (Mitra Integrasi SPPG BGN RI)
- **Target Pengguna**: Penerima Manfaat / Siswa Sekolah (*MAN 2 Kota Padang sebagai benchmark*)

---

## 2. Arsitektur Perangkat Lunak & Tech Stack

```
+-------------------------------------------------------------------+
|                     Flutter Mobile App (UI Layer)                 |
|       (Riverpod State Management + GoRouter + Custom Tokens)      |
+-------------------------------------------------------------------+
                                  |
                                  v
+-------------------------------------------------------------------+
|               REST API Services (HTTP / Dio Client)               |
|                 (JWT Bearer Authentication Header)                |
+-------------------------------------------------------------------+
                                  |
                                  v
+-------------------------------------------------------------------+
|            Node.js / Express.js Backend + Prisma ORM              |
|        (SPK TOPSIS Engine + NLP Sentiment + Gemini 2.0 Flash)     |
+-------------------------------------------------------------------+
```

- **Framework**: Flutter Lintas Platform (Android, iOS, Web)
- **Manajemen Status**: Riverpod (`flutter_riverpod`)
- **Navigasi / Routing**: GoRouter (`go_router`)
- **Klien HTTP**: Dio / HTTP Client dengan Header Otorisasi JWT Bearer
- **Penyimpanan Lokal**: Flutter Secure Storage / Shared Preferences
- **Desain UI**: Custom CSS-like Tokens (`AppColors`) & Micro-animations

---

## 3. Sistem Desain & Token Warna (Design System)

### Palet Warna Utama (`AppColors`)

| Token | Nilai Hex | Penggunaan |
| :--- | :--- | :--- |
| `primary` | `#047857` | Hijau Emerald Utama (Tombol, Lencana, Header) |
| `primaryDark` | `#065F46` | Emerald Gelap (Gradien, Teks Judul) |
| `primaryLight` | `#D1FAE5` | Emerald Soft (Latar Belakang Kartu, Sorotan) |
| `secondary` | `#F59E0B` | Amber Emas (Bintang Rating, Trofi) |
| `secondaryDark` | `#D97706` | Amber Gelap (Teks Status Peringkat) |
| `secondaryLight` | `#FEF3C7` | Amber Soft (Lencana Waktu & Peringau) |
| `background` | `#F8FAFC` | Slate Soft (Latar Belakang Layar) |
| `surface` | `#FFFFFF` | Putih Bersih (Kartu & Dialog) |
| `textPrimary` | `#0F172A` | Slate 900 (Teks Utama & Judul) |
| `textSecondary` | `#475569` | Slate 600 (Sub-judul & Keterangan) |
| `textLight` | `#94A3B8` | Slate 400 (Teks Non-aktif & Ikon Neutral) |
| `border` | `#E2E8F0` | Slate 200 (Garis Tepi Kartu & Pembatas) |
| `error` | `#EF4444` | Red 500 (Peringatan & Tombol Keluar) |
| `success` | `#10B981` | Emerald 500 (Status Aktif Terverifikasi) |

### Tipografi & Komponen UI Konsisten

- **Font Family**: Google Fonts (Inter / Outfit)
- **Bottom Navigation Bar (`StudentBottomNavBar`)**:
  - Navigasi melayang (*floating*) dengan margin bawah `16px` & *border radius* `40px`.
  - **Urutan Statis Tetap**: `Peringkat (Index 0)` — `Beranda (Index 1)` — `Profil (Index 2)`.
  - **Prominent Circular Active Badge**: Tombol aktif berbentuk lingkaran menonjol (`BoxShape.circle`) dengan gradien hijau & bayangan meletup.
- **Meal Image Component (`MbgFoodImage`)**:
  - Komponen penampil foto makanan berteknologi *shimmer loading* & visual resep *fallback* hijau emerald untuk menjamin foto tidak pernah kosong/korup.

---

## 4. Pemetaan Modul & Fitur Aplikasi (Proposal Alignment)

### 🔐 Modul 1: Manajemen Pengguna & Otentikasi
- **Login NISN/NIK**: Otentikasi siswa berbasis NISN dan kata sandi terenkripsi.
- **Manajemen Profil Siswa**: Menampilkan data resmi (Nama Lengkap, NIK/NISN, Sekolah, Tingkat Kelas, & Status Akun Terverifikasi).
- **Deteksi Alergi Dini**: Menampilkan riwayat alergen makanan siswa yang otomatis dicocokkan dengan bahan baku menu H+1.

### 📝 Modul 2: Pelaporan dan Evaluasi Closed-Loop
- **Form Evaluasi Cepat (<15 detik)**:
  1. Konfirmasi penerimaan/konsumsi porsi MBG harian.
  2. Penilaian 3 Kriteria: Rasa, Kesukaan, dan Porsi (Skala 1–5 Bintang).
  3. Estimasi Sisa Makanan (*Food Waste*) Slider (0% - 100%).
  4. Ulasan Teks Kualitatif (minimal 3 kata).
- **Penguncian Idempotensi (`_isSubmitting`)**: Menjamin 1 porsi MBG hari berjalan hanya dapat diulas 1 kali secara sah.

### 🏠 Modul 3: Dashboard & Analitik Real-Time
- **Header Selamat Datang**: Menampilkan Sekolah (`MAN 2 Kota Padang`), Nama Siswa (`Faizullatif Fajran`), Tingkat Kelas (`XII.FA-3`), dan Jam Digital WIB Real-time.
- **Rincian Nutrisi Porsi**: Informasi Energi (kkal), Protein (g), Karbohidrat (g), dan Lemak (g).
- **Status Presensi Streak**: Indikator konsistensi presensi harian siswa (Senin–Jumat).

### 🍳 Modul 5: Rantai Pasok & Produksi Dapur SPPG
- **Pratinjau Menu Esok Hari**: Sembunyikan form ulasan untuk menu esok hari; ganti dengan **Status Rantai Pasok & Dapur SPPG**:
  - 1️⃣ **Verifikasi Bahan Baku** (✅ Selesai)
  - 2️⃣ **Proses Memasak Dapur SPPG** (⏳ Sedang Berlangsung / `PROSES_MEMASAK`)
  - 3️⃣ **Distribusi ke Sekolah** (🚚 Siap Diantar / `SIAP_DISTRIBUSI` pukul 06:30 WIB)
- **Banner Porsi SPPG**: Info pencatatan 450 porsi seimbang standar BGN RI + Tombol Notifikasi Pengingat Presensi.

### 🏆 Modul Gamifikasi, Leaderboard & Dampak Lingkungan (Sub-bab 3.2 Modul 7)
- **Tab 1: Peringkat Siswa Teladan Gizi**:
  - Dataset 50 siswa teratas MAN 2 Kota Padang.
  - **Animasi Auto-Scroll Viewport**: Otomatis menggeser layar sampai posisi siswa berada di tengah viewport.
  - **Sekuens Climber Peringkat**: Peringkat siswa beranimasi meluncur dari **Peringkat #30 ➔ #15** setelah mengirimkan ulasan.
  - Ubin siswa ditandai dengan sorotan hijau emerald soft (`AppColors.primaryLight`) & border tebal (`AppColors.primary`).
- **Tab 2: 10 Lencana Prestasi MBG**:
  - 10 Lencana Resmi (*Pahlawan Piring Bersih, Penyelamat Pangan, Presensi Disiplin, Siswa Teladan Gizi, dll.*).
  - Modal Sertifikat *MBGTrust Certified* dengan tombol bagikan langsung ke **WA Story, IG Story, Facebook, Threads, dan Twitter (X)**.
- **Tab 3: Dampak Lingkungan Berbasis Data Ilmiah**:
  - Berdasarkan riset FAO & Kementan RI: 2,3 kg *food waste* diselamatkan = 5,75 kg emisi CO₂e tercegah = 690 Liter air bersih dihemat.

---

## 5. Implementasi Keamanan CIA Triad

```
1. CONFIDENTIALITY (Kerahasiaan)
   - Otentikasi JWT Bearer Header
   - Transmisi Terenkripsi TLS 1.3 / HTTPS
   - Anonimisasi Data Siswa pada Dasbor Publik

2. INTEGRITY (Integritas Data)
   - Idempotency Lock (_isSubmitting = true)
   - Dual-Validation (Client & Server side)
   - Audit Trail Timestamp ISO-8601 Permanen

3. AVAILABILITY (Ketersediaan Sistem)
   - Async / Await Non-Blocking UI Architecture
   - Graceful Degradation & Network Timeout Fallbacks
   - Riverpod Caching & State Hydration
```

---

## 6. Pedoman Bahasa & Tata Tulis (PUEBI / EYD 5)

- **Standardisasi**: Menggunakan Bahasa Indonesia formal yang ramah pengguna, santun, dan menginspirasi siswa.
- **Eliminasi Istilah Pengujian**: Tidak menggunakan kata-kata pengujian seperti *"simulasi"*, *"demo"*, atau spanduk dev. Seluruh teks siap untuk publikasi produksi resmi.
