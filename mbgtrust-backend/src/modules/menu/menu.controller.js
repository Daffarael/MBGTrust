import { responBerhasil, responGagal } from '../../common/response.js';
import {
  skemaTambahMenu,
  skemaPerbaruiMenu,
  skemaPlottingJadwal,
} from './menu.validator.js';
import * as menuService from './menu.service.js';

const tangkapZodError = (res, err) =>
  responGagal(
    res,
    'Validasi input gagal.',
    400,
    err.errors.map((e) => ({ bidang: e.path.join('.'), pesan: e.message }))
  );

// ─── Master Menu ───────────────────────────────────────────────

export const tambahMenu = async (req, res, next) => {
  try {
    const data = skemaTambahMenu.parse(req.body);
    const hasil = await menuService.tambahMenu(data);
    return responBerhasil(res, 'Master menu MBG berhasil ditambahkan.', hasil, 201);
  } catch (err) {
    if (err.name === 'ZodError') return tangkapZodError(res, err);
    next(err);
  }
};

export const ambilDaftarMenu = async (req, res, next) => {
  try {
    const halaman = parseInt(req.query.halaman) || 1;
    const batas = parseInt(req.query.batas) || 10;
    const cari = req.query.cari;
    const { data, meta } = await menuService.ambilDaftarMenu({ halaman, batas, cari });
    return responBerhasil(res, 'Daftar menu MBG berhasil diambil.', data, 200, meta);
  } catch (err) {
    next(err);
  }
};

export const ambilDetailMenu = async (req, res, next) => {
  try {
    const idMenu = parseInt(req.params.idMenu);
    if (isNaN(idMenu)) return responGagal(res, 'ID menu tidak valid.', 400);
    const hasil = await menuService.ambilDetailMenu(idMenu);
    return responBerhasil(res, 'Detail menu berhasil diambil.', hasil);
  } catch (err) {
    next(err);
  }
};

export const perbaruiMenu = async (req, res, next) => {
  try {
    const idMenu = parseInt(req.params.idMenu);
    if (isNaN(idMenu)) return responGagal(res, 'ID menu tidak valid.', 400);
    const data = skemaPerbaruiMenu.parse(req.body);
    const hasil = await menuService.perbaruiMenu(idMenu, data);
    return responBerhasil(res, 'Master menu berhasil diperbarui.', hasil);
  } catch (err) {
    if (err.name === 'ZodError') return tangkapZodError(res, err);
    next(err);
  }
};

// ─── Jadwal Menu ───────────────────────────────────────────────

export const plottingJadwal = async (req, res, next) => {
  try {
    const data = skemaPlottingJadwal.parse(req.body);
    const hasil = await menuService.plottingJadwal(data);
    return responBerhasil(res, 'Jadwal menu MBG berhasil dipublikasikan.', hasil, 201);
  } catch (err) {
    if (err.name === 'ZodError') return tangkapZodError(res, err);
    next(err);
  }
};

export const ambilJadwalHariIni = async (req, res, next) => {
  try {
    const idSekolah = parseInt(req.query.id_sekolah);
    if (isNaN(idSekolah)) return responGagal(res, 'Query parameter id_sekolah harus berupa angka.', 400);
    const idPengguna = req.pengguna?.id ?? null;
    const hasil = await menuService.ambilJadwalHariIni(idSekolah, idPengguna);
    return responBerhasil(res, 'Menu hari ini berhasil diambil.', hasil);
  } catch (err) {
    next(err);
  }
};

export const ambilJadwalBesok = async (req, res, next) => {
  try {
    const idSekolah = parseInt(req.query.id_sekolah);
    if (isNaN(idSekolah)) return responGagal(res, 'Query parameter id_sekolah harus berupa angka.', 400);
    const idPengguna = req.pengguna?.id ?? null;
    const hasil = await menuService.ambilJadwalBesok(idSekolah, idPengguna);
    return responBerhasil(res, 'Rencana menu besok berhasil diambil.', hasil);
  } catch (err) {
    next(err);
  }
};
