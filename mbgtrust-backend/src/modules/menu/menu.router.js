import { Router } from 'express';
import authGuard from '../../middlewares/authGuard.js';
import rbacGuard from '../../middlewares/rbacGuard.js';
import {
  tambahMenu,
  ambilDaftarMenu,
  ambilDetailMenu,
  perbaruiMenu,
  plottingJadwal,
  ambilJadwalHariIni,
  ambilJadwalBesok,
} from './menu.controller.js';

const router = Router();

// ─── Master Menu (/api/v1/menu) ────────────────────────────────
router.post('/', authGuard, rbacGuard('SPPG_ADMIN'), tambahMenu);
router.get('/', authGuard, ambilDaftarMenu);
router.get('/:idMenu', authGuard, ambilDetailMenu);
router.patch('/:idMenu', authGuard, rbacGuard('SPPG_ADMIN'), perbaruiMenu);

// ─── Jadwal Menu (/api/v1/jadwal) ──────────────────────────────
export const jadwalRouter = Router();
jadwalRouter.post('/', authGuard, rbacGuard('SPPG_ADMIN'), plottingJadwal);
jadwalRouter.get('/hari-ini', authGuard, ambilJadwalHariIni);
jadwalRouter.get('/besok', authGuard, ambilJadwalBesok);

export default router;
