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

/**
 * GET /api/v1/pengguna/gamifikasi/papan-peringkat
 * Mengembalikan papan peringkat siswa berdasarkan sekolah yang sama + posisi user saat ini.
 */
export const ambilPapanPeringkat = async (idPengguna, query) => {
  const halaman = Math.max(1, parseInt(query.halaman) || 1);
  const batas = parseInt(query.batas) || 10; // 0 = semua

  // 1. Ambil data pengguna saat ini (untuk tahu idSekolah-nya)
  const penggunaSaya = await prisma.pengguna.findUnique({
    where: { id: idPengguna },
  });
  if (!penggunaSaya) {
    const err = new Error('Pengguna tidak ditemukan.');
    err.status = 404;
    throw err;
  }

  // 2. Ambil semua siswa di sekolah yang sama, urutkan berdasarkan XP tertinggi
  const semuaSiswa = await prisma.pengguna.findMany({
    where: {
      peran: 'PENERIMA_MANFAAT',
      idSekolah: penggunaSaya.idSekolah,
    },
    include: { sekolah: true },
    orderBy: [{ poinXp: 'desc' }, { id: 'asc' }],
  });

  // 3. Tambahkan nomor peringkat & flag isUser
  const papanLengkap = semuaSiswa.map((s, idx) => ({
    rank: idx + 1,
    id_pengguna: s.id,
    nik_nisn: s.nikNisn,
    nama_lengkap: s.namaLengkap,
    tingkat_kelas: s.tingkatKelas ?? '-',
    nama_sekolah: s.sekolah?.nama ?? '-',
    poin_xp: s.poinXp ?? 0,
    dampak_kg: parseFloat(((s.dampakLingkunganGram ?? 0) / 1000).toFixed(1)),
    is_user: s.id === idPengguna,
  }));

  // 4. Posisi siswa yang sedang login
  const posisiSaya = papanLengkap.find((s) => s.is_user) ?? null;

  // 5. Hitung lencana berdasarkan statistik nyata pengguna
  const xp = penggunaSaya.poinXp ?? 0;
  const dampakGram = penggunaSaya.dampakLingkunganGram ?? 0;
  const peringkat = posisiSaya?.rank ?? 999;
  const lencana = [
    { kunci: 'piring_bersih', judul: 'Pahlawan Piring Bersih', deskripsi: 'Menyelesaikan 7 konfirmasi konsumsi MBG', terbuka: xp >= 50 },
    { kunci: 'penyelamat_pangan', judul: 'Penyelamat Pangan', deskripsi: 'Berhasil mencegah 3 kg sisa makanan', terbuka: dampakGram >= 3000 },
    { kunci: 'presensi_disiplin', judul: 'Presensi Disiplin', deskripsi: 'Konfirmasi konsumsi 5 hari tepat waktu', terbuka: xp >= 100 },
    { kunci: 'siswa_teladan', judul: 'Siswa Teladan Gizi', deskripsi: 'Masuk jajaran 15 besar siswa terbaik sekolah', terbuka: peringkat <= 15 },
    { kunci: 'sahabat_sayur', judul: 'Sahabat Sayur & Buah', deskripsi: 'Aktif mengulas menu bergizi 10 kali', terbuka: xp >= 150 },
    { kunci: 'pelestari_air', judul: 'Pelestari Air Bersih', deskripsi: 'Menghemat 200 liter air virtual pertanian', terbuka: dampakGram >= 1000 },
    { kunci: 'pejuang_karbon', judul: 'Pejuang Jejak Karbon', deskripsi: 'Mencegah 10 kg emisi CO₂ sampah organik', terbuka: dampakGram >= 5000 },
    { kunci: 'duta_gizi', judul: 'Duta Gizi Seimbang', deskripsi: 'Membantu mengulas 15 variasi menu MBG', terbuka: xp >= 200 },
    { kunci: 'bintang_komunitas', judul: 'Bintang Komunitas', deskripsi: 'Konsisten memberikan evaluasi selama 1 bulan', terbuka: xp >= 500 },
    { kunci: 'pelopor_mbg', judul: 'Pelopor MBG Indonesia', deskripsi: 'Menyelesaikan 30 hari presensi tanpa terputus', terbuka: xp >= 1000 },
  ];

  // 6. Paginasi
  const totalItem = papanLengkap.length;
  const totalHalaman = batas > 0 ? Math.ceil(totalItem / batas) : 1;
  const skip = batas > 0 ? (halaman - 1) * batas : 0;
  const papanHalaman = batas > 0 ? papanLengkap.slice(skip, skip + batas) : papanLengkap;

  return {
    posisi_saya: posisiSaya,
    lencana,
    total_item: totalItem,
    total_halaman: totalHalaman,
    halaman,
    batas,
    papan_peringkat: papanHalaman,
  };
};

/**
 * GET /api/v1/pengguna/siswa
 * Mengembalikan daftar semua siswa (hanya untuk Admin SPPG & Super Admin).
 */
export const daftarSiswaSppg = async (idPenggunaAdmin, query) => {
  const halaman = Math.max(1, parseInt(query.halaman) || 1);
  const batas = Math.min(100, parseInt(query.batas) || 20);
  const cari = query.cari ?? '';

  const admin = await prisma.pengguna.findUnique({ where: { id: idPenggunaAdmin } });

  // Super Admin melihat semua sekolah, Admin SPPG hanya sekolahnya sendiri
  const filterSekolah = admin?.peran === 'SUPER_ADMIN' ? {} : { idSekolah: admin?.idSekolah };

  const [total, siswa] = await Promise.all([
    prisma.pengguna.count({
      where: {
        peran: 'PENERIMA_MANFAAT',
        ...filterSekolah,
        ...(cari && { namaLengkap: { contains: cari } }),
      },
    }),
    prisma.pengguna.findMany({
      where: {
        peran: 'PENERIMA_MANFAAT',
        ...filterSekolah,
        ...(cari && { namaLengkap: { contains: cari } }),
      },
      include: { sekolah: true },
      orderBy: { namaLengkap: 'asc' },
      skip: (halaman - 1) * batas,
      take: batas,
    }),
  ]);

  return {
    total_item: total,
    total_halaman: Math.ceil(total / batas),
    halaman,
    batas,
    siswa: siswa.map((s) => ({
      id_pengguna: s.id,
      nik_nisn: s.nikNisn,
      nama_lengkap: s.namaLengkap,
      nama_sekolah: s.sekolah?.nama ?? '-',
      tingkat_kelas: s.tingkatKelas ?? '-',
      poin_xp: s.poinXp ?? 0,
      riwayat_alergi: s.riwayatAlergi ?? [],
      nomor_kontak: s.nomorKontak,
      peran: s.peran,
    })),
  };
};

