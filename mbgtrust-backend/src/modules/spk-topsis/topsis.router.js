import { Router } from 'express';
import authGuard from '../../middlewares/authGuard.js';
import rbacGuard from '../../middlewares/rbacGuard.js';
import {
  jalankanEksekusi,
  ambilDetailEksekusi,
  ambilRekomendasi,
} from './topsis.controller.js';

const router = Router();

// POST   /api/v1/spk/topsis/eksekusi
router.post('/topsis/eksekusi', authGuard, rbacGuard('SPPG_ADMIN'), jalankanEksekusi);

// GET    /api/v1/spk/topsis/rekomendasi  ← harus sebelum /:idEksekusi agar tidak di-overlap
router.get('/topsis/rekomendasi', authGuard, rbacGuard('SPPG_ADMIN'), ambilRekomendasi);

// GET    /api/v1/spk/topsis/eksekusi/:idEksekusi
router.get('/topsis/eksekusi/:idEksekusi', authGuard, rbacGuard('SPPG_ADMIN'), ambilDetailEksekusi);

export default router;
