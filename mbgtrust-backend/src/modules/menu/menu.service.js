import prisma from '../../config/prisma.js';

// ─── Master Menu ───────────────────────────────────────────────

export const tambahMenu = async (data) => {
  const menu = await prisma.menu.create({
    data: {
      namaMenu: data.nama_menu,
      kategori: data.kategori,
      deskripsi: data.deskripsi,
      kaloriKkal: data.kalori_kkal,
      proteinGram: data.protein_gram,
      karbohidratGram: data.karbohidrat_gram,
      lemakGram: data.lemak_gram,
      komposisiBahan: data.komposisi_bahan ?? [],
      potensiAlergen: data.potensi_alergen ?? [],
      estimasiHargaPerPorsi: data.estimasi_biaya_per_porsi,
    },
  });

  return { id_menu: menu.id, nama_menu: menu.namaMenu };
};

export const ambilDaftarMenu = async ({ halaman = 1, batas = 10, cari }) => {
  const lewati = (halaman - 1) * batas;
  const where = cari
    ? { namaMenu: { contains: cari } }
    : {};

  const [data, total] = await prisma.$transaction([
    prisma.menu.findMany({
      where,
      skip: lewati,
      take: batas,
      orderBy: { dibuatPada: 'desc' },
      select: {
        id: true,
        namaMenu: true,
        kategori: true,
        kaloriKkal: true,
        estimasiHargaPerPorsi: true,
      },
    }),
    prisma.menu.count({ where }),
  ]);

  return {
    data: data.map((m) => ({
      id_menu: m.id,
      nama_menu: m.namaMenu,
      kategori: m.kategori,
      kalori_kkal: m.kaloriKkal,
      estimasi_biaya_per_porsi: m.estimasiHargaPerPorsi,
    })),
    meta: {
      halaman,
      batas,
      total_item: total,
      total_halaman: Math.ceil(total / batas),
    },
  };
};

export const ambilDetailMenu = async (idMenu) => {
  const menu = await prisma.menu.findUnique({ where: { id: idMenu } });
  if (!menu) {
    const err = new Error('Menu tidak ditemukan.');
    err.status = 404;
    throw err;
  }

  return {
    id_menu: menu.id,
    nama_menu: menu.namaMenu,
    kategori: menu.kategori,
    deskripsi: menu.deskripsi,
    kalori_kkal: menu.kaloriKkal,
    protein_gram: menu.proteinGram,
    karbohidrat_gram: menu.karbohidratGram,
    lemak_gram: menu.lemakGram,
    komposisi_bahan: menu.komposisiBahan,
    potensi_alergen: menu.potensiAlergen,
    estimasi_biaya_per_porsi: menu.estimasiHargaPerPorsi,
    gambar_url: menu.gambarUrl,
  };
};

export const perbaruiMenu = async (idMenu, data) => {
  const ada = await prisma.menu.findUnique({ where: { id: idMenu } });
  if (!ada) {
    const err = new Error('Menu tidak ditemukan.');
    err.status = 404;
    throw err;
  }

  const menu = await prisma.menu.update({
    where: { id: idMenu },
    data: {
      ...(data.nama_menu && { namaMenu: data.nama_menu }),
      ...(data.kategori && { kategori: data.kategori }),
      ...(data.deskripsi !== undefined && { deskripsi: data.deskripsi }),
      ...(data.kalori_kkal !== undefined && { kaloriKkal: data.kalori_kkal }),
      ...(data.protein_gram !== undefined && { proteinGram: data.protein_gram }),
      ...(data.karbohidrat_gram !== undefined && { karbohidratGram: data.karbohidrat_gram }),
      ...(data.lemak_gram !== undefined && { lemakGram: data.lemak_gram }),
      ...(data.komposisi_bahan !== undefined && { komposisiBahan: data.komposisi_bahan }),
      ...(data.potensi_alergen !== undefined && { potensiAlergen: data.potensi_alergen }),
      ...(data.estimasi_biaya_per_porsi !== undefined && { estimasiHargaPerPorsi: data.estimasi_biaya_per_porsi }),
    },
  });

  return { id_menu: menu.id, nama_menu: menu.namaMenu };
};

