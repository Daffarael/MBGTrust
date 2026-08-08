export const jwtConfig = {
  accessSecret: process.env.JWT_ACCESS_SECRET,
  refreshSecret: process.env.JWT_REFRESH_SECRET,
  accessExpiresIn: '1d',
  refreshExpiresIn: '7d',
  accessExpiresInSeconds: 86400,
};
