import logger from './logger.js';

const penangananError = (err, req, res, next) => {
  const statusKode = err.status || 500;
  logger.error(`${statusKode} - ${err.message} - ${req.originalUrl}`);
  res.status(statusKode).json({
    sukses: false,
    kode_status: statusKode,
    pesan: err.message || 'Terjadi kesalahan pada server.',
    stempel_waktu: new Date().toISOString(),
  });
};

export default penangananError;
