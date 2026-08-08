import prisma from '../../config/prisma.js';

const XP_PER_EVALUASI = 50;

// ─── Helpers ───────────────────────────────────────────────────

const cekJadwalAda = async (idJadwal) => {
  const jadwal = await prisma.jadwalMenu.findUnique({ where: { id: idJadwal } });
  if (!jadwal) {
    const err = new Error('Jadwal tidak ditemukan.');
    err.status = 404;
    throw err;
  }
  return jadwal;
};

// ─── Evaluasi Siswa ────────────────────────────────────────────

export const kirimEvaluasiSiswa = async (idJadwal, idPengguna, data) => {
  await cekJadwalAda(idJadwal);

  const sudahEvaluasi = await prisma.evaluasiMenu.findUnique({
    where: { idPengguna_idJadwal: { idPengguna, idJadwal } },
  });
  if (sudahEvaluasi) {
    const err = new Error('Kamu sudah mengirim evaluasi untuk jadwal ini.');
    err.status = 409;
    throw err;
  }

  const [evaluasi] = await prisma.$transaction([
    prisma.evaluasiMenu.create({
      data: {
        idPengguna,
        idJadwal,
        menerimaPorsi: data.menerima_porsi,
        penilaianRasa: data.penilaian_rasa,
        tingkatKesukaan: data.tingkat_kesukaan,
        kesesuaianPorsi: data.kesesuaian_porsi,
        persentaseSisa: data.persentase_sisa_makanan,
        masukanKualitatif: data.masukan_kualitatif,
      },
    }),
    prisma.pengguna.update({
      where: { id: idPengguna },
      data: { poinXp: { increment: XP_PER_EVALUASI } },
    }),
  ]);

  return { id_evaluasi: evaluasi.id, xp_diperoleh: XP_PER_EVALUASI };
};

// ─── Evaluasi Kolektif (Petugas) ───────────────────────────────

export const kirimEvaluasiKolektif = async (idJadwal, data) => {
  await cekJadwalAda(idJadwal);

  let berhasil = 0;
  let gagal = 0;

  for (const item of data.daftar_evaluasi) {
    const pengguna = await prisma.pengguna.findUnique({
      where: { nikNisn: item.nisn_siswa },
    });
    if (!pengguna) { gagal++; continue; }

    const sudahAda = await prisma.evaluasiMenu.findUnique({
      where: { idPengguna_idJadwal: { idPengguna: pengguna.id, idJadwal } },
    });
    if (sudahAda) { gagal++; continue; }

    await prisma.$transaction([
      prisma.evaluasiMenu.create({
        data: {
          idPengguna: pengguna.id,
          idJadwal,
          menerimaPorsi: item.menerima_porsi,
          penilaianRasa: item.penilaian_rasa,
          tingkatKesukaan: item.tingkat_kesukaan,
          kesesuaianPorsi: item.kesesuaian_porsi,
          persentaseSisa: item.persentase_sisa_makanan,
        },
      }),
      prisma.pengguna.update({
        where: { id: pengguna.id },
        data: { poinXp: { increment: XP_PER_EVALUASI } },
      }),
    ]);
    berhasil++;
  }

  return { jumlah_data_berhasil: berhasil, jumlah_data_gagal: gagal };
};

// ─── Konfirmasi Kehadiran H+1 ──────────────────────────────────

export const kirimKonfirmasi = async (idJadwal, idPengguna, data) => {
  await cekJadwalAda(idJadwal);

  let idAlasanPenolakan = null;
  if (data.kode_alasan_penolakan) {
    const alasan = await prisma.alasanPenolakan.findUnique({
      where: { kode: data.kode_alasan_penolakan },
    });
    if (!alasan) {
      const err = new Error(`Kode alasan penolakan '${data.kode_alasan_penolakan}' tidak ditemukan.`);
      err.status = 404;
      throw err;
    }
    idAlasanPenolakan = alasan.id;
  }

  const konfirmasi = await prisma.konfirmasi.upsert({
    where: { idPengguna_idJadwal: { idPengguna, idJadwal } },
    update: {
      status: data.status_kehadiran,
      idAlasanPenolakan,
      catatanKhusus: data.catatan_khusus,
    },
    create: {
      idPengguna,
      idJadwal,
      status: data.status_kehadiran,
      idAlasanPenolakan,
      catatanKhusus: data.catatan_khusus,
    },
  });

  return {
    id_konfirmasi: konfirmasi.id,
    status_kehadiran: konfirmasi.status,
  };
};

// ─── Daftar Alasan Penolakan ───────────────────────────────────

export const ambilAlasanPenolakan = async () => {
  const data = await prisma.alasanPenolakan.findMany({
    orderBy: { id: 'asc' },
  });
  return data.map((a) => ({ id: a.id, kode: a.kode, label: a.label }));
};
