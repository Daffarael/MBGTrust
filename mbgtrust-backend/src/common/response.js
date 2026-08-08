const kirimRespon = (res, statusKode, sukses, pesan, data = null, meta = null) => {
  const respon = { sukses, kode_status: statusKode, pesan };
  if (data !== null) respon.data = data;
  if (meta !== null) respon.meta = meta;
  return res.status(statusKode).json(respon);
};

export const responBerhasil = (res, pesan, data = null, statusKode = 200, meta = null) =>
  kirimRespon(res, statusKode, true, pesan, data, meta);

export const responGagal = (res, pesan, statusKode = 400, kesalahan = null) => {
  const respon = {
    sukses: false,
    kode_status: statusKode,
    pesan,
    stempel_waktu: new Date().toISOString(),
  };
  if (kesalahan) respon.kesalahan = kesalahan;
  return res.status(statusKode).json(respon);
};
