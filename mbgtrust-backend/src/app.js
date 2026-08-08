import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import morgan from 'morgan';
import { apiReference } from '@scalar/express-api-reference';
import penangananError from './common/errorHandler.js';

// Routers
import otentikasiRouter, { penggunaRouter } from './modules/otentikasi/otentikasi.router.js';
import menuRouter, { jadwalRouter } from './modules/menu/menu.router.js';
import { evaluasiJadwalRouter, alasanPenolakanRouter } from './modules/evaluasi/evaluasi.router.js';
import { rencanaProduksiRouter, produksiRouter, distribusiRouter } from './modules/produksi/produksi.router.js';
import spkRouter from './modules/spk-topsis/topsis.router.js';
import { analitikRouter, laporanRouter } from './modules/analitik/analitik.router.js';

const app = express();

app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(morgan('dev'));
app.use(rateLimit({ windowMs: 15 * 60 * 1000, max: 100 }));

// Health Check
app.get('/health', (req, res) => {
  res.status(200).json({ sukses: true, pesan: 'MBGTrust Backend aktif.' });
});

// Dokumentasi API via Scalar
app.use('/docs', apiReference({ url: '/openapi.json' }));

// API v1 — Modul 1: Otentikasi & Pengguna
app.use('/api/v1/otentikasi', otentikasiRouter);
app.use('/api/v1/pengguna', penggunaRouter);

// API v1 — Modul 2: Menu & Jadwal
app.use('/api/v1/menu', menuRouter);
app.use('/api/v1/jadwal', jadwalRouter);
app.use('/api/v1/jadwal/:idJadwal', evaluasiJadwalRouter);

// API v1 — Modul 3: Evaluasi, Konfirmasi & Alasan Penolakan
app.use('/api/v1/alasan-penolakan', alasanPenolakanRouter);

// API v1 — Modul 4 & 5: Produksi, Rencana Produksi & Distribusi
app.use('/api/v1/rencana-produksi', rencanaProduksiRouter);
app.use('/api/v1/produksi', produksiRouter);
app.use('/api/v1/distribusi', distribusiRouter);

// API v1 — Modul 6: SPK TOPSIS Engine
app.use('/api/v1/spk', spkRouter);

// API v1 — Modul 7: Analitik Dasbor & Laporan Audit
app.use('/api/v1/analitik', analitikRouter);
app.use('/api/v1/laporan', laporanRouter);

app.use(penangananError);

export default app;
