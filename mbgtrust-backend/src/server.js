import './config/prisma.js'; // dotenv dimuat via 'dotenv/config' di dalam prisma.js
import app from './app.js';
import logger from './common/logger.js';

const PORT = process.env.PORT || 3000;

app.listen(PORT, '0.0.0.0', () => {
  logger.info(`[SERVER] MBGTrust Backend berjalan di port ${PORT}`);
});

process.on('uncaughtException', (err) => {
  logger.error('Uncaught Exception:', err);
  process.exit(1);
});
process.on('unhandledRejection', (reason, promise) => {
  logger.error('Unhandled Rejection at:', promise, 'reason:', reason);
  process.exit(1);
});
