import { responBerhasil, responGagal } from '../../common/response.js';
import { skemaEksekusiTopsis } from './topsis.validator.js';
import * as topsisService from './topsis.service.js';

const tangkapZodError = (res, err) =>
  responGagal(
    res,
    'Validasi input gagal.',
    400,
    err.errors.map((e) => ({ bidang: e.path.join('.'), pesan: e.message }))
  );

export const jalankanEksekusi = async (req, res, next) => {
  try {
    const data = skemaEksekusiTopsis.parse(req.body);
    const hasil = await topsisService.jalankanEksekusi({
      ...data,
      id_sekolah: req.pengguna?.idSekolah ?? data.id_sekolah ?? null,
    });
    return responBerhasil(res, 'Kalkulasi SPK TOPSIS selesai dieksekusi.', hasil);
  } catch (err) {
    if (err.name === 'ZodError') return tangkapZodError(res, err);
    next(err);
  }
};

export const ambilDetailEksekusi = async (req, res, next) => {
  try {
    const idEksekusi = parseInt(req.params.idEksekusi);
    if (isNaN(idEksekusi)) return responGagal(res, 'ID eksekusi tidak valid.', 400);
    const hasil = await topsisService.ambilDetailEksekusi(idEksekusi);
    return responBerhasil(res, 'Rincian matriks TOPSIS berhasil diambil.', hasil);
  } catch (err) {
    next(err);
  }
};

export const ambilRekomendasi = async (req, res, next) => {
  try {
    const hasil = await topsisService.ambilRekomendasi();
    return responBerhasil(res, 'Daftar rekomendasi menu berhasil diambil.', hasil);
  } catch (err) {
    next(err);
  }
};
