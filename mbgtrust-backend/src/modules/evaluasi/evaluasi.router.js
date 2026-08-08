import { Router } from 'express';
import authGuard from '../../middlewares/authGuard.js';
import rbacGuard from '../../middlewares/rbacGuard.js';
import {
  kirimEvaluasiSiswa,
  kirimEvaluasiKolektif,
  kirimKonfirmasi,
  ambilAlasanPenolakan,
} from './evaluasi.controller.js';

// ─── Route /api/v1/jadwal/:idJadwal/... ────────────────────────
// (di-merge ke jadwalRouter di app.js)
export const evaluasiJadwalRouter = Router({ mergeParams: true });
evaluasiJadwalRouter.post('/evaluasi', authGuard, rbacGuard('PENERIMA_MANFAAT'), kirimEvaluasiSiswa);
evaluasiJadwalRouter.post('/evaluasi-kolektif', authGuard, rbacGuard('PETUGAS'), kirimEvaluasiKolektif);
evaluasiJadwalRouter.post('/konfirmasi', authGuard, rbacGuard('PENERIMA_MANFAAT'), kirimKonfirmasi);

// ─── Route /api/v1/alasan-penolakan ────────────────────────────
export const alasanPenolakanRouter = Router();
alasanPenolakanRouter.get('/', authGuard, ambilAlasanPenolakan);
