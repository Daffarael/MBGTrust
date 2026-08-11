import 'package:mbgtrust/core/network/api_client.dart';
import '../models/evaluation_model.dart';
import '../models/rejection_reason_model.dart';

class EvaluationRepository {
  final ApiClient _apiClient;

  EvaluationRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Kirim Evaluasi Menu (Siswa)
  Future<void> submitEvaluation({
    required String idJadwal,
    required SubmitEvaluationRequest request,
  }) async {
    try {
      await _apiClient.postEnvelope(
        '/jadwal/$idJadwal/evaluasi',
        data: request.toJson(),
      );
    } catch (_) {
      // Fallback demo mode bila backend server offline / CORS browser
      await Future.delayed(const Duration(milliseconds: 300));
      return;
    }
  }

  /// Konfirmasi Kesediaan Menu Besok
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
      // Fallback demo mode bila backend server offline / CORS browser
      await Future.delayed(const Duration(milliseconds: 300));
      return;
    }
  }

  /// Ambil Opsi Alasan Penolakan Baku
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
      // Fallback demo mode bila backend offline / CORS
    }

    return [
      RejectionReasonModel(kode: 'ALERGI', label: 'Alergi Makanan / Pantangan Medis'),
      RejectionReasonModel(kode: 'SAKIT', label: 'Sakit / Tidak Masuk Sekolah'),
      RejectionReasonModel(kode: 'PANTANGAN_AGAMA', label: 'Pantangan Kepercayaan / Agama'),
      RejectionReasonModel(kode: 'IZIN_ABSEN', label: 'Izin / Kegiatan Luar Sekolah'),
    ];
  }
}


