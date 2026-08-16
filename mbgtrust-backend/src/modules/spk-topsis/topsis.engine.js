/**
 * TOPSIS Engine — Pure Mathematical Functions
 *
 * Kriteria & Bobot (Σw = 1.0) — All Benefit:
 *   C1 penilaian_rasa           benefit  w=0.20
 *   C2 tingkat_kesukaan         benefit  w=0.15
 *   C3 kesesuaian_porsi         benefit  w=0.10
 *   C4 tingkat_konsumsi_makanan benefit  w=0.30 (persentase makanan dihabiskan)
 *   C5 tingkat_penerimaan_mbg   benefit  w=0.25 (rasio konfirmasi hadir)
 */

export const BOBOT = [0.20, 0.15, 0.10, 0.30, 0.25];
export const SIFAT = ['benefit', 'benefit', 'benefit', 'benefit', 'benefit'];

const AMBANG_DIPERTAHANKAN = 0.6;
const AMBANG_DIEVALUASI   = 0.4;

// Langkah 1: Normalisasi matriks — r_ij = x_ij / sqrt(Σ x_ij²)
export const normalisasiMatriks = (matriks) => {
  const n = matriks.length;
  const m = BOBOT.length;
  const penyebut = Array.from({ length: m }, (_, j) =>
    Math.sqrt(matriks.reduce((sum, baris) => sum + baris[j] ** 2, 0))
  );

  return matriks.map((baris) =>
    baris.map((x, j) => (penyebut[j] === 0 ? 0 : x / penyebut[j]))
  );
};

// Langkah 2: Matriks terbobot — v_ij = w_j × r_ij
export const bobotkanMatriks = (rNorm) =>
  rNorm.map((baris) => baris.map((r, j) => BOBOT[j] * r));

// Langkah 3: Solusi ideal A+ dan A-
export const hitungSolusiIdeal = (vBobotkan) => {
  const m = BOBOT.length;
  const aPlus  = [];
  const aMinus = [];

  for (let j = 0; j < m; j++) {
    const kolom = vBobotkan.map((b) => b[j]);
    if (SIFAT[j] === 'benefit') {
      aPlus.push(Math.max(...kolom));
      aMinus.push(Math.min(...kolom));
    } else {
      aPlus.push(Math.min(...kolom));
      aMinus.push(Math.max(...kolom));
    }
  }
  return { aPlus, aMinus };
};

// Langkah 4: Jarak ke solusi ideal — D_i+ dan D_i-
export const hitungJarak = (vBobotkan, aPlus, aMinus) =>
  vBobotkan.map((baris) => ({
    dPlus : Math.sqrt(baris.reduce((s, v, j) => s + (v - aPlus[j])  ** 2, 0)),
    dMinus: Math.sqrt(baris.reduce((s, v, j) => s + (v - aMinus[j]) ** 2, 0)),
  }));

// Langkah 5: Skor preferensi — V_i = D_i- / (D_i+ + D_i-)
export const hitungSkorPreferensi = (jarak) =>
  jarak.map(({ dPlus, dMinus }) => {
    const total = dPlus + dMinus;
    return total === 0 ? 0 : dMinus / total;
  });

// Langkah 6: Mapper rekomendasi
export const tentukannRekomendasi = (skor) => {
  if (skor >= AMBANG_DIPERTAHANKAN) return 'DIPERTAHANKAN';
  if (skor >= AMBANG_DIEVALUASI)   return 'DIEVALUASI';
  return 'DIGANTI';
};

// Fungsi utama: jalankan seluruh pipeline TOPSIS
export const eksekusiTopsis = (alternatif) => {
  // alternatif: Array<{ id_menu, nama_menu, c1, c2, c3, c4, c5 }>
  const matriks = alternatif.map((a) => [a.c1, a.c2, a.c3, a.c4, a.c5]);

  const rNorm     = normalisasiMatriks(matriks);
  const vBobotkan = bobotkanMatriks(rNorm);
  const { aPlus, aMinus } = hitungSolusiIdeal(vBobotkan);
  const jarak     = hitungJarak(vBobotkan, aPlus, aMinus);
  const skorV     = hitungSkorPreferensi(jarak);

  const peringkatMenu = alternatif
    .map((a, i) => ({
      id_menu:           a.id_menu,
      nama_menu:         a.nama_menu,
      skor_preferensi_v: Math.round(skorV[i] * 10000) / 10000,
      rekomendasi:       tentukannRekomendasi(skorV[i]),
      _d_plus:           jarak[i].dPlus,
      _d_minus:          jarak[i].dMinus,
    }))
    .sort((a, b) => b.skor_preferensi_v - a.skor_preferensi_v)
    .map((item, idx) => ({ ...item, peringkat: idx + 1 }));

  const hasilJson = {
    bobot:                  BOBOT,
    sifat_kriteria:         SIFAT,
    matriks_keputusan:      matriks,
    matriks_ternormalisasi: rNorm,
    matriks_terbobot:       vBobotkan,
    solusi_ideal_positif:   aPlus,
    solusi_ideal_negatif:   aMinus,
    jarak_positif:          jarak.map((j) => j.dPlus),
    jarak_negatif:          jarak.map((j) => j.dMinus),
    skor_preferensi:        skorV,
  };

  const rekomendasiJson = peringkatMenu.map(({ _d_plus, _d_minus, ...rest }) => rest);

  return { hasilJson, rekomendasiJson };
};
