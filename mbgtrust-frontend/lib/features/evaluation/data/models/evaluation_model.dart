/// Request Payload untuk Umpan Balik / Evaluasi Menu oleh Penerima Manfaat
class SubmitEvaluationRequest {
  final bool menerimaPorsi;
  final int penilaianRasa; // 1-5
  final int penilaianKesukaan; // 1-5
  final int penilaianPorsi; // 1-5
  final double persentaseSisaMakanan; // 0 - 100
  final String masukanKualitatif;

  SubmitEvaluationRequest({
    required this.menerimaPorsi,
    required this.penilaianRasa,
    required this.penilaianKesukaan,
    required this.penilaianPorsi,
    required this.persentaseSisaMakanan,
    required this.masukanKualitatif,
  });

  Map<String, dynamic> toJson() {
    return {
      'menerima_porsi': menerimaPorsi,
      'penilaian_rasa': penilaianRasa,
      'penilaian_kesukaan': penilaianKesukaan,
      'penilaian_porsi': penilaianPorsi,
      'persentase_sisa_makanan': persentaseSisaMakanan,
      'masukan_kualitatif': masukanKualitatif,
    };
  }
}

/// Request Payload untuk Konfirmasi Presensi H+1
class ConfirmPresenceRequest {
  final String statusKehadiran; // HADIR, MENOLAK
  final String? kodeAlasanPenolakan; // ALERGI, SAKIT, PANTANGAN_AGAMA, IZIN_ABSEN
  final String? catatanKhusus;

  ConfirmPresenceRequest({
    required this.statusKehadiran,
    this.kodeAlasanPenolakan,
    this.catatanKhusus,
  });

  Map<String, dynamic> toJson() {
    return {
      'status_kehadiran': statusKehadiran,
      if (kodeAlasanPenolakan != null)
        'kode_alasan_penolakan': kodeAlasanPenolakan,
      if (catatanKhusus != null) 'catatan_khusus': catatanKhusus,
    };
  }
}
