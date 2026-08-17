import { Router } from 'express';
import authGuard from '../../middlewares/authGuard.js';
import rbacGuard from '../../middlewares/rbacGuard.js';
import {
  pendaftaran,
  masuk,
  masukSppg,
  perbaruiToken,
  ambilProfil,
  perbaruiProfil,
  ambilPapanPeringkat,
  daftarSiswaSppg,
} from './otentikasi.controller.js';

const router = Router();

// [PUBLIC] — Registrasi & Login
router.post('/pendaftaran', pendaftaran);
router.post('/masuk', masuk);
router.post('/sppg/masuk', masukSppg);
router.post('/perbarui-token', perbaruiToken);

// [AUTH] — Profil Pengguna (dipasang di /pengguna via app.js)
export const penggunaRouter = Router();
penggunaRouter.get('/profil-saya', authGuard, ambilProfil);
penggunaRouter.patch('/profil-saya', authGuard, perbaruiProfil);
penggunaRouter.get('/gamifikasi/papan-peringkat', authGuard, rbacGuard('PENERIMA_MANFAAT'), ambilPapanPeringkat);
penggunaRouter.get('/siswa', authGuard, rbacGuard('SPPG_ADMIN', 'SUPER_ADMIN'), daftarSiswaSppg);

export default router;
