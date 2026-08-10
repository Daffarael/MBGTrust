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
1. **Login Admin SPPG (`/sppg/login`)** — Halaman login khusus Admin SPPG.
2. **Dashboard Utama (`/sppg/dashboard`)** — Rekapitulasi data harian real-time, ringkasan statistik program.
3. **Dashboard Hasil NLP (`/sppg/analitik/nlp`)** — Tampilkan hasil analisis sentimen ulasan siswa, kata kunci penyebab food waste, sentimen positif/negatif per menu.
4. **Rekomendasi AI — Porsi & Komposisi (`/sppg/analitik/rekomendasi`)** — Tampilkan rekomendasi penyesuaian porsi dan komposisi menu dari hasil SPK TOPSIS + AI Gemini.
5. **Tren Food Waste & Akurasi Prediksi (`/sppg/analitik/tren`)** — Grafik tren food waste dari waktu ke waktu dan tingkat akurasi prediksi porsi.
6. **Master Bahan Baku (`/sppg/bahan-baku`)** — CRUD bahan baku makanan (nama, satuan, nilai gizi, harga).
7. **Master Menu (`/sppg/menu`)** — CRUD menu dengan referensi bahan baku, informasi gizi, dan alergen.
8. **Jadwal Menu Harian (`/sppg/jadwal`)** — Atur jadwal menu per sekolah per hari.
9. **SPK TOPSIS Engine (`/sppg/spk`)** — Eksekusi analisis TOPSIS, lihat perankingan menu, baca narasi AI.
10. **Rekap Estimasi Produksi (`/sppg/produksi`)** — Kalkulasi porsi H+1 berdasarkan data konfirmasi siswa.
11. **Tracking Distribusi (`/sppg/distribusi`)** — Pantau status pengiriman makanan ke sekolah.

---

## 4. Kriteria TOPSIS — Catatan untuk Tampilan Frontend

> ⚠️ **PENTING:** Seluruh 5 kriteria bersifat **Benefit**. Tampilkan dengan indikator "lebih tinggi = lebih baik" di seluruh visualisasi TOPSIS.

| Kode | Nama Kriteria | Sifat | Bobot |
| :--- | :--- | :--- | :--- |
| C1 | Rasa | **Benefit** ↑ | 20% |
| C2 | Tingkat Kesukaan | **Benefit** ↑ | 15% |
| C3 | Kesesuaian Porsi | **Benefit** ↑ | 10% |
| C4 | Tingkat Konsumsi Makanan | **Benefit** ↑ | 30% |
| C5 | Tingkat Penerimaan MBG | **Benefit** ↑ | 25% |

---

## 5. Technical Roadmap GEMASTIK

### Target Halaman (Prioritas Tinggi → Rendah)

**P0 — Kritis (Harus Ada):**
- Login 3 peran (Siswa, Admin SPPG, Super Admin)
- Konfirmasi konsumsi harian siswa
- Form ulasan teks + rating
- Dashboard SPPG + rekap data
- SPK TOPSIS Engine (eksekusi + hasil)

**P1 — Penting:**
- Gamifikasi siswa (poin + leaderboard + dampak lingkungan)
- Dashboard NLP (hasil analisis sentimen)
- Master bahan baku & menu
- Tren food waste & akurasi prediksi

**P2 — Tambahan:**
- Super Admin panel (manajemen sekolah & akun)
- Detail komposisi bahan per menu
- Ekspor laporan PDF/Excel

---

## 6. Struktur Navigasi GoRouter

```dart
// 3 Grup Navigasi berdasarkan Peran
/login              → Pemilihan peran (Siswa / Admin SPPG / Super Admin)
/sppg/login         → Login Admin SPPG
/admin/login        → Login Super Admin

// === SISWA ROUTES ===
/home               → Beranda siswa + menu hari ini
/konfirmasi         → Konfirmasi konsumsi MBG
/ulasan             → Form ulasan teks + rating + sisa makanan
/profil             → Profil siswa + poin XP
/profil/gamifikasi  → Leaderboard + visualisasi dampak lingkungan
/profil/preferensi  → Preferensi & alergi

// === ADMIN SPPG ROUTES ===
/sppg/dashboard          → Dashboard utama
/sppg/analitik/nlp       → Hasil NLP Sentiment Analysis
/sppg/analitik/rekomendasi → Rekomendasi AI porsi & komposisi
/sppg/analitik/tren      → Tren food waste
/sppg/bahan-baku         → Master bahan baku
/sppg/menu               → Master menu
/sppg/jadwal             → Jadwal menu harian
/sppg/spk                → SPK TOPSIS Engine
/sppg/produksi           → Rekap estimasi produksi
/sppg/distribusi         → Tracking distribusi

// === SUPER ADMIN ROUTES ===
/admin/sekolah           → Manajemen sekolah
/admin/sppg-admin        → Manajemen akun Admin SPPG
/admin/penerima-manfaat  → Manajemen akun siswa
```

---
*Akhir dari Frontend PRD MBGTrust (v5.0.0) — Disesuaikan dengan Gagasan Awal*
