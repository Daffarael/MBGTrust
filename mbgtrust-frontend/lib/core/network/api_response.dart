/// Model Amplop Respon Berhasil Global (Global Success Envelope)
class ApiResponseEnvelope<T> {
  final bool sukses;
  final int kodeStatus;
  final String pesan;
  final T? data;
  final ApiMeta? meta;

  ApiResponseEnvelope({
    required this.sukses,
    required this.kodeStatus,
    required this.pesan,
    this.data,
    this.meta,
  });

  factory ApiResponseEnvelope.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic jsonData)? fromJsonT,
  ) {
    return ApiResponseEnvelope<T>(
      sukses: json['sukses'] as bool? ?? false,
      kodeStatus: json['kode_status'] as int? ?? 200,
      pesan: json['pesan'] as String? ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : (json['data'] as T?),
      meta: json['meta'] != null ? ApiMeta.fromJson(json['meta']) : null,
    );
  }
}

/// Metadata untuk respon berhalaman (pagination)
class ApiMeta {
  final int halaman;
  final int batas;
  final int totalItem;
  final int totalHalaman;

  ApiMeta({
    required this.halaman,
    required this.batas,
    required this.totalItem,
    required this.totalHalaman,
  });

  factory ApiMeta.fromJson(Map<String, dynamic> json) {
    return ApiMeta(
      halaman: json['halaman'] as int? ?? 1,
      batas: json['batas'] as int? ?? 10,
      totalItem: json['total_item'] as int? ?? 0,
      totalHalaman: json['total_halaman'] as int? ?? 1,
    );
  }
}

/// Rincian Kesalahan Validasi Input
class ApiFieldError {
  final String bidang;
  final String pesan;

  ApiFieldError({
    required this.bidang,
    required this.pesan,
  });

  factory ApiFieldError.fromJson(Map<String, dynamic> json) {
    return ApiFieldError(
      bidang: json['bidang'] as String? ?? '',
      pesan: json['pesan'] as String? ?? '',
    );
  }
}

/// Model Amplop Respon Gagal Global (Global Error Envelope)
class ApiErrorEnvelope implements Exception {
  final bool sukses;
  final int kodeStatus;
  final String pesan;
  final List<ApiFieldError> kesalahan;
  final String? stempelWaktu;

  ApiErrorEnvelope({
    required this.sukses,
    required this.kodeStatus,
    required this.pesan,
    this.kesalahan = const [],
    this.stempelWaktu,
  });

  factory ApiErrorEnvelope.fromJson(Map<String, dynamic> json) {
    var rawErrors = json['kesalahan'] as List<dynamic>? ?? [];
    List<ApiFieldError> errorList =
        rawErrors.map((e) => ApiFieldError.fromJson(e)).toList();

    return ApiErrorEnvelope(
      sukses: json['sukses'] as bool? ?? false,
      kodeStatus: json['kode_status'] as int? ?? 400,
      pesan: json['pesan'] as String? ?? 'Terjadi kesalahan pada permintaan.',
      kesalahan: errorList,
      stempelWaktu: json['stempel_waktu'] as String?,
    );
  }

  @override
  String toString() => '$pesan ($kodeStatus)';
}
