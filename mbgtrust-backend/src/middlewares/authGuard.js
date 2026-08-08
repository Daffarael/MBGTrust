import jwt from 'jsonwebtoken';
import { jwtConfig } from '../config/jwt.js';
import { responGagal } from '../common/response.js';

const authGuard = (req, res, next) => {
  const header = req.headers.authorization;
  if (!header || !header.startsWith('Bearer ')) {
    return responGagal(res, 'Token otentikasi tidak ditemukan.', 401);
  }

  const token = header.split(' ')[1];
  try {
    const payload = jwt.verify(token, jwtConfig.accessSecret);
    req.pengguna = payload;
    next();
  } catch {
    return responGagal(res, 'Token tidak valid atau sudah kedaluwarsa.', 401);
  }
};

export default authGuard;
