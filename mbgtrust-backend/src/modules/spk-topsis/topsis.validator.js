import { z } from 'zod';

export const skemaEksekusiTopsis = z.object({
  tanggal_mulai: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Format tanggal harus YYYY-MM-DD'),
  tanggal_selesai: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Format tanggal harus YYYY-MM-DD'),
  daftar_id_menu: z
    .array(z.number().int().positive())
    .min(2, 'Minimal 2 menu diperlukan untuk perbandingan TOPSIS'),
}).refine(
  (d) => new Date(d.tanggal_mulai) <= new Date(d.tanggal_selesai),
  { message: 'tanggal_mulai tidak boleh setelah tanggal_selesai', path: ['tanggal_mulai'] }
);
