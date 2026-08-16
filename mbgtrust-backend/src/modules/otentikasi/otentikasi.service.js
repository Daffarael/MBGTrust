import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import prisma from '../../config/prisma.js';
import { jwtConfig } from '../../config/jwt.js';

const buatTokenAkses = (payload) =>
  jwt.sign(payload, jwtConfig.accessSecret, { expiresIn: jwtConfig.accessExpiresIn });

const buatTokenPenyegar = (payload) =>
  jwt.sign(payload, jwtConfig.refreshSecret, { expiresIn: jwtConfig.refreshExpiresIn });

const simpanTokenPenyegar = async (idPengguna, token) => {
  const kedaluwarsa = new Date();
  kedaluwarsa.setDate(kedaluwarsa.getDate() + 7);
  await prisma.tokenPenyegar.create({
    data: { idPengguna, token, kedaluwarsa },
  });
};

const buatPayloadJwt = (pengguna) => ({
  id: pengguna.id,
  peran: pengguna.peran,
  idSekolah: pengguna.idSekolah,
});

export const daftarSiswa = async (data) => {
  const sudahAda = await prisma.pengguna.findUnique({ where: { nikNisn: data.nik_nisn } });
  if (sudahAda) {
    const err = new Error('NIK/NISN sudah terdaftar.');
    err.status = 409;
    throw err;
  }

  const sekolah = await prisma.sekolah.findUnique({ where: { id: data.id_sekolah } });
  if (!sekolah) {
    const err = new Error('Sekolah tidak ditemukan.');
    err.status = 404;
    throw err;
  }

  const kataSandiHash = await bcrypt.hash(data.kata_sandi, 12);

  const pengguna = await prisma.pengguna.create({
    data: {
      nikNisn: data.nik_nisn,
      namaLengkap: data.nama_lengkap,
      idSekolah: data.id_sekolah,
      tingkatKelas: data.tingkat_kelas,
      katasandi: kataSandiHash,
      riwayatAlergi: data.riwayat_alergi ?? [],
      peran: 'PENERIMA_MANFAAT',
    },
    include: { sekolah: true },
  });

  return {
    id_pengguna: pengguna.id,
    nik_nisn: pengguna.nikNisn,
    nama_lengkap: pengguna.namaLengkap,
    peran: pengguna.peran,
    nama_sekolah: pengguna.sekolah.nama,
  };
};

export const masukSiswa = async (nikNisn, kataSandi) => {
  const pengguna = await prisma.pengguna.findUnique({
    where: { nikNisn },
    include: { sekolah: true },
  });

  if (!pengguna || !(await bcrypt.compare(kataSandi, pengguna.katasandi))) {
    const err = new Error('NIK/NISN atau kata sandi salah.');
    err.status = 401;
    throw err;
  }

  const payload = buatPayloadJwt(pengguna);
  const tokenAkses = buatTokenAkses(payload);
  const tokenPenyegar = buatTokenPenyegar(payload);
  await simpanTokenPenyegar(pengguna.id, tokenPenyegar);

  return {
    token_akses: tokenAkses,
    token_penyegar: tokenPenyegar,
    jenis_token: 'Bearer',
    kadaluwarsa_dalam_detik: jwtConfig.accessExpiresInSeconds,
    pengguna: {
      id_pengguna: pengguna.id,
      nama_lengkap: pengguna.namaLengkap,
      peran: pengguna.peran,
      id_sekolah: pengguna.idSekolah,
    },
  };
};

export const masukSppg = async (email, kataSandi) => {
  const pengguna = await prisma.pengguna.findUnique({ where: { email } });

  if (!pengguna || !(await bcrypt.compare(kataSandi, pengguna.katasandi))) {
    const err = new Error('Email atau kata sandi salah.');
    err.status = 401;
    throw err;
  }

  if (!['SUPER_ADMIN', 'SPPG_ADMIN'].includes(pengguna.peran)) {
    const err = new Error('Akun ini bukan akun Admin.');
    err.status = 403;
    throw err;
  }

  const payload = buatPayloadJwt(pengguna);
  const tokenAkses = buatTokenAkses(payload);
  const tokenPenyegar = buatTokenPenyegar(payload);
  await simpanTokenPenyegar(pengguna.id, tokenPenyegar);

  return {
    token_akses: tokenAkses,
    token_penyegar: tokenPenyegar,
    jenis_token: 'Bearer',
    kadaluwarsa_dalam_detik: jwtConfig.accessExpiresInSeconds,
    pengguna: {
      id_pengguna: pengguna.id,
      nama_lengkap: pengguna.namaLengkap,
      peran: pengguna.peran,
    },
  };
};

export const perbaruitoken = async (tokenPenyegar) => {
  const catatanToken = await prisma.tokenPenyegar.findUnique({
    where: { token: tokenPenyegar },
    include: { pengguna: true },
  });

  if (!catatanToken || catatanToken.kedaluwarsa < new Date()) {
    const err = new Error('Token penyegar tidak valid atau sudah kedaluwarsa.');
    err.status = 401;
    throw err;
  }

  try {
    jwt.verify(tokenPenyegar, jwtConfig.refreshSecret);
  } catch {
    const err = new Error('Token penyegar tidak valid.');
    err.status = 401;
    throw err;
  }

  const payload = buatPayloadJwt(catatanToken.pengguna);
  const tokenAksesBaru = buatTokenAkses(payload);

  return {
    token_akses: tokenAksesBaru,
    jenis_token: 'Bearer',
    kadaluwarsa_dalam_detik: jwtConfig.accessExpiresInSeconds,
  };
};

export const ambilProfil = async (idPengguna) => {
  const pengguna = await prisma.pengguna.findUnique({
    where: { id: idPengguna },
    include: { sekolah: true },
  });

  if (!pengguna) {
    const err = new Error('Pengguna tidak ditemukan.');
    err.status = 404;
    throw err;
  }

  return {
    id_pengguna: pengguna.id,
    nik_nisn: pengguna.nikNisn,
    nama_lengkap: pengguna.namaLengkap,
    peran: pengguna.peran,
    id_sekolah: pengguna.idSekolah,
    nama_sekolah: pengguna.sekolah?.nama ?? null,
    tingkat_kelas: pengguna.tingkatKelas,
    riwayat_alergi: pengguna.riwayatAlergi,
    nomor_kontak: pengguna.nomorKontak,
    poin_xp: pengguna.poinXp,
  };
};

export const perbaruiProfil = async (idPengguna, data) => {
  const pengguna = await prisma.pengguna.update({
    where: { id: idPengguna },
    data: {
      ...(data.nama_lengkap && { namaLengkap: data.nama_lengkap }),
      ...(data.tingkat_kelas !== undefined && { tingkatKelas: data.tingkat_kelas }),
      ...(data.riwayat_alergi !== undefined && { riwayatAlergi: data.riwayat_alergi }),
      ...(data.nomor_kontak !== undefined && { nomorKontak: data.nomor_kontak }),
    },
  });

  return {
    id_pengguna: pengguna.id,
    nama_lengkap: pengguna.namaLengkap,
    tingkat_kelas: pengguna.tingkatKelas,
  };
};
