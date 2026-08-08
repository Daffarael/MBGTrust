import prisma from '../../config/prisma.js';

const BUFFER_DEFAULT = 5.0;

// ─── Helpers ───────────────────────────────────────────────────

const parseTanggal = (str) => {
  const d = new Date(str);
  d.setHours(0, 0, 0, 0);
  return d;
};

// ─── Modul 4: Rencana Produksi ─────────────────────────────────

export const rekapitulasiHarian = async (tanggal) => {
  const tgl = parseTanggal(tanggal);

  const jadwalList = await prisma.jadwalMenu.findMany({
    where: { tanggal: tgl },
    include: {
      rencanaProduksi: true,
      konfirmasi: { select: { status: true } },
    },
  });

  if (jadwalList.length === 0) {
    const err = new Error('Tidak ada jadwal menu untuk tanggal tersebut.');
    err.status = 404;
    throw err;
  }

  let totalPorsiDasar = 0;
  let totalHadir = 0;
  let totalTidakHadir = 0;
  let totalPresisi = 0;

  for (const jadwal of jadwalList) {
    totalPorsiDasar += jadwal.targetTotalPorsi ?? 0;
    totalHadir += jadwal.konfirmasi.filter((k) => k.status === 'HADIR').length;
    totalTidakHadir += jadwal.konfirmasi.filter((k) => k.status === 'TIDAK_HADIR').length;
    totalPresisi += jadwal.rencanaProduksi?.estimasiPorsi ?? 0;
  }

  return {
    tanggal_target: tanggal,
    total_porsi_dasar: totalPorsiDasar,
    total_siswa_konfirmasi_hadir: totalHadir,
    total_siswa_menolak: totalTidakHadir,
    total_porsi_presisi_wajib_dimasak: totalPresisi,
  };
};

export const hitungUlangEstimasi = async (tanggalTarget) => {
  const tgl = parseTanggal(tanggalTarget);

  const jadwalList = await prisma.jadwalMenu.findMany({
    where: { tanggal: tgl },
    include: {
      konfirmasi: { select: { status: true } },
    },
  });

  if (jadwalList.length === 0) {
    const err = new Error('Tidak ada jadwal menu untuk tanggal tersebut.');
    err.status = 404;
    throw err;
  }

  let totalEstimasi = 0;

  for (const jadwal of jadwalList) {
    const totalHadir = jadwal.konfirmasi.filter((k) => k.status === 'HADIR').length;
    const totalTidakHadir = jadwal.konfirmasi.filter((k) => k.status === 'TIDAK_HADIR').length;
    const estimasi = Math.ceil(totalHadir * (1 + BUFFER_DEFAULT / 100));

    await prisma.rencanaProduksi.upsert({
      where: { idJadwal: jadwal.id },
      update: {
        estimasiPorsi: estimasi,
        totalHadir,
        totalTidakHadir,
        bufferPersentase: BUFFER_DEFAULT,
      },
      create: {
        idJadwal: jadwal.id,
        estimasiPorsi: estimasi,
        totalHadir,
        totalTidakHadir,
        bufferPersentase: BUFFER_DEFAULT,
      },
    });

    totalEstimasi += estimasi;
  }

  return { porsi_presisi_terbaru: totalEstimasi };
};

// ─── Modul 5: Produksi ─────────────────────────────────────────

export const ambilProduksiAktif = async () => {
  const hari = new Date();
  hari.setHours(0, 0, 0, 0);

  const data = await prisma.produksi.findMany({
    where: {
      jadwalMenu: { tanggal: hari },
      status: { not: 'DIBATALKAN' },
    },
    include: {
      jadwalMenu: {
        include: { menu: { select: { namaMenu: true } } },
      },
    },
    orderBy: { dibuatPada: 'asc' },
  });

  return data.map((p) => ({
    id_produksi: p.id,
    nama_menu: p.jadwalMenu.menu.namaMenu,
    status_produksi: p.status,
    total_porsi_dimasak: p.jumlahDimasak,
    catatan_dapur: p.catatanDapur,
  }));
};

export const updateStatusProduksi = async (idProduksi, data) => {
  const ada = await prisma.produksi.findUnique({ where: { id: idProduksi } });
  if (!ada) {
    const err = new Error('Data produksi tidak ditemukan.');
    err.status = 404;
    throw err;
  }

  const produksi = await prisma.produksi.update({
    where: { id: idProduksi },
    data: {
      status: data.status_produksi,
      ...(data.jumlah_dimasak !== undefined && { jumlahDimasak: data.jumlah_dimasak }),
      ...(data.catatan_dapur !== undefined && { catatanDapur: data.catatan_dapur }),
    },
  });

  return { id_produksi: produksi.id, status_produksi: produksi.status };
};

// ─── Modul 5: Distribusi ───────────────────────────────────────

export const updateStatusDistribusi = async (idDistribusi, data) => {
  const ada = await prisma.distribusi.findUnique({ where: { id: idDistribusi } });
  if (!ada) {
    const err = new Error('Data distribusi tidak ditemukan.');
    err.status = 404;
    throw err;
  }

  const distribusi = await prisma.distribusi.update({
    where: { id: idDistribusi },
    data: {
      status: data.status_distribusi,
      catatanKurir: data.catatan_kurir,
      waktuTiba:
        data.status_distribusi === 'TIBA_DI_SEKOLAH'
          ? data.waktu_tiba
            ? new Date(data.waktu_tiba)
            : new Date()
          : undefined,
    },
  });

  return { id_distribusi: distribusi.id, status_distribusi: distribusi.status };
};
