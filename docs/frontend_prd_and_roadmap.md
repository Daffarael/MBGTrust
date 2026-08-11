# Master Product Requirement Document (PRD) & Technical Roadmap
## MBGTrust — Frontend Client Layer (Flutter 3.19 Enterprise Architecture)

**Nama Proyek:** MBGTrust — Platform Digital Berbasis AI untuk Mitigasi Food Waste pada Program Makan Bergizi Gratis  
**Target Kompetisi:** GEMASTIK — Bidang Pengembangan Perangkat Lunak (PPL)  
**Penulis / Arsitek Utama:** Frontend Lead (Fuadi Dhiyaulhaq)  
**Dokumentasi Acuan:** `docs/api_specification_contract.md`, `docs/backend_prd_and_roadmap.md`, `docs/dokumentasi_gagasan_awal_mbgtrust.md`  
**Stack Teknologi Utama:**  
* 📱 **Client Framework:** Flutter 3.19 (Dart 3.3) — Mobile Android (Target Utama)
* 🎨 **Design System:** Custom HSL Palette, Material 3, Inter/Outfit Typography, Glassmorphism  
* ⚡ **State Management:** Flutter Riverpod v2.5  
* 🌐 **Networking & Routing:** Dio v5.4 Client + Custom Interceptors, GoRouter v13  
* 🔐 **Storage & Auth:** Flutter Secure Storage (KeyStore / Keychain), JWT Bearer Token  
**Versi Dokumen:** 5.0.0 (Disesuaikan Gagasan Awal — 3 Peran, 5 Modul, 27 Fitur)  
**Status:** Ditetapkan & Mengikat sebagai Panduan Tunggal Pengkodean Frontend  

---

## 1. Arsitektur 3 Peran Pengguna

Sesuai **Gagasan Awal**, sistem MBGTrust melayani **3 PERAN UTAMA**:

```
               ┌────────────────────────────────────────────────────────┐
               │                🌐 PLATFORM MBGTRUST                    │
               └────────┬───────────────────┬───────────────────────────┘
                        │                   │                  │
         ┌──────────────▼──────┐  ┌─────────▼──────────┐  ┌───▼────────────────┐
         │ 🔴 SUPER ADMIN      │  │ 🔵 ADMIN SPPG      │  │ 🟢 PENERIMA MANFAAT│
         │ (Administrator)     │  │ (Pengelola Program) │  │ (Siswa/Siswi)      │
         ├─────────────────────┤  ├────────────────────┤  ├────────────────────┤
         │ - Kelola Sekolah    │  │ - Dashboard AI/NLP │  │ - Konfirmasi Makan │
         │ - Kelola Admin SPPG │  │ - SPK TOPSIS       │  │ - Ulasan Teks+Rating│
         │ - Kelola Siswa      │  │ - Master Menu      │  │ - Laporan Sisa     │
         │                     │  │ - Bahan Baku       │  │ - Gamifikasi & Poin│
         │                     │  │ - Produksi/Distribusi│ │ - Leaderboard      │
         └─────────────────────┘  └────────────────────┘  └────────────────────┘
```

---

## 2. Design System & Tokens Visual Frontend

### 2.1 Skema Warna Curated HSL (Palette Rules)
```dart
abstract class AppColors {
  static const Color primary = Color(0xFF10B981); // Emerald Green
  static const Color primaryDark = Color(0xFF065F46);
  static const Color primaryLight = Color(0xFFD1FAE5);
  static const Color secondary = Color(0xFFF59E0B); // Warm Gold
  static const Color secondaryDark = Color(0xFFB45309);
  static const Color secondaryLight = Color(0xFFFEF3C7);
  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
}
```

### 2.2 Aturan Responsivitas Layout
Setiap `body` pada `Scaffold` **WAJIB** dibungkus dengan:
```dart
body: Center(
  child: Container(
    constraints: const BoxConstraints(maxWidth: 640),
    child: ...
  ),
)
```

---

## 3. Pemetaan 3 Peran Utama & Target Fitur

