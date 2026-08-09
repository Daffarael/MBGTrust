import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../models/topsis_model.dart';

class SppgRepository {
  final ApiClient _apiClient;

  SppgRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Endpoint 6.1: Eksekusi Perhitungan SPK TOPSIS
  Future<TopsisExecutionModel> executeTopsis({
    required String tanggalMulai,
    required String tanggalSelesai,
    required List<int> daftarIdMenu,
  }) async {
    final envelope = await _apiClient.postEnvelope<TopsisExecutionModel>(
      '/spk/topsis/eksekusi',
      data: {
        'tanggal_mulai': tanggalMulai,
        'tanggal_selesai': tanggalSelesai,
        'daftar_id_menu': daftarIdMenu,
      },
      fromJsonT: (json) => TopsisExecutionModel.fromJson(json as Map<String, dynamic>),
    );

    if (envelope.data != null) return envelope.data!;
    throw ApiErrorEnvelope(
      sukses: false,
      kodeStatus: envelope.kodeStatus,
      pesan: envelope.pesan,
    );
  }

  /// Endpoint 6.3: Ambil Daftar Rekomendasi Kebijakan Menu Otomatis
  Future<TopsisRecommendationModel> getMenuRecommendations() async {
    final envelope = await _apiClient.getEnvelope<TopsisRecommendationModel>(
      '/spk/topsis/rekomendasi',
      fromJsonT: (json) =>
          TopsisRecommendationModel.fromJson(json as Map<String, dynamic>),
    );

    return envelope.data ?? TopsisRecommendationModel();
  }

  /// Endpoint 7.1: Ambil Metrik Ringkasan Dasbor
  Future<Map<String, dynamic>> getDashboardMetrics({
    required String tanggalMulai,
    required String tanggalSelesai,
  }) async {
    final envelope = await _apiClient.getEnvelope<Map<String, dynamic>>(
      '/analitik/ringkasan-dasbor',
      queryParameters: {
        'tanggal_mulai': tanggalMulai,
        'tanggal_selesai': tanggalSelesai,
      },
      fromJsonT: (json) => json as Map<String, dynamic>,
    );

    return envelope.data ?? {};
  }
}
