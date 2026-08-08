import { responBerhasil, responGagal } from '../../common/response.js';
import {
  skemaEvaluasiSiswa,
  skemaEvaluasiKolektif,
  skemaKonfirmasi,
} from './evaluasi.validator.js';
import * as evaluasiService from './evaluasi.service.js';

const tangkapZodError = (res, err) =>
  responGagal(
    res,
    'Validasi input gagal.',
    400,
    err.errors.map((e) => ({ bidang: e.path.join('.'), pesan: e.message }))
  );

export const kirimEvaluasiSiswa = async (req, res, next) => {
  try {
    const idJadwal = parseInt(req.params.idJadwal);
    if (isNaN(idJadwal)) return responGagal(res, 'ID jadwal tidak valid.', 400);
    const data = skemaEvaluasiSiswa.parse(req.body);
    const hasil = await evaluasiService.kirimEvaluasiSiswa(idJadwal, req.pengguna.id, data);
    return responBerhasil(res, 'Umpan balik evaluasi menu berhasil disimpan.', hasil, 201);
  } catch (err) {
    if (err.name === 'ZodError') return tangkapZodError(res, err);
    next(err);
  }
};

export const kirimEvaluasiKolektif = async (req, res, next) => {
  try {
    const idJadwal = parseInt(req.params.idJadwal);
    if (isNaN(idJadwal)) return responGagal(res, 'ID jadwal tidak valid.', 400);
    const data = skemaEvaluasiKolektif.parse(req.body);
    const hasil = await evaluasiService.kirimEvaluasiKolektif(idJadwal, data);
    return responBerhasil(res, 'Evaluasi kolektif berhasil direkam.', hasil, 201);
  } catch (err) {
    if (err.name === 'ZodError') return tangkapZodError(res, err);
    next(err);
  }
};

export const kirimKonfirmasi = async (req, res, next) => {
  try {
    const idJadwal = parseInt(req.params.idJadwal);
    if (isNaN(idJadwal)) return responGagal(res, 'ID jadwal tidak valid.', 400);
    const data = skemaKonfirmasi.parse(req.body);
    const hasil = await evaluasiService.kirimKonfirmasi(idJadwal, req.pengguna.id, data);
    return responBerhasil(res, 'Konfirmasi kehadiran H+1 berhasil dicatat.', hasil);
  } catch (err) {
    if (err.name === 'ZodError') return tangkapZodError(res, err);
    next(err);
  }
};

export const ambilAlasanPenolakan = async (req, res, next) => {
  try {
    const hasil = await evaluasiService.ambilAlasanPenolakan();
    return responBerhasil(res, 'Daftar alasan penolakan berhasil diambil.', hasil);
  } catch (err) {
    next(err);
  }
};
