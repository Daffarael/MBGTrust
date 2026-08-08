import { Router } from 'express';
import authGuard from '../../middlewares/authGuard.js';
import rbacGuard from '../../middlewares/rbacGuard.js';
import {
  rekapitulasiHarian,
  hitungUlangEstimasi,
  ambilProduksiAktif,
  updateStatusProduksi,
  updateStatusDistribusi,
} from './produksi.controller.js';

// ─── /api/v1/rencana-produksi ──────────────────────────────────
export const rencanaProduksiRouter = Router();
rencanaProduksiRouter.get('/harian', authGuard, rbacGuard('SPPG_ADMIN'), rekapitulasiHarian);
rencanaProduksiRouter.post('/harian/hitung', authGuard, rbacGuard('SPPG_ADMIN'), hitungUlangEstimasi);

// ─── /api/v1/produksi ──────────────────────────────────────────
export const produksiRouter = Router();
produksiRouter.get('/aktif', authGuard, rbacGuard('SPPG_ADMIN'), ambilProduksiAktif);
produksiRouter.patch('/:idProduksi/status', authGuard, rbacGuard('SPPG_ADMIN'), updateStatusProduksi);

// ─── /api/v1/distribusi ────────────────────────────────────────
export const distribusiRouter = Router();
// 5.3: bisa diakses SPPG_ADMIN dan PETUGAS
distribusiRouter.patch('/:idDistribusi/status', authGuard, rbacGuard('SPPG_ADMIN', 'PETUGAS'), updateStatusDistribusi);
