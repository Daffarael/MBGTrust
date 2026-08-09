/**
 * AI Service — Fase 6 MBGTrust
 * Wrapper Gemini 2.0 Flash untuk generate narasi rekomendasi menu.
 *
 * Pola: Generate-once, Cache-forever
 * AI dipanggil 1 kali saat eksekusi TOPSIS → hasilnya disimpan permanen di DB.
 * Semua pembacaan selanjutnya ambil dari DB (0 AI call).
 */

import { GoogleGenerativeAI } from '@google/generative-ai';

const TIMEOUT_MS = 15_000; // 15 detik timeout untuk Gemini call

// ──────────────────────────────────────────────
// Inisialisasi Gemini Client (lazy — hanya jika API key ada)
// ──────────────────────────────────────────────
let genAI = null;

const getGenAI = () => {
  if (!genAI) {
    const apiKey = process.env.GEMINI_API_KEY;
    if (!apiKey) throw new Error('GEMINI_API_KEY tidak ditemukan di environment.');
    genAI = new GoogleGenerativeAI(apiKey);
  }
  return genAI;
};

// ──────────────────────────────────────────────
// Fallback rule-based (jika Gemini gagal/timeout)
// ──────────────────────────────────────────────
const generateNarasiFallback = (item) => {
  const persen = Math.round(item.skor_preferensi_v * 100);
  switch (item.rekomendasi) {
    case 'DIPERTAHANKAN':
      return `Menu "${item.nama_menu}" meraih skor preferensi ${persen}% — tertinggi dalam periode ini. Tingkat penerimaan siswa sangat baik dengan sisa makanan minimal. Direkomendasikan untuk tetap dijadwalkan secara rutin.`;
    case 'DIEVALUASI':
      return `Menu "${item.nama_menu}" meraih skor preferensi ${persen}%. Terdapat indikasi sisa makanan di atas rata-rata atau tingkat kesukaan yang perlu ditingkatkan. Disarankan untuk mengevaluasi resep, porsi, atau waktu penyajian.`;
    case 'DIGANTI':
      return `Menu "${item.nama_menu}" meraih skor preferensi ${persen}% — terendah dalam periode ini. Tingkat penolakan siswa cukup tinggi. Disarankan untuk mengganti menu ini dengan alternatif yang lebih sesuai selera dan kebutuhan gizi siswa.`;
    default:
      return `Menu "${item.nama_menu}" telah dianalisis dengan skor preferensi ${persen}%.`;
  }
};

// ──────────────────────────────────────────────
// Build prompt untuk Gemini
// ──────────────────────────────────────────────
const buildPrompt = (rekomendasiList) => {
  const ringkasan = rekomendasiList
    .map((item, i) =>
      `${i + 1}. "${item.nama_menu}" — Label: ${item.rekomendasi}, Skor Preferensi: ${Math.round(item.skor_preferensi_v * 100)}%, Peringkat: ${item.peringkat}`
    )
    .join('\n');

  return `Kamu adalah asisten analisis gizi untuk program Makan Bergizi Gratis (MBG) Indonesia.

Berikut hasil analisis TOPSIS (Technique for Order of Preference by Similarity to Ideal Solution) untuk ${rekomendasiList.length} menu sekolah:

${ringkasan}

Tugas kamu: Buat narasi singkat (1–2 kalimat, maks 200 karakter) per menu dalam Bahasa Indonesia yang profesional dan informatif. Jelaskan alasan label rekomendasi berdasarkan skor preferensi dan peringkat.

Kembalikan HANYA array JSON dengan format berikut, tanpa teks tambahan apapun:
[
  { "id_menu": <number>, "analisis_ai": "<narasi singkat>" },
  ...
]`;
};

// ──────────────────────────────────────────────
// Main: generateNarasi(rekomendasiList)
// rekomendasiList: Array<{ id_menu, nama_menu, skor_preferensi_v, rekomendasi, peringkat }>
// Returns: Map<id_menu, narasi_string>
// ──────────────────────────────────────────────
export const generateNarasi = async (rekomendasiList) => {
  // Jika tidak ada API key, langsung fallback
  if (!process.env.GEMINI_API_KEY) {
    console.warn('[AI Service] GEMINI_API_KEY tidak ada — menggunakan fallback rule-based.');
    return buildFallbackMap(rekomendasiList);
  }

  try {
    const model = getGenAI().getGenerativeModel({ model: 'gemini-2.0-flash' });
    const prompt = buildPrompt(rekomendasiList);

    // Timeout wrapper
    const responseText = await Promise.race([
      model.generateContent(prompt).then((r) => r.response.text()),
      new Promise((_, reject) =>
        setTimeout(() => reject(new Error('Gemini timeout setelah 15 detik')), TIMEOUT_MS)
      ),
    ]);

    // Parse JSON response dari Gemini
    // Gemini kadang tambahkan ```json ... ``` — bersihkan dulu
    const cleaned = responseText.replace(/```json\n?/g, '').replace(/```\n?/g, '').trim();
    const parsed = JSON.parse(cleaned);

    // Build map id_menu → analisis_ai
    const narasiMap = new Map();
    for (const item of parsed) {
      if (item.id_menu && item.analisis_ai) {
        narasiMap.set(item.id_menu, String(item.analisis_ai).slice(0, 500));
      }
    }

    // Isi fallback untuk menu yang tidak ada di response Gemini
    for (const item of rekomendasiList) {
      if (!narasiMap.has(item.id_menu)) {
        narasiMap.set(item.id_menu, generateNarasiFallback(item));
      }
    }

    console.log(`[AI Service] ✓ Narasi AI berhasil digenerate untuk ${narasiMap.size} menu.`);
    return narasiMap;
  } catch (err) {
    console.error('[AI Service] Gemini gagal, menggunakan fallback rule-based.', err.message);
    return buildFallbackMap(rekomendasiList);
  }
};

const buildFallbackMap = (rekomendasiList) => {
  const map = new Map();
  for (const item of rekomendasiList) {
    map.set(item.id_menu, generateNarasiFallback(item));
  }
  return map;
};
