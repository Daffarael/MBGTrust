/// Model Alasan Penolakan Menu Baku dari API (GET /api/v1/alasan-penolakan)
class RejectionReasonModel {
  final String kode;
  final String label;

  RejectionReasonModel({
    required this.kode,
    required this.label,
  });

  factory RejectionReasonModel.fromJson(Map<String, dynamic> json) {
    return RejectionReasonModel(
      kode: json['kode'] as String? ?? '',
      label: json['label'] as String? ?? '',
    );
  }
}
