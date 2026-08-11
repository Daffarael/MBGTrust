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
- **Aturan Bebas Elipsis (Zero Text Truncation Rule)**:
  - Seluruh teks informasi penting (nama lengkap siswa, nama sekolah, rincian menu makanan, lencana XP, dan himbauan presensi) **DILARANG TERPOTONG** (`...` / `overflow: TextOverflow.ellipsis`).
  - Seluruh teks harus tampil utuh, lengkap, dan estetik dengan pembungkusan baris (*multiline wrap*), penyesuaian ukuran font dinamis, serta tata letak pembagi ruang yang proporsional.
- **Aturan Bebas Emoji Unicode (Icon-Based UI Rule)**:
  - **DILARANG** menggunakan emoji karakter Unicode (seperti 🔥, 🥩, 🍚, 🥑, 🏆, 💡, 🌿, 🏅) di dalam teks atau komponen UI.
  - Seluruh indikator visual HARUS menggunakan **Flutter Material Icons** (`Icon(Icons.local_fire_department_rounded)`, `Icon(Icons.workspace_premium_rounded)`, `Icon(Icons.restaurant_rounded)`, `Icon(Icons.grain_rounded)`, `Icon(Icons.eco_rounded)`, `Icon(Icons.access_time_filled_rounded)`) agar tampilan konsisten, seragam antar-device, dan tidak merusak estetika tipografi.
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

## 6. Kontrak API Resmi Peran Siswa / Penerima Manfaat (Student API Contract)

Seluruh antarmuka aplikasi siswa (*Penerima Manfaat*) mengonsumsi REST API resmi terenkripsi `HTTPS / TLS 1.3` dengan otentikasi `Authorization: Bearer <JWT_TOKEN>`:

| Endpoint Path | Metode HTTP | Deskripsi Fungsi Operasional | Payload Utama / Response Envelope |
| :--- | :---: | :--- | :--- |
| `/api/v1/auth/login` | `POST` | Otentikasi masuk siswa menggunakan NISN dan kata sandi | `{ nisn, password }` ➔ `{ token, user: { id, name, school, class } }` |
| `/api/v1/auth/me` | `GET` | Memuat profil lengkap siswa & riwayat alergen makanan | `{ id, nisn, name, school, class, allergens: [...] }` |
| `/api/v1/jadwal/hari-ini` | `GET` | Mengambil data menu MBG hari ini, nutrisi, & presensi | `{ scheduleId, menuName, calories, protein, streakDays, status }` |
| `/api/v1/jadwal/besok` | `GET` | Pratinjau menu esok hari & status timeline Dapur SPPG | `{ scheduleId, menuName, supplyChainTimeline: [ { time, title, status } ] }` |
| `/api/v1/jadwal/:id/evaluasi` | `POST` | Mengirim ulasan evaluasi cepat (<15 detik) porsi harian | `{ menerimaPorsi, rasa, kesukaan, porsi, wastePercentage, comment }` |
| `/api/v1/evaluasi/leaderboard` | `GET` | Memuat 50 Siswa Teratas & sekuens rank climb (#30 ➔ #15) | `{ userRank, totalStudents: 50, leaderboard: [ { rank, name, xp, wasteSaved } ] }` |
| `/api/v1/evaluasi/lencana` | `GET` | Memuat 10 Lencana MBG & status klaim sertifikat | `{ badges: [ { id, title, desc, icon, unlocked, shareUrl } ] }` |
| `/api/v1/evaluasi/dampak` | `GET` | Memuat kalkulasi dampak lingkungan (FAO/Kementan RI) | `{ foodWasteSavedKg, co2PreventedKg, waterSavedLiters }` |


---

## 7. Pedoman Bahasa & Tata Tulis (PUEBI / EYD 5)

- **Standardisasi**: Menggunakan Bahasa Indonesia formal yang ramah pengguna, santun, dan menginspirasi siswa.
- **Eliminasi Istilah Pengujian**: Tidak menggunakan kata-kata teknis backend/developer seperti *"Kontrak API Modul 2"*, *"simulasi"*, *"demo"*, atau spanduk dev pada antarmuka siswa. Seluruh teks siap untuk publikasi produksi resmi.
