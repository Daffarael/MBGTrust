import prisma from '../../config/prisma.js';
import { eksekusiTopsis } from './topsis.engine.js';

// ─── Helpers ───────────────────────────────────────────────────

const avgAtauNol = (arr) => (arr.length === 0 ? 0 : arr.reduce((s, v) => s + v, 0) / arr.length);

// Ambil data agregat per menu pada rentang tanggal
const ambilDataAlternatif = async (idMenu, tanggalMulai, tanggalSelesai) => {
  const menu = await prisma.menu.findUnique({
    where: { id: idMenu },
    select: { id: true, namaMenu: true },
  });
  if (!menu) return null;

  const tglMulai = new Date(tanggalMulai);
  const tglSelesai = new Date(tanggalSelesai);
  tglSelesai.setHours(23, 59, 59, 999);

  // Ambil semua jadwal menu ini dalam rentang tanggal
  const jadwalList = await prisma.jadwalMenu.findMany({
    where: {
      idMenu,
      tanggal: { gte: tglMulai, lte: tglSelesai },
    },
    select: { id: true },
  });

  if (jadwalList.length === 0) return null;
  const idJadwalList = jadwalList.map((j) => j.id);

  // C1–C4 dari evaluasi_menu
  const evaluasi = await prisma.evaluasiMenu.findMany({
    where: { idJadwal: { in: idJadwalList } },
    select: {
      penilaianRasa:    true,
      tingkatKesukaan:  true,
      kesesuaianPorsi:  true,
      persentaseSisa:   true,
    },
  });

  const c1 = avgAtauNol(evaluasi.filter((e) => e.penilaianRasa   !== null).map((e) => e.penilaianRasa));
  const c2 = avgAtauNol(evaluasi.filter((e) => e.tingkatKesukaan !== null).map((e) => e.tingkatKesukaan));
  const c3 = avgAtauNol(evaluasi.filter((e) => e.kesesuaianPorsi !== null).map((e) => e.kesesuaianPorsi));
  const c4 = avgAtauNol(evaluasi.filter((e) => e.persentaseSisa  !== null).map((e) => e.persentaseSisa));

  // C5 dari konfirmasi: % TIDAK_HADIR dari total konfirmasi per jadwal
  const konfirmasi = await prisma.konfirmasi.findMany({
    where: { idJadwal: { in: idJadwalList } },
    select: { status: true },
  });
  const totalKonfirmasi = konfirmasi.length;
  const totalTidakHadir = konfirmasi.filter((k) => k.status === 'TIDAK_HADIR').length;
  const c5 = totalKonfirmasi === 0 ? 0 : (totalTidakHadir / totalKonfirmasi) * 100;

  return { id_menu: menu.id, nama_menu: menu.namaMenu, c1, c2, c3, c4, c5 };
};

// ─── 6.1 Eksekusi TOPSIS ───────────────────────────────────────

export const jalankanEksekusi = async ({ tanggal_mulai, tanggal_selesai, daftar_id_menu }) => {
  const alternatifRaw = await Promise.all(
    daftar_id_menu.map((id) => ambilDataAlternatif(id, tanggal_mulai, tanggal_selesai))
  );

  const alternatif = alternatifRaw.filter(Boolean);

  if (alternatif.length < 2) {
    const err = new Error('Data evaluasi tidak cukup — minimal 2 menu memiliki data evaluasi dalam rentang tanggal ini.');
    err.status = 422;
    throw err;
  }

  const { hasilJson, rekomendasiJson } = eksekusiTopsis(alternatif);

  const eksekusi = await prisma.eksekusiTopsis.create({
    data: {
      periodeAwal:    new Date(tanggal_mulai),
      periodeAkhir:   new Date(tanggal_selesai),
      hasilJson,
      rekomendasiJson,
    },
  });

  return {
    id_eksekusi: eksekusi.id,
    peringkat_menu: rekomendasiJson.map(({ id_menu, nama_menu, skor_preferensi_v, rekomendasi, peringkat }) => ({
      peringkat,
      id_menu,
      nama_menu,
      skor_preferensi_v,
      rekomendasi,
    })),
  };
};

// ─── 6.2 Detail Matriks ────────────────────────────────────────

export const ambilDetailEksekusi = async (idEksekusi) => {
  const eksekusi = await prisma.eksekusiTopsis.findUnique({ where: { id: idEksekusi } });
  if (!eksekusi) {
    const err = new Error('Data eksekusi TOPSIS tidak ditemukan.');
    err.status = 404;
    throw err;
  }

  const hasil = eksekusi.hasilJson;
  return {
    id_eksekusi:                eksekusi.id,
    periode_awal:               eksekusi.periodeAwal.toISOString().split('T')[0],
    periode_akhir:              eksekusi.periodeAkhir.toISOString().split('T')[0],
    bobot_kriteria:             hasil.bobot,
    sifat_kriteria:             hasil.sifat_kriteria,
    solusi_ideal_positif_A_plus:  hasil.solusi_ideal_positif,
    solusi_ideal_negatif_A_minus: hasil.solusi_ideal_negatif,
    skor_preferensi:            hasil.skor_preferensi,
    peringkat_menu:             eksekusi.rekomendasiJson,
  };
};

// ─── 6.3 Rekomendasi Terbaru ───────────────────────────────────

export const ambilRekomendasi = async () => {
  const eksekusi = await prisma.eksekusiTopsis.findFirst({
    orderBy: { dibuatPada: 'desc' },
    select: { id: true, periodeAwal: true, periodeAkhir: true, rekomendasiJson: true },
  });

  if (!eksekusi) {
    const err = new Error('Belum ada eksekusi TOPSIS yang tersimpan.');
    err.status = 404;
    throw err;
  }

  const semua = eksekusi.rekomendasiJson;
  return {
    id_eksekusi:        eksekusi.id,
    periode_awal:       eksekusi.periodeAwal.toISOString().split('T')[0],
    periode_akhir:      eksekusi.periodeAkhir.toISOString().split('T')[0],
    menu_dipertahankan: semua.filter((m) => m.rekomendasi === 'DIPERTAHANKAN'),
    menu_dievaluasi:    semua.filter((m) => m.rekomendasi === 'DIEVALUASI'),
    menu_diganti:       semua.filter((m) => m.rekomendasi === 'DIGANTI'),
  };
};