// ─── Jadwal Menu ───────────────────────────────────────────────

export const plottingJadwal = async (data) => {
  const menu = await prisma.menu.findUnique({ where: { id: data.id_menu } });
  if (!menu) {
    const err = new Error('Menu tidak ditemukan.');
    err.status = 404;
    throw err;
  }

  const sekolah = await prisma.sekolah.findUnique({ where: { id: data.id_sekolah } });
  if (!sekolah) {
    const err = new Error('Sekolah tidak ditemukan.');
    err.status = 404;
    throw err;
  }

  const tanggal = new Date(data.tanggal_jadwal);

  // Cek apakah jadwal untuk sekolah+tanggal ini sudah ada (UNIQUE constraint)
  const sudahAda = await prisma.jadwalMenu.findUnique({
    where: { idSekolah_tanggal: { idSekolah: data.id_sekolah, tanggal } },
  });
  if (sudahAda) {
    const err = new Error(`Jadwal untuk sekolah ini pada tanggal ${data.tanggal_jadwal} sudah ada.`);
    err.status = 409;
    throw err;
  }

  const jadwal = await prisma.jadwalMenu.create({
    data: {
      idMenu: data.id_menu,
      idSekolah: data.id_sekolah,
      tanggal,
      targetTotalPorsi: data.target_total_porsi,
    },
  });

  return {
    id_jadwal: String(jadwal.id),
    tanggal_jadwal: jadwal.tanggal.toISOString().split('T')[0],
  };
};

export const ambilJadwalHariIni = async (idSekolah, idPengguna) => {
  const hari = new Date();
  hari.setHours(0, 0, 0, 0);

  const jadwal = await prisma.jadwalMenu.findUnique({
    where: { idSekolah_tanggal: { idSekolah, tanggal: hari } },
    include: {
      menu: {
        select: { id: true, namaMenu: true, kaloriKkal: true },
      },
      evaluasiMenu: idPengguna
        ? { where: { idPengguna }, select: { id: true } }
        : false,
    },
  });

  if (!jadwal) {
    const err = new Error('Belum ada jadwal menu untuk hari ini.');
    err.status = 404;
    throw err;
  }

  return {
    id_jadwal: String(jadwal.id),
    tanggal_jadwal: jadwal.tanggal.toISOString().split('T')[0],
    menu: {
      id_menu: String(jadwal.menu.id),
      nama_menu: jadwal.menu.namaMenu,
      kalori_kkal: jadwal.menu.kaloriKkal,
    },
    status_evaluasi_pengguna: {
      sudah_evaluasi: idPengguna ? jadwal.evaluasiMenu.length > 0 : null,
    },
  };
};

export const ambilJadwalBesok = async (idSekolah, idPengguna) => {
  const besok = new Date();
  besok.setDate(besok.getDate() + 1);
  besok.setHours(0, 0, 0, 0);

  const jadwal = await prisma.jadwalMenu.findUnique({
    where: { idSekolah_tanggal: { idSekolah, tanggal: besok } },
    include: {
      menu: {
        select: { id: true, namaMenu: true, kaloriKkal: true },
      },
      konfirmasi: idPengguna
        ? { where: { idPengguna }, select: { id: true, status: true } }
        : false,
    },
  });

  if (!jadwal) {
    const err = new Error('Belum ada jadwal menu untuk besok.');
    err.status = 404;
    throw err;
  }

  const konfirmasi = idPengguna && jadwal.konfirmasi?.length > 0 ? jadwal.konfirmasi[0] : null;

  return {
    id_jadwal: String(jadwal.id),
    tanggal_jadwal: jadwal.tanggal.toISOString().split('T')[0],
    menu: {
      id_menu: String(jadwal.menu.id),
      nama_menu: jadwal.menu.namaMenu,
      kalori_kkal: jadwal.menu.kaloriKkal,
    },
    status_konfirmasi_pengguna: {
      sudah_konfirmasi: idPengguna ? konfirmasi !== null : null,
      status_kehadiran: konfirmasi?.status ?? null,
    },
  };
};
