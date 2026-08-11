/// Model Perencanaan & Presisi Produksi H+1 (Modul 4 API Contract)
class ProductionPlanModel {
  final String tanggalTarget;
  final int totalPorsiDasar;
  final int totalSiswaKonfirmasiHadir;
  final int totalSiswaMenolak;
  final int totalPorsiPresisiWajibDimasak;

  ProductionPlanModel({
    required this.tanggalTarget,
    required this.totalPorsiDasar,
    required this.totalSiswaKonfirmasiHadir,
    required this.totalSiswaMenolak,
    required this.totalPorsiPresisiWajibDimasak,
  });

  factory ProductionPlanModel.fromJson(Map<String, dynamic> json) {
    return ProductionPlanModel(
      tanggalTarget: json['tanggal_target'] as String? ?? '',
      totalPorsiDasar: json['total_porsi_dasar'] as int? ?? 0,
      totalSiswaKonfirmasiHadir:
          json['total_siswa_konfirmasi_hadir'] as int? ?? 0,
      totalSiswaMenolak: json['total_siswa_menolak'] as int? ?? 0,
      totalPorsiPresisiWajibDimasak:
          json['total_porsi_presisi_wajib_dimasak'] as int? ?? 0,
    );
  }
}

/// Model Siklus Produksi Aktif (Modul 5 API Contract)
class ActiveProductionModel {
  final String idProduksi;
  final String namaMenu;
  final String statusProduksi; // PERSIAPAN, MEMASAK, SELESAI_PACKING
  final int totalPorsiDimasak;

  ActiveProductionModel({
    required this.idProduksi,
    required this.namaMenu,
    required this.statusProduksi,
    required this.totalPorsiDimasak,
  });

  factory ActiveProductionModel.fromJson(Map<String, dynamic> json) {
    return ActiveProductionModel(
      idProduksi: json['id_produksi'] as String? ?? '',
      namaMenu: json['nama_menu'] as String? ?? '',
      statusProduksi: json['status_produksi'] as String? ?? 'PERSIAPAN',
      totalPorsiDimasak: json['total_porsi_dimasak'] as int? ?? 0,
    );
  }
}
