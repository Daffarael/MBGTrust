import { z } from 'zod';

export const skemaHitungProduksi = z.object({
  tanggal_target: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Format tanggal harus YYYY-MM-DD'),
});

export const skemaUpdateStatusProduksi = z.object({
  status_produksi: z.enum(['PERSIAPAN', 'MEMASAK', 'SELESAI', 'DIBATALKAN']),
  jumlah_dimasak: z.number().int().positive().optional(),
  catatan_dapur: z.string().max(500).optional(),
});

export const skemaUpdateStatusDistribusi = z.object({
  status_distribusi: z.enum(['DISIAPKAN', 'DIKIRIM', 'TIBA_DI_SEKOLAH', 'GAGAL']),
  waktu_tiba: z.string().datetime().optional(),
  catatan_kurir: z.string().max(500).optional(),
});
