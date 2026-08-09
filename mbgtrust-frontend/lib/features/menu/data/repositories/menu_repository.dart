import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../models/menu_item_model.dart';
import '../models/schedule_model.dart';

class MenuRepository {
  final ApiClient _apiClient;

  MenuRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Endpoint 2.1: Tambah Master Menu MBG
  Future<MenuItemModel> addMenuItem({
    required String namaMenu,
    String kategori = 'MAKANAN_BERAT',
    required int kaloriKkal,
    required double proteinGram,
    required double karbohidratGram,
    required double lemakGram,
    List<String> komposisiBahan = const [],
    List<String> potensiAlergen = const [],
    required double estimasiBiayaPerPorsi,
  }) async {
    final envelope = await _apiClient.postEnvelope<MenuItemModel>(
      '/menu',
      data: {
        'nama_menu': namaMenu,
        'kategori': kategori,
        'kalori_kkal': kaloriKkal,
        'protein_gram': proteinGram,
        'karbohidrat_gram': karbohidratGram,
        'lemak_gram': lemakGram,
        'komposisi_bahan': komposisiBahan,
        'potensi_alergen': potensiAlergen,
        'estimasi_biaya_per_porsi': estimasiBiayaPerPorsi,
      },
      fromJsonT: (json) => MenuItemModel.fromJson(json as Map<String, dynamic>),
    );

    if (envelope.data != null) return envelope.data!;
    throw ApiErrorEnvelope(
      sukses: false,
      kodeStatus: envelope.kodeStatus,
      pesan: envelope.pesan,
    );
  }

  /// Endpoint 2.2: Ambil Daftar Master Menu MBG
  Future<List<MenuItemModel>> getMenuList({
    int halaman = 1,
    int batas = 10,
    String? cari,
  }) async {
    final queryParams = {
      'halaman': halaman,
      'batas': batas,
      if (cari != null && cari.isNotEmpty) 'cari': cari,
    };

    final envelope = await _apiClient.getEnvelope<List<MenuItemModel>>(
      '/menu',
      queryParameters: queryParams,
      fromJsonT: (json) {
        var rawList = json as List<dynamic>? ?? [];
        return rawList
            .map((e) => MenuItemModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );

    return envelope.data ?? [];
  }

  /// Endpoint 2.3: Ambil Rincian Detail Menu
  Future<MenuItemModel> getMenuDetail(String idMenu) async {
    final envelope = await _apiClient.getEnvelope<MenuItemModel>(
      '/menu/$idMenu',
      fromJsonT: (json) => MenuItemModel.fromJson(json as Map<String, dynamic>),
    );

    if (envelope.data != null) return envelope.data!;
    throw ApiErrorEnvelope(
      sukses: false,
      kodeStatus: envelope.kodeStatus,
      pesan: envelope.pesan,
    );
  }

  /// Endpoint 2.5: Plotting Jadwal Menu Harian
  Future<void> createSchedule({
    required int idMenu,
    required int idSekolah,
    required String tanggalJadwal,
    required int targetTotalPorsi,
  }) async {
    await _apiClient.postEnvelope(
      '/jadwal',
      data: {
        'id_menu': idMenu,
        'id_sekolah': idSekolah,
        'tanggal_jadwal': tanggalJadwal,
        'target_total_porsi': targetTotalPorsi,
      },
    );
  }

  /// Endpoint 2.6: Ambil Menu Hari Ini
  Future<ScheduleModel?> getTodaySchedule({int? idSekolah}) async {
    final envelope = await _apiClient.getEnvelope<ScheduleModel>(
      '/jadwal/hari-ini',
      queryParameters: {
        'id_sekolah': ?idSekolah,
      },
      fromJsonT: (json) => ScheduleModel.fromJson(json as Map<String, dynamic>),
    );

    return envelope.data;
  }

  /// Endpoint 2.7: Ambil Rencana Menu Besok (H+1)
  Future<ScheduleModel?> getTomorrowSchedule({int? idSekolah}) async {
    final envelope = await _apiClient.getEnvelope<ScheduleModel>(
      '/jadwal/besok',
      queryParameters: {
        'id_sekolah': ?idSekolah,
      },
      fromJsonT: (json) => ScheduleModel.fromJson(json as Map<String, dynamic>),
    );

    return envelope.data;
  }
}
