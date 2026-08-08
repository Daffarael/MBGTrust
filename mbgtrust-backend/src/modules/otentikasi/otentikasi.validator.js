import { z } from 'zod';

export const skemaPendaftaran = z.object({
  nik_nisn: z.string().min(10).max(20),
  nama_lengkap: z.string().min(3).max(100),
  id_sekolah: z.number().int().positive(),
  tingkat_kelas: z.string().optional(),
  kata_sandi: z.string().min(8),
  riwayat_alergi: z.array(z.string()).optional().default([]),
});

export const skemaMasuk = z.object({
  nik_nisn: z.string().min(1),
  kata_sandi: z.string().min(1),
});

export const skemaMasukSppg = z.object({
  username_email: z.string().email(),
  kata_sandi: z.string().min(1),
});

export const skemaPerbaruitoken = z.object({
  token_penyegar: z.string().min(1),
});

export const skemaPerbaruiProfil = z.object({
  nama_lengkap: z.string().min(3).max(100).optional(),
  tingkat_kelas: z.string().optional(),
  riwayat_alergi: z.array(z.string()).optional(),
  nomor_kontak: z.string().optional(),
});
