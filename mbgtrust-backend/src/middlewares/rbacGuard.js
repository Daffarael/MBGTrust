import { responGagal } from '../common/response.js';

const rbacGuard = (...peranDiizinkan) => {
  return (req, res, next) => {
    if (!req.pengguna) {
      return responGagal(res, 'Akses tidak diizinkan.', 403);
    }
    if (!peranDiizinkan.includes(req.pengguna.peran)) {
      return responGagal(
        res,
        `Akses ditolak. Hanya untuk: ${peranDiizinkan.join(', ')}.`,
        403
      );
    }
    next();
  };
};

export default rbacGuard;
