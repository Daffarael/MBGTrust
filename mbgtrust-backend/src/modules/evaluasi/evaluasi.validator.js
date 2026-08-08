import { z } from 'zod';

export const skemaEvaluasiSiswa = z.object({
  menerima_porsi: z.boolean().optional(),
  penilaian_rasa: z.number().int().min(1).max(5).optional(),
  tingkat_kesukaan: z.number().int().min(1).max(5).optional(),
  kesesuaian_porsi: z.number().int().min(1).max(5).optional(),
  persentase_sisa_makanan: z.number().min(0).max(100).optional(),
  masukan_kualitatif: z.string().max(500).optional(),
});

export const skemaEvaluasiKolektif = z.object({
  id_sekolah: z.number().int().positive(),
  tingkat_kelas: z.string().optional(),
  daftar_evaluasi: z.array(
    z.object({
      nisn_siswa: z.string().min(10),
      menerima_porsi: z.boolean().optional(),
      penilaian_rasa: z.number().int().min(1).max(5).optional(),
      tingkat_kesukaan: z.number().int().min(1).max(5).optional(),
      kesesuaian_porsi: z.number().int().min(1).max(5).optional(),
      persentase_sisa_makanan: z.number().min(0).max(100).optional(),
    })
  ).min(1),
});

export const skemaKonfirmasi = z.object({
  status_kehadiran: z.enum(['HADIR', 'TIDAK_HADIR']),
  kode_alasan_penolakan: z.string().optional(),
  catatan_khusus: z.string().max(500).optional(),
});