### 🔴 PERAN 0: SUPER ADMIN (Administrator Sistem)
1. **Login Super Admin** — Halaman login terpisah untuk Super Admin.
2. **Manajemen Sekolah (`/admin/sekolah`)** — CRUD daftar sekolah yang terdaftar dalam program MBG.
3. **Manajemen Akun Admin SPPG (`/admin/sppg-admin`)** — Buat & kelola akun Admin SPPG per SPPG.
4. **Manajemen Akun Penerima Manfaat (`/admin/penerima-manfaat`)** — Buat & kelola akun siswa per sekolah.

---

### 🟢 PERAN 1: PENERIMA MANFAAT (Siswa/Siswi Sekolah)
1. **Otentikasi Login (`/login`)** — Login menggunakan kredensial yang diberikan (NISN/ID + kata sandi).
2. **Perbarui Profil & Kata Sandi (`/profil`)** — Edit nama, kata sandi, preferensi makanan.
3. **Beranda & Menu Hari Ini (`/home`)** — Tampilkan menu MBG terjadwal hari ini + detail komposisi bahan.
4. **Konfirmasi Konsumsi MBG Harian (`/konfirmasi`)** — Jawab: "Apakah kamu mengonsumsi MBG hari ini?" (Ya/Tidak + alasan).
5. **Ulasan Menu (`/ulasan`)** — Form rating ⭐ (rasa, kesukaan, porsi) + **ulasan teks bebas** (input untuk NLP) + laporan volume sisa makanan.
6. **Gamifikasi & Dampak Lingkungan (`/profil/gamifikasi`)** — Tampilkan poin XP, **papan peringkat (leaderboard)**, dan **visualisasi dampak pengurangan food waste** (kg CO2, liter air, dll).
7. **Preferensi & Alergi (`/profil/preferensi`)** — Atur preferensi makanan dan riwayat alergi bahan.

---

### 🔵 PERAN 2: ADMIN SPPG (Pengelola Program MBG)
1. **Otentikasi Login (`/login`)** — Login terpadu dengan deteksi otomatis peran Admin SPPG.
2. **Dashboard Utama (`/sppg/dashboard`)** — Rekapitulasi data real-time food waste, ringkasan statistik program & status operasional.
3. **Dashboard Hasil NLP (`/sppg/analitik/nlp`)** — Tampilkan hasil analisis sentimen ulasan siswa & kata kunci penyebab food waste per menu.
4. **Rekomendasi AI (`/sppg/analitik/rekomendasi`)** — Tampilkan rekomendasi penyesuaian porsi & perbaikan komposisi menu dari TOPSIS + AI.
5. **Tren Food Waste (`/sppg/analitik/tren`)** — Grafik tren food waste dari waktu ke waktu dan tingkat akurasi prediksi model.
6. **Master Bahan Baku (`/manage-ingredients`)** — CRUD bahan baku makanan sehat (nama, kategori, nilai gizi, status stok).
7. **Master Menu (`/manage-menu`)** — CRUD menu MBG dengan rincian komposisi bahan baku, nilai gizi, dan alergen.
8. **Jadwal Menu Batch Mingguan (`/create-schedule`)** — Penyusunan jadwal menu Senin–Jumat (diisi setiap hari Jumat sebelum pemesanan logistik).
9. **SPK TOPSIS Engine (`/sppg/topsis-spk-engine`)** — Engine eksekusi TOPSIS, visualisasi matriks keputusan, dan penerapan ranking menu otomatis.
10. **Pemantauan Status Produksi (`/estimation`)** — Pelacakan alur dapur (Persiapan → Memasak → Packing → Siap Kirim).
11. **Tracking Distribusi (`/distribution-tracker`)** — Pantau status pengiriman paket makanan ke sekolah mitra (Dalam Perjalanan, Sampai di Sekolah).

---

## 4. Struktur 5 Modul Resmi Codebase (`lib/features/`)

