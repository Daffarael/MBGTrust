import { responBerhasil, responGagal } from '../../common/response.js';
import {
  skemaPendaftaran,
  skemaMasuk,
  skemaMasukSppg,
  skemaPerbaruitoken,
  skemaPerbaruiProfil,
} from './otentikasi.validator.js';
import * as otentikasiService from './otentikasi.service.js';

export const pendaftaran = async (req, res, next) => {
  try {
    const data = skemaPendaftaran.parse(req.body);
    const hasil = await otentikasiService.daftarSiswa(data);
    return responBerhasil(res, 'Pendaftaran akun penerima manfaat berhasil.', hasil, 201);
  } catch (err) {
    if (err.name === 'ZodError') {
      return responGagal(
        res,
        'Validasi input gagal.',
        400,
        err.errors.map((e) => ({ bidang: e.path.join('.'), pesan: e.message }))
      );
    }
    next(err);
  }
};

export const masuk = async (req, res, next) => {
  try {
    const { nik_nisn, kata_sandi } = skemaMasuk.parse(req.body);
    const hasil = await otentikasiService.masukSiswa(nik_nisn, kata_sandi);
    return responBerhasil(res, 'Autentikasi berhasil.', hasil);
  } catch (err) {
    if (err.name === 'ZodError') {
      return responGagal(res, 'Validasi input gagal.', 400,
        err.errors.map((e) => ({ bidang: e.path.join('.'), pesan: e.message }))
      );
    }
    next(err);
  }
};

export const masukSppg = async (req, res, next) => {
  try {
    const { username_email, kata_sandi } = skemaMasukSppg.parse(req.body);
    const hasil = await otentikasiService.masukSppg(username_email, kata_sandi);
    return responBerhasil(res, 'Autentikasi Admin SPPG berhasil.', hasil);
  } catch (err) {
    if (err.name === 'ZodError') {
      return responGagal(res, 'Validasi input gagal.', 400,
        err.errors.map((e) => ({ bidang: e.path.join('.'), pesan: e.message }))
      );
    }
    next(err);
  }
};

export const perbaruiToken = async (req, res, next) => {
  try {
    const { token_penyegar } = skemaPerbaruitoken.parse(req.body);
    const hasil = await otentikasiService.perbaruitoken(token_penyegar);
    return responBerhasil(res, 'Token akses berhasil diperbarui.', hasil);
  } catch (err) {
    if (err.name === 'ZodError') {
      return responGagal(res, 'Validasi input gagal.', 400,
        err.errors.map((e) => ({ bidang: e.path.join('.'), pesan: e.message }))
      );
    }
    next(err);
  }
};

export const ambilProfil = async (req, res, next) => {
  try {
    const hasil = await otentikasiService.ambilProfil(req.pengguna.id);
    return responBerhasil(res, 'Profil pengguna berhasil diambil.', hasil);
  } catch (err) {
    next(err);
  }
};

export const perbaruiProfil = async (req, res, next) => {
  try {
    const data = skemaPerbaruiProfil.parse(req.body);
    const hasil = await otentikasiService.perbaruiProfil(req.pengguna.id, data);
    return responBerhasil(res, 'Profil pengguna berhasil diperbarui.', hasil);
  } catch (err) {
    if (err.name === 'ZodError') {
      return responGagal(res, 'Validasi input gagal.', 400,
        err.errors.map((e) => ({ bidang: e.path.join('.'), pesan: e.message }))
      );
    }
    next(err);
  }
};
