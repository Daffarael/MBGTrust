/// Item Peringkat SPK TOPSIS
class TopsisRankItem {
  final int peringkat;
  final int idMenu;
  final String namaMenu;
  final double skorPreferensiV;
  final String rekomendasi; // DIPERTAHANKAN, DIEVALUASI, DIGANTI
  final String? analisisAi; // Narasi Gemini 2.0 Flash

  TopsisRankItem({
    required this.peringkat,
    required this.idMenu,
    required this.namaMenu,
    required this.skorPreferensiV,
    required this.rekomendasi,
    this.analisisAi,
  });

  factory TopsisRankItem.fromJson(Map<String, dynamic> json) {
    return TopsisRankItem(
      peringkat: json['peringkat'] as int? ?? 1,
      idMenu: (json['id_menu'] as num?)?.toInt() ?? 0,
      namaMenu: json['nama_menu'] as String? ?? '',
      skorPreferensiV:
          (json['skor_preferensi_v'] as num?)?.toDouble() ?? 0.0,
      rekomendasi: json['rekomendasi'] as String? ?? 'DIPERTAHANKAN',
      analisisAi: json['analisis_ai'] as String?,
    );
  }
}

/// Respon Hasil Kalkulasi TOPSIS (Modul 6 API Contract)
class TopsisExecutionModel {
  final int idEksekusi;
  final List<TopsisRankItem> peringkatMenu;

  TopsisExecutionModel({
    required this.idEksekusi,
    required this.peringkatMenu,
  });

  factory TopsisExecutionModel.fromJson(Map<String, dynamic> json) {
    var rawRank = json['peringkat_menu'] as List<dynamic>? ?? [];

    return TopsisExecutionModel(
      idEksekusi: (json['id_eksekusi'] as num?)?.toInt() ?? 0,
      peringkatMenu: rawRank.map((e) => TopsisRankItem.fromJson(e)).toList(),
    );
  }
}

/// Rekomendasi Kebijakan Menu Otomatis
class TopsisRecommendationModel {
  final List<TopsisRankItem> menuDipertahankan;
  final List<TopsisRankItem> menuDievaluasi;
  final List<TopsisRankItem> menuDiganti;

  TopsisRecommendationModel({
    this.menuDipertahankan = const [],
    this.menuDievaluasi = const [],
    this.menuDiganti = const [],
  });

  factory TopsisRecommendationModel.fromJson(Map<String, dynamic> json) {
    var rawMaintain = json['menu_dipertahankan'] as List<dynamic>? ?? [];
    var rawEval = json['menu_dievaluasi'] as List<dynamic>? ?? [];
    var rawReplace = json['menu_diganti'] as List<dynamic>? ?? [];

    return TopsisRecommendationModel(
      menuDipertahankan:
          rawMaintain.map((e) => TopsisRankItem.fromJson(e)).toList(),
      menuDievaluasi: rawEval.map((e) => TopsisRankItem.fromJson(e)).toList(),
      menuDiganti: rawReplace.map((e) => TopsisRankItem.fromJson(e)).toList(),
    );
  }
}
