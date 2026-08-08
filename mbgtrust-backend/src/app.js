import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import morgan from 'morgan';
import { apiReference } from '@scalar/express-api-reference';
import penangananError from './common/errorHandler.js';

// Routers
import otentikasiRouter, { penggunaRouter } from './modules/otentikasi/otentikasi.router.js';

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

app.use(penangananError);

export default app;
