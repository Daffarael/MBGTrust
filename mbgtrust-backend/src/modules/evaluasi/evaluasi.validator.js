import { z } from 'zod';

// Helper: terima field dari frontend (penilaian_kesukaan / penilaian_porsi)
// MAUPUN field backend legacy (tingkat_kesukaan / kesesuaian_porsi)
// agar backward-compatible dengan Postman & evaluasi kolektif
const nilaiOptional1to5 = z.number().int().min(1).max(5).optional();

export const skemaEvaluasiSiswa = z.object({
  menerima_porsi: z.boolean().optional(),
  penilaian_rasa: nilaiOptional1to5,
  // Frontend kirim 'penilaian_kesukaan', backend simpan ke 'tingkat_kesukaan'
  penilaian_kesukaan: nilaiOptional1to5,
  tingkat_kesukaan: nilaiOptional1to5,   // backward-compat (Postman / kolektif)
  // Frontend kirim 'penilaian_porsi', backend simpan ke 'kesesuaian_porsi'
  penilaian_porsi: nilaiOptional1to5,
  kesesuaian_porsi: nilaiOptional1to5,   // backward-compat
  persentase_sisa_makanan: z.number().min(0).max(100).optional(),
  masukan_kualitatif: z.string().max(500).optional(),
  ulasan_teks: z.string().max(500).optional(),  // alias masukan_kualitatif
});

export const skemaEvaluasiKolektif = z.object({
  id_sekolah: z.number().int().positive(),
  tingkat_kelas: z.string().optional(),
  daftar_evaluasi: z.array(
    z.object({
      nisn_siswa: z.string().min(10),
      menerima_porsi: z.boolean().optional(),
      penilaian_rasa: nilaiOptional1to5,
      tingkat_kesukaan: nilaiOptional1to5,
      kesesuaian_porsi: nilaiOptional1to5,
      persentase_sisa_makanan: z.number().min(0).max(100).optional(),
    })
  ).min(1),
});

export const skemaKonfirmasi = z.object({
  // Frontend kirim 'HADIR' atau 'MENOLAK' — backend DB pakai 'TIDAK_HADIR'
  // transform: normalize 'MENOLAK' → 'TIDAK_HADIR'
  status_kehadiran: z.enum(['HADIR', 'TIDAK_HADIR', 'MENOLAK'])
    .transform((val) => val === 'MENOLAK' ? 'TIDAK_HADIR' : val),
  kode_alasan_penolakan: z.string().optional(),
  catatan_khusus: z.string().max(500).optional(),
});