```
lib/features/
├── 1_user_management/         <-- [MODUL 1: MANAJEMEN PENGGUNA]
│   ├── auth/                  (Login, Preferences, Splash)
│   ├── profile/               (Profil Saya)
│   └── admin/                 (Super Admin: Manage Sekolah, SPPG Admins, Siswa)
│
├── 2_evaluation_reporting/    <-- [MODUL 2: PELAPORAN & EVALUASI]
│   ├── home/                  (Beranda & Menu Hari Ini)
│   ├── evaluation/            (Detail Menu, Gamifikasi & Leaderboard)
│   └── rating/                (Ulasan Tekstual, Rating, & Laporan % Waste)
│
├── 3_dashboard_analytics/     <-- [MODUL 3: DASHBOARD & ANALITIK]
│   └── sppg/                  (Dashboard SPPG, NLP Sentiment Analysis, Tren Waste, Profil)
│
├── 4_dss_engine/              <-- [MODUL 4: SISTEM PENDUKUNG KEPUTUSAN]
│   └── topsis/                (Engine SPK TOPSIS & Rekomendasi AI)
│
└── 5_menu_production/         <-- [MODUL 5: MANAJEMEN MENU & PRODUKSI]
    ├── menu/                  (Master Menu, Master Bahan Baku, Jadwal Mingguan, SPK TOPSIS Screen)
    ├── production/            (Status Produksi Dapur & Collapsible Sidebar Layout)
    └── distribution/          (Tracking Pengiriman Logistik)
```

---

## 5. Kriteria TOPSIS — Catatan untuk Tampilan Frontend

> ⚠️ **PENTING:** Seluruh 5 kriteria bersifat **Benefit**. Tampilkan dengan indikator "lebih tinggi = lebih baik" di seluruh visualisasi TOPSIS.

| Kode | Nama Kriteria | Sifat | Bobot |
| :--- | :--- | :--- | :--- |
| C1 | Rasa | **Benefit** ↑ | 20% |
| C2 | Tingkat Kesukaan | **Benefit** ↑ | 15% |
| C3 | Kesesuaian Porsi | **Benefit** ↑ | 10% |
| C4 | Tingkat Konsumsi Makanan | **Benefit** ↑ | 30% |
| C5 | Tingkat Penerimaan MBG | **Benefit** ↑ | 25% |

---

## 6. Technical Roadmap GEMASTIK

### Target Halaman (Prioritas Tinggi → Rendah)

**P0 — Kritis (Harus Ada):**
- Login 3 peran (Siswa, Admin SPPG, Super Admin)
- Form ulasan teks + rating + % sisa makanan siswa
- Dashboard SPPG + rekap data real-time
- SPK TOPSIS Engine (eksekusi + visualisasi matriks)

**P1 — Penting:**
- Gamifikasi siswa (poin XP + leaderboard + dampak lingkungan)
- Dashboard NLP (analisis sentimen ulasan)
- Master bahan baku & menu makanan
- Tren food waste & akurasi model
- Jadwal Menu Batch Mingguan (Senin-Jumat)

**P2 — Tambahan:**
- Super Admin panel (manajemen sekolah & akun)
- Detail komposisi bahan per menu

---

## 7. Struktur Navigasi GoRouter

```dart
// 1. Otentikasi & Profil
/login              → Login terpadu (Siswa / Admin SPPG / Super Admin)
/profile            → Profil Siswa
/sppg/profil-saya   → Profil Admin SPPG
/admin/profil-saya  → Profil Super Admin

// 2. Siswa / Penerima Manfaat
/home               → Beranda siswa + menu hari ini
/profil/gamifikasi  → Leaderboard + visualisasi dampak lingkungan
/profil/preferensi  → Preferensi & alergi

// 3. Admin SPPG (Modular via Collapsible Sidebar)
/sppg/dashboard          → Dashboard utama
/sppg/analitik/nlp       → Hasil NLP Sentiment Analysis
/sppg/analitik/rekomendasi → Rekomendasi AI porsi & komposisi
/sppg/analitik/tren      → Tren food waste
/manage-ingredients      → Master bahan baku makanan
/manage-menu             → Master katalog menu
/create-schedule         → Jadwal menu batch mingguan (Senin-Jumat)
/sppg/topsis-spk-engine  → Engine SPK TOPSIS
/estimation              → Pemantauan status produksi dapur
/distribution-tracker    → Tracking pengiriman distribusi

// 4. Super Admin
/admin/sekolah           → Manajemen sekolah
/admin/sppg-admin        → Manajemen akun Admin SPPG
/admin/penerima-manfaat  → Manajemen akun siswa
```


---
*Akhir dari Frontend PRD MBGTrust (v5.0.0) — Disesuaikan dengan Gagasan Awal*
