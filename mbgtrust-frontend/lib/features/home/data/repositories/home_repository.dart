import '../../../menu/data/models/schedule_model.dart';
import '../../../menu/data/repositories/menu_repository.dart';

/// Repository data untuk halaman Home (jadwal menu hari ini & besok).
/// Mendelegasikan ke MenuRepository yang sudah memiliki logika endpoint.
class HomeRepository {
  final MenuRepository _menuRepository;

  HomeRepository({MenuRepository? menuRepository})
      : _menuRepository = menuRepository ?? MenuRepository();

  /// Ambil jadwal menu hari ini untuk sekolah tertentu.
  Future<ScheduleModel?> getJadwalHariIni({required int idSekolah}) {
    return _menuRepository.getTodaySchedule(idSekolah: idSekolah);
  }

  /// Ambil rencana jadwal menu besok (H+1) untuk sekolah tertentu.
  Future<ScheduleModel?> getJadwalBesok({required int idSekolah}) {
    return _menuRepository.getTomorrowSchedule(idSekolah: idSekolah);
  }
}
