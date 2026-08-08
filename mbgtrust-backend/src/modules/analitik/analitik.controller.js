import { responBerhasil, responGagal } from '../../common/response.js';
import { ambilRingkasanDasbor, ambilDataLaporan } from './analitik.service.js';
import { buatLaporanPdf, buatLaporanExcel } from './laporan.generator.js';

const validasiPeriode = (tanggalMulai, tanggalSelesai) => {
  if (!tanggalMulai || !tanggalSelesai) return 'Query parameter tanggal_mulai dan tanggal_selesai wajib diisi.';
  if (!/^\d{4}-\d{2}-\d{2}$/.test(tanggalMulai) || !/^\d{4}-\d{2}-\d{2}$/.test(tanggalSelesai))
    return 'Format tanggal harus YYYY-MM-DD.';
  if (new Date(tanggalMulai) > new Date(tanggalSelesai))
    return 'tanggal_mulai tidak boleh setelah tanggal_selesai.';
  return null;
};

export const ringkasanDasbor = async (req, res, next) => {
  try {
    const { tanggal_mulai, tanggal_selesai } = req.query;
    const pesanError = validasiPeriode(tanggal_mulai, tanggal_selesai);
    if (pesanError) return responGagal(res, pesanError, 400);

    const hasil = await ambilRingkasanDasbor(tanggal_mulai, tanggal_selesai);
    return responBerhasil(res, 'Metrik ringkasan analitik berhasil diambil.', hasil);
  } catch (err) {
    next(err);
  }
};

export const unduhLaporan = async (req, res, next) => {
  try {
    const { format = 'pdf', tanggal_mulai, tanggal_selesai } = req.query;
    const pesanError = validasiPeriode(tanggal_mulai, tanggal_selesai);
    if (pesanError) return responGagal(res, pesanError, 400);
    if (!['pdf', 'excel'].includes(format)) return responGagal(res, 'Format laporan harus pdf atau excel.', 400);

    const data = await ambilDataLaporan(tanggal_mulai, tanggal_selesai);

    if (format === 'pdf') {
      return buatLaporanPdf(res, data);
    } else {
      return await buatLaporanExcel(res, data);
    }
  } catch (err) {
    next(err);
  }
};
