import './config/prisma.js'; // dotenv dimuat via 'dotenv/config' di dalam prisma.js
import app from './app.js';
import logger from './common/logger.js';

const PORT = process.env.PORT || 3000;

app.listen(PORT, '0.0.0.0', () => {
  logger.info(`[SERVER] MBGTrust Backend berjalan di port ${PORT}`);
});
