import { Router } from 'express';
import authGuard from '../../middlewares/authGuard.js';
import {
  pendaftaran,
  masuk,
  masukSppg,
  perbaruiToken,
  ambilProfil,
  perbaruiProfil,
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

export default router;
