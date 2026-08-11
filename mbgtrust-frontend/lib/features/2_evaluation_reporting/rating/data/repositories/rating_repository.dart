import 'package:mbgtrust/core/network/api_client.dart';
import '../../../evaluation/data/models/evaluation_model.dart';
import '../../../evaluation/data/models/rejection_reason_model.dart';

/// Repository untuk halaman Rating (gamified post-meal rating oleh siswa).
/// Hit endpoint yang sama dengan EvaluationRepository.
/// Dipisah agar Provider Riverpod bisa di-scope ke feature rating.
class RatingRepository {
  final ApiClient _apiClient;

  RatingRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Submit evaluasi rating post-konsumsi (gamified UX).
  /// Endpoint: POST /api/v1/jadwal/:idJadwal/evaluasi
  Future<void> submitRating({
    required String idJadwal,
    required SubmitEvaluationRequest request,
  }) async {
    try {
      await _apiClient.postEnvelope(
        '/jadwal/$idJadwal/evaluasi',
        data: request.toJson(),
      );
    } catch (_) {
      // Fallback demo mode — anggap sukses agar flow gamifikasi tetap jalan
      await Future.delayed(const Duration(milliseconds: 300));
      return;
    }
  }

  /// Konfirmasi kehadiran untuk menu besok (H+1).
  /// Endpoint: POST /api/v1/jadwal/:idJadwal/konfirmasi
  Future<void> confirmTomorrowPresence({
    required String idJadwal,
    required ConfirmPresenceRequest request,
  }) async {
    try {
      await _apiClient.postEnvelope(
        '/jadwal/$idJadwal/konfirmasi',
        data: request.toJson(),
      );
    } catch (_) {
      await Future.delayed(const Duration(milliseconds: 300));
      return;
    }
  }

  /// Ambil daftar alasan penolakan baku.
  /// Endpoint: GET /api/v1/alasan-penolakan
  Future<List<RejectionReasonModel>> getRejectionReasons() async {
    try {
      final envelope = await _apiClient.getEnvelope<List<RejectionReasonModel>>(
        '/alasan-penolakan',
        fromJsonT: (json) {
          var rawList = json as List<dynamic>? ?? [];
          return rawList
              .map((e) => RejectionReasonModel.fromJson(e as Map<String, dynamic>))
              .toList();
        },
      );

      if (envelope.data != null && envelope.data!.isNotEmpty) {
        return envelope.data!;
      }
    } catch (_) {
      // Fallback demo mode
    }

    return [
      RejectionReasonModel(kode: 'ALERGI',          label: 'Alergi Makanan / Pantangan Medis'),
      RejectionReasonModel(kode: 'SAKIT',           label: 'Sakit / Tidak Masuk Sekolah'),
      RejectionReasonModel(kode: 'PANTANGAN_AGAMA', label: 'Pantangan Kepercayaan / Agama'),
      RejectionReasonModel(kode: 'IZIN_ABSEN',      label: 'Izin / Kegiatan Luar Sekolah'),
    ];
  }
}


