import { Router } from 'express';
import authGuard from '../../middlewares/authGuard.js';
import rbacGuard from '../../middlewares/rbacGuard.js';
import { ringkasanDasbor, unduhLaporan } from './analitik.controller.js';

export const analitikRouter = Router();
// GET /api/v1/analitik/ringkasan-dasbor
analitikRouter.get('/ringkasan-dasbor', authGuard, rbacGuard('SPPG_ADMIN'), ringkasanDasbor);

export const laporanRouter = Router();
// GET /api/v1/laporan/unduh
laporanRouter.get('/unduh', authGuard, rbacGuard('SPPG_ADMIN'), unduhLaporan);
