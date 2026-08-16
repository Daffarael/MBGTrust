/**
 * NLP Sentiment Analysis & Keyword Extraction Service
 * Bahasa Indonesia Lexicon-based NLP Engine for Food Quality & MBG Reviews
 */

const STOPWORDS = new Set([
  'dan', 'di', 'ke', 'dari', 'yang', 'ini', 'itu', 'untuk', 'pada', 'adalah',
  'saya', 'kami', 'kita', 'dia', 'mereka', 'dengan', 'atau', 'karena', 'jika',
  'kalau', 'maka', 'tapi', 'tetapi', 'namun', 'juga', 'sudah', 'telah', 'akan',
  'bisa', 'dapat', 'ada', 'hanya', 'sangat', 'sekali', 'banget', 'amat', 'lagi',
  'jadi', 'terus', 'kok', 'sih', 'dong', 'deh', 'ya', 'kan', 'nih', 'tuh',
  'makanan', 'menu', 'hari', 'makan', 'nya', 'yg', 'dgn', 'kalo', 'tp', 'bgt'
]);

const POSITIVE_LEXICON = new Set([
  'enak', 'lezat', 'gurih', 'nikmat', 'mantap', 'sedap', 'segar', 'bersih',
  'kenyang', 'pas', 'suka', 'wangi', 'empuk', 'renyah', 'higienis', 'hangat',
  'puas', 'bagus', 'top', 'juara', 'mantul', 'komplit', 'bergizi', 'sehat',
  'banyak', 'cukup', 'enak banget', 'suka banget', 'mantap betul'
]);

const NEGATIVE_LEXICON = new Set([
  'hambar', 'asin', 'keasinan', 'pahit', 'basi', 'asam', 'masam', 'bau',
  'amis', 'alot', 'keras', 'mentah', 'dingin', 'berminyak', 'sedikit', 'kurang',
  'pelit', 'kotor', 'enek', 'eneg', 'mual', 'kecewa', 'tumpah', 'gosong',
  'lembek', 'pedas', 'kepedasan', 'lalat', 'rambut', 'busuk', 'tengik'
]);

const NEGATION_WORDS = new Set(['tidak', 'bukan', 'ga', 'gak', 'nggak', 'kurang', 'tak']);

/**
 * Analisis sentimen dari ulasan teks siswa
 * @param {string} teks
 * @returns {{ sentimen: 'POSITIF'|'NEGATIF'|'NETRAL', skorSentimen: number, kataKunci: string[] }}
 */
export const analisaSentimenUlasan = (teks) => {
  if (!teks || typeof teks !== 'string' || teks.trim().length === 0) {
    return {
      sentimen: 'NETRAL',
      skorSentimen: 0.5,
      kataKunci: [],
    };
  }

  const teksBersih = teks.toLowerCase().replace(/[^a-z0-9\s]/g, ' ');
  const tokens = teksBersih.split(/\s+/).filter(Boolean);

  let skorPositif = 0;
  let skorNegatif = 0;
  let isNegasi = false;

  const kataKunciMap = new Map();

  for (let i = 0; i < tokens.length; i++) {
    const kata = tokens[i];

    // Ekstraksi kata kunci (bukan stopword dan panjang >= 3)
    if (!STOPWORDS.has(kata) && kata.length >= 3) {
      kataKunciMap.set(kata, (kataKunciMap.get(kata) || 0) + 1);
    }

    if (NEGATION_WORDS.has(kata)) {
      isNegasi = true;
      continue;
    }

    // Cek frasa positif / kata positif
    if (POSITIVE_LEXICON.has(kata)) {
      if (isNegasi) {
        skorNegatif += 1.5; // "tidak enak" -> negatif
      } else {
        skorPositif += 1.0;
      }
      isNegasi = false;
      continue;
    }

    // Cek frasa negatif / kata negatif
    if (NEGATIVE_LEXICON.has(kata)) {
      if (isNegasi) {
        skorPositif += 0.8; // "tidak hambar" / "tidak amis" -> sedikit positif
      } else {
        skorNegatif += 1.2;
      }
      isNegasi = false;
      continue;
    }

    // Reset negasi jika jarak sudah > 2 token
    isNegasi = false;
  }

  // Urutkan kata kunci terbanyak
  const kataKunci = Array.from(kataKunciMap.entries())
    .sort((a, b) => b[1] - a[1])
    .map((entry) => entry[0])
    .slice(0, 5);

  const totalSkor = skorPositif + skorNegatif;
  let sentimen = 'NETRAL';
  let skorSentimen = 0.5;

  if (totalSkor > 0) {
    const rasioPositif = skorPositif / totalSkor;
    if (rasioPositif >= 0.6) {
      sentimen = 'POSITIF';
      skorSentimen = Math.min(0.95, Math.round((0.5 + rasioPositif * 0.5) * 100) / 100);
    } else if (rasioPositif <= 0.4) {
      sentimen = 'NEGATIF';
      skorSentimen = Math.max(0.05, Math.round((1 - rasioPositif) * 100) / 100);
    } else {
      sentimen = 'NETRAL';
      skorSentimen = 0.5;
    }
  }

  return {
    sentimen,
    skorSentimen,
    kataKunci,
  };
};
