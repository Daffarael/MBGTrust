import { responBerhasil, responGagal } from '../../common/response.js';
import {
  skemaHitungProduksi,
  skemaUpdateStatusProduksi,
  skemaUpdateStatusDistribusi,
} from './produksi.validator.js';
import * as produksiService from './produksi.service.js';

const tangkapZodError = (res, err) =>
  responGagal(
    res,
    'Validasi input gagal.',
    400,
    err.errors.map((e) => ({ bidang: e.path.join('.'), pesan: e.message }))
  );

// ─── Rencana Produksi ──────────────────────────────────────────

export const rekapitulasiHarian = async (req, res, next) => {
  try {
    const tanggal = req.query.tanggal;
    if (!tanggal || !/^\d{4}-\d{2}-\d{2}$/.test(tanggal)) {
      return responGagal(res, 'Query parameter tanggal wajib diisi dengan format YYYY-MM-DD.', 400);
    }
    const hasil = await produksiService.rekapitulasiHarian(tanggal);
    return responBerhasil(res, 'Rekapitulasi presisi porsi H+1 berhasil diambil.', hasil);
  } catch (err) {
    next(err);
  }
};

export const hitungUlangEstimasi = async (req, res, next) => {
  try {
    const data = skemaHitungProduksi.parse(req.body);
    const hasil = await produksiService.hitungUlangEstimasi(data.tanggal_target);
    return responBerhasil(res, 'Hitung ulang estimasi produksi berhasil diproses.', hasil);
  } catch (err) {
    if (err.name === 'ZodError') return tangkapZodError(res, err);
    next(err);
  }
};

// ─── Produksi ──────────────────────────────────────────────────

export const ambilProduksiAktif = async (req, res, next) => {
  try {
    const hasil = await produksiService.ambilProduksiAktif();
    return responBerhasil(res, 'Siklus produksi aktif berhasil diambil.', hasil);
  } catch (err) {
    next(err);
  }
};

export const updateStatusProduksi = async (req, res, next) => {
  try {
    const idProduksi = parseInt(req.params.idProduksi);
    if (isNaN(idProduksi)) return responGagal(res, 'ID produksi tidak valid.', 400);
    const data = skemaUpdateStatusProduksi.parse(req.body);
    const hasil = await produksiService.updateStatusProduksi(idProduksi, data);
    return responBerhasil(res, 'Status produksi berhasil diperbarui.', hasil);
  } catch (err) {
    if (err.name === 'ZodError') return tangkapZodError(res, err);
    next(err);
  }
};

// ─── Distribusi ────────────────────────────────────────────────

export const updateStatusDistribusi = async (req, res, next) => {
  try {
    const idDistribusi = parseInt(req.params.idDistribusi);
    if (isNaN(idDistribusi)) return responGagal(res, 'ID distribusi tidak valid.', 400);
    const data = skemaUpdateStatusDistribusi.parse(req.body);
    const hasil = await produksiService.updateStatusDistribusi(idDistribusi, data);
    return responBerhasil(res, 'Status pengiriman berhasil diperbarui.', hasil);
  } catch (err) {
    if (err.name === 'ZodError') return tangkapZodError(res, err);
    next(err);
  }
};
