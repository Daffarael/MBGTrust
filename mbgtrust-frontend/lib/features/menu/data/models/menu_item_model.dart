/// Model Data Master Menu MBG
class MenuItemModel {
  final String idMenu;
  final String namaMenu;
  final String kategori; // MAKANAN_BERAT, CAMILAN, SUPLEMEN
  final int kaloriKkal;
  final double proteinGram;
  final double karbohidratGram;
  final double lemakGram;
  final List<String> komposisiBahan;
  final List<String> potensiAlergen;
  final double estimasiBiayaPerPorsi;
  final String? fotoUrl;
  final double ratingRataRata;

  MenuItemModel({
    required this.idMenu,
    required this.namaMenu,
    this.kategori = 'MAKANAN_BERAT',
    required this.kaloriKkal,
    this.proteinGram = 0.0,
    this.karbohidratGram = 0.0,
    this.lemakGram = 0.0,
    this.komposisiBahan = const [],
    this.potensiAlergen = const [],
    required this.estimasiBiayaPerPorsi,
    this.fotoUrl,
    this.ratingRataRata = 4.8,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    var rawBahan = json['komposisi_bahan'] as List<dynamic>? ?? [];
    var rawAlergen = json['potensi_alergen'] as List<dynamic>? ?? [];

    return MenuItemModel(
      idMenu: json['id_menu'] as String? ?? '',
      namaMenu: json['nama_menu'] as String? ?? '',
      kategori: json['kategori'] as String? ?? 'MAKANAN_BERAT',
      kaloriKkal: json['kalori_kkal'] as int? ?? 0,
      proteinGram: (json['protein_gram'] as num?)?.toDouble() ?? 0.0,
      karbohidratGram: (json['karbohidrat_gram'] as num?)?.toDouble() ?? 0.0,
      lemakGram: (json['lemak_gram'] as num?)?.toDouble() ?? 0.0,
      komposisiBahan: rawBahan.map((e) => e.toString()).toList(),
      potensiAlergen: rawAlergen.map((e) => e.toString()).toList(),
      estimasiBiayaPerPorsi:
          (json['estimasi_biaya_per_porsi'] as num?)?.toDouble() ?? 0.0,
      fotoUrl: json['foto_url'] as String?,
      ratingRataRata: (json['rating_rata_rata'] as num?)?.toDouble() ?? 4.8,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_menu': idMenu,
      'nama_menu': namaMenu,
      'kategori': kategori,
      'kalori_kkal': kaloriKkal,
      'protein_gram': proteinGram,
      'karbohidrat_gram': karbohidratGram,
      'lemak_gram': lemakGram,
      'komposisi_bahan': komposisiBahan,
      'potensi_alergen': potensiAlergen,
      'estimasi_biaya_per_porsi': estimasiBiayaPerPorsi,
      'foto_url': fotoUrl,
      'rating_rata_rata': ratingRataRata,
    };
  }
}
