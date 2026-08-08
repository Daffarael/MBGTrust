import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../models/production_plan_model.dart';

class ProductionRepository {
  final ApiClient _apiClient;

  ProductionRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Endpoint 4.1: Rekapitulasi Presisi Porsi Produksi H+1
  Future<ProductionPlanModel> getDailyProductionPlan(String tanggal) async {
    final envelope = await _apiClient.getEnvelope<ProductionPlanModel>(
      '/rencana-produksi/harian',
      queryParameters: {'tanggal': tanggal},
      fromJsonT: (json) => ProductionPlanModel.fromJson(json as Map<String, dynamic>),
    );

    if (envelope.data != null) return envelope.data!;
    throw ApiErrorEnvelope(
      sukses: false,
      kodeStatus: envelope.kodeStatus,
      pesan: envelope.pesan,
    );
  }

  /// Endpoint 4.2: Hitung Ulang Estimasi Produksi
  Future<int> recalculateProductionEstimate(String tanggalTarget) async {
    final envelope = await _apiClient.postEnvelope<Map<String, dynamic>>(
      '/rencana-produksi/harian/hitung',
      data: {'tanggal_target': tanggalTarget},
      fromJsonT: (json) => json as Map<String, dynamic>,
    );

    return envelope.data?['porsi_presisi_terbaru'] as int? ?? 0;
  }

  /// Endpoint 5.1: Ambil Daftar Siklus Produksi Aktif Hari Ini
  Future<List<ActiveProductionModel>> getActiveProductionCycles() async {
    final envelope = await _apiClient.getEnvelope<List<ActiveProductionModel>>(
      '/produksi/aktif',
      fromJsonT: (json) {
        var rawList = json as List<dynamic>? ?? [];
        return rawList
            .map((e) => ActiveProductionModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );

    return envelope.data ?? [];
  }

  /// Endpoint 5.2: Update Status Memasak Produksi
  Future<void> updateProductionStatus({
    required String idProduksi,
    required String statusProduksi, // MEMASAK, PERSIAPAN, SELESAI_PACKING
  }) async {
    await _apiClient.patchEnvelope(
      '/produksi/$idProduksi/status',
      data: {'status_produksi': statusProduksi},
    );
  }

  /// Endpoint 5.3: Update Status Pengiriman Armada Distribusi
  Future<void> updateDistributionStatus({
    required String idDistribusi,
    required String statusDistribusi, // DALAM_PERJALANAN, TIBA_DI_SEKOLAH, TERBAGIKAN
    String? waktuTiba,
  }) async {
    await _apiClient.patchEnvelope(
      '/distribusi/$idDistribusi/status',
      data: {
        'status_distribusi': statusDistribusi,
        'waktu_tiba': ?waktuTiba,
      },
    );
  }
}
