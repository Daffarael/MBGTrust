import { z } from 'zod';

export const skemaTambahMenu = z.object({
  nama_menu: z.string().min(3).max(200),
  kategori: z.enum(['MAKANAN_BERAT', 'SNACK', 'MINUMAN']).optional(),
  deskripsi: z.string().optional(),
  kalori_kkal: z.number().positive().optional(),
  protein_gram: z.number().nonnegative().optional(),
  karbohidrat_gram: z.number().nonnegative().optional(),
  lemak_gram: z.number().nonnegative().optional(),
  komposisi_bahan: z.array(z.string()).optional().default([]),
  potensi_alergen: z.array(z.string()).optional().default([]),
  estimasi_biaya_per_porsi: z.number().int().nonnegative().optional(),
});

export const skemaPerbaruiMenu = skemaTambahMenu.partial();

export const skemaPlottingJadwal = z.object({
  id_menu: z.number().int().positive(),
  id_sekolah: z.number().int().positive(),
  tanggal_jadwal: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Format tanggal harus YYYY-MM-DD'),
  target_total_porsi: z.number().int().positive().optional(),
});
