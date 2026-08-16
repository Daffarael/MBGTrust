import prisma from '../../config/prisma.js';

// Berat default per porsi untuk kalkulasi food waste tercegah (standar program MBG)
const BERAT_PORSI_GRAM = 300;

const parsePeriode = (tanggalMulai, tanggalSelesai) => {
  const tglMulai = new Date(tanggalMulai);
  const tglSelesai = new Date(tanggalSelesai);
  tglSelesai.setHours(23, 59, 59, 999);
  return { tglMulai, tglSelesai };
};

// ─── 7.1 Ringkasan Dasbor ──────────────────────────────────────

export const ambilRingkasanDasbor = async (tanggalMulai, tanggalSelesai) => {
  const { tglMulai, tglSelesai } = parsePeriode(tanggalMulai, tanggalSelesai);

  // Ambil semua jadwal dalam rentang
  const jadwalList = await prisma.jadwalMenu.findMany({
    where: { tanggal: { gte: tglMulai, lte: tglSelesai } },
    include: {
      evaluasiMenu:    { select: { penilaianRasa: true, tingkatKesukaan: true, kesesuaianPorsi: true, persentaseDikonsumsi: true, menerimaPorsi: true } },
      konfirmasi:  { select: { status: true } },
      rencanaProduksi: { select: { estimasiPorsi: true } },
    },
  });

  // ── C1: Skor kepuasan keseluruhan (rata-rata penilaian_rasa) ─
  const semuaRasa = jadwalList.flatMap((j) => j.evaluasiMenu.map((e) => e.penilaianRasa)).filter(Boolean);
  const skorKepuasan = semuaRasa.length === 0
    ? 0
    : Math.round((semuaRasa.reduce((s, v) => s + v, 0) / semuaRasa.length) * 100) / 100;

  // ── Tingkat penerimaan (% evaluasi dengan menerima_porsi = true) ─
  const semuaEvaluasi = jadwalList.flatMap((j) => j.evaluasiMenu);
  const totalEvaluasi = semuaEvaluasi.length;
  const totalMenerima = semuaEvaluasi.filter((e) => e.menerimaPorsi === true).length;
  const persentasePenerimaan = totalEvaluasi === 0
    ? 0
    : Math.round((totalMenerima / totalEvaluasi) * 1000) / 10;

  // ── Food waste tercegah: (porsi_dasar - porsi_presisi) × avg_sisa% × 300g ─
  // Porsi yang tidak dimasak karena presisi = porsi yang dicegah menjadi sampah
  let totalPorsiDasar = 0;
  let totalPorsiPresisi = 0;

  for (const jadwal of jadwalList) {
    totalPorsiDasar    += jadwal.targetTotalPorsi ?? 0;
    totalPorsiPresisi  += jadwal.rencanaProduksi?.estimasiPorsi ?? 0;
  }

  const porsiTercegah = Math.max(0, totalPorsiDasar - totalPorsiPresisi);
  const semuaSisa = jadwalList.flatMap((j) => j.evaluasiMenu.map((e) => e.persentaseDikonsumsi)).filter(Boolean);
  const rataRataSisa = semuaSisa.length === 0 ? 0 : semuaSisa.reduce((s, v) => s + v, 0) / semuaSisa.length;

  // kg = porsi_tercegah × (rata_sisa% / 100) × berat_porsi_gram / 1000
  const foodWasteTercegahKg = Math.round(
    porsiTercegah * (rataRataSisa / 100) * BERAT_PORSI_GRAM / 1000 * 100
  ) / 100;

  // ── Efisiensi anggaran: porsi_tercegah × harga_per_porsi ─
  const menuIds = [...new Set(jadwalList.map((j) => j.idMenu))];
  const menuData = await prisma.menu.findMany({
    where: { id: { in: menuIds } },
    select: { id: true, estimasiHargaPerPorsi: true },
  });

  const hargaRataRata = menuData.length === 0
    ? 0
    : menuData.reduce((s, m) => s + (m.estimasiHargaPerPorsi ?? 0), 0) / menuData.length;

  const estimasiEfisiensiAnggaran = Math.round(porsiTercegah * hargaRataRata);

  return {
    periode: { tanggal_mulai: tanggalMulai, tanggal_selesai: tanggalSelesai },
    skor_kepuasan_keseluruhan: skorKepuasan,
    persentase_tingkat_penerimaan_menu: persentasePenerimaan,
    food_waste_tercegah_kg: foodWasteTercegahKg,
    estimasi_efisiensi_anggaran_rupiah: estimasiEfisiensiAnggaran,
    catatan: 'food_waste_tercegah_kg dihitung dengan asumsi berat rata-rata 300g per porsi',
  };
};

// ─── Data laporan (dipakai oleh PDF & Excel generator) ─────────

export const ambilDataLaporan = async (tanggalMulai, tanggalSelesai) => {
  const { tglMulai, tglSelesai } = parsePeriode(tanggalMulai, tanggalSelesai);

  const ringkasan = await ambilRingkasanDasbor(tanggalMulai, tanggalSelesai);

  const jadwalList = await prisma.jadwalMenu.findMany({
    where: { tanggal: { gte: tglMulai, lte: tglSelesai } },
    include: {
      menu:         { select: { namaMenu: true, kategori: true } },
      evaluasiMenu: {
        select: {
          penilaianRasa: true,
          tingkatKesukaan: true,
          kesesuaianPorsi: true,
          persentaseDikonsumsi: true,
          menerimaPorsi: true,
        },
      },
      konfirmasi:   { select: { status: true } },
      rencanaProduksi: { select: { estimasiPorsi: true } },
    },
    orderBy: { tanggal: 'asc' },
  });

  const detailMenu = jadwalList.map((jadwal) => {
    const evalList = jadwal.evaluasiMenu;
    const konfList = jadwal.konfirmasi;
    const rata = (arr) => arr.length === 0 ? 0 : Math.round(arr.reduce((s, v) => s + v, 0) / arr.length * 100) / 100;

    return {
      tanggal: jadwal.tanggal.toISOString().split('T')[0],
      nama_menu: jadwal.menu.namaMenu,
      kategori: jadwal.menu.kategori,
      target_porsi: jadwal.targetTotalPorsi,
      estimasi_porsi: jadwal.rencanaProduksi?.estimasiPorsi ?? '-',
      total_evaluasi: evalList.length,
      rata_rasa: rata(evalList.map((e) => e.penilaianRasa).filter(Boolean)),
      rata_kesukaan: rata(evalList.map((e) => e.tingkatKesukaan).filter(Boolean)),
      rata_porsi: rata(evalList.map((e) => e.kesesuaianPorsi).filter(Boolean)),
      rata_sisa_persen: rata(evalList.map((e) => e.persentaseDikonsumsi).filter(Boolean)),
      total_hadir: konfList.filter((k) => k.status === 'HADIR').length,
      total_tidak_hadir: konfList.filter((k) => k.status === 'TIDAK_HADIR').length,
    };
  });

  return { ringkasan, detailMenu };
};
