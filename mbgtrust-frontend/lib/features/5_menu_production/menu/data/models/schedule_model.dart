import 'menu_item_model.dart';

/// Model Jadwal Menu MBG (Hari Ini / Besok)
class ScheduleModel {
  final String idJadwal;
  final String tanggalJadwal;
  final MenuItemModel menu;
  final bool sudahEvaluasi;
  final bool sudahKonfirmasi;
  final String? statusKehadiran; // HADIR, MENOLAK

  ScheduleModel({
    required this.idJadwal,
    required this.tanggalJadwal,
    required this.menu,
    this.sudahEvaluasi = false,
    this.sudahKonfirmasi = false,
    this.statusKehadiran,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    var rawEvaluasi = json['status_evaluasi_pengguna'] as Map<String, dynamic>?;
    var rawKonfirmasi = json['status_konfirmasi_pengguna'] as Map<String, dynamic>?;

    return ScheduleModel(
      idJadwal: json['id_jadwal'] as String? ?? '',
      tanggalJadwal: json['tanggal_jadwal'] as String? ?? '',
      menu: MenuItemModel.fromJson(
          json['menu'] as Map<String, dynamic>? ?? {}),
      sudahEvaluasi: rawEvaluasi?['sudah_evaluasi'] as bool? ?? false,
      sudahKonfirmasi: rawKonfirmasi?['sudah_konfirmasi'] as bool? ?? false,
      statusKehadiran: rawKonfirmasi?['status_kehadiran'] as String?,
    );
  }
}
