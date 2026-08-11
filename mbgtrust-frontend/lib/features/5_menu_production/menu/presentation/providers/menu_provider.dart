import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/menu_item_model.dart';
import '../../data/models/schedule_model.dart';
import '../../data/repositories/menu_repository.dart';

final menuRepositoryProvider = Provider<MenuRepository>((ref) {
  return MenuRepository();
});

/// FutureProvider untuk mengambil daftar menu
final menuListProvider = FutureProvider.autoDispose<List<MenuItemModel>>((ref) async {
  final repo = ref.watch(menuRepositoryProvider);
  return await repo.getMenuList();
});

/// FutureProvider untuk menu hari ini — memerlukan idSekolah
final todayScheduleProvider = FutureProvider.autoDispose.family<ScheduleModel?, int>(
  (ref, idSekolah) async {
    final repo = ref.watch(menuRepositoryProvider);
    return await repo.getTodaySchedule(idSekolah: idSekolah);
  },
);

/// FutureProvider untuk menu besok (H+1) — memerlukan idSekolah
final tomorrowScheduleProvider = FutureProvider.autoDispose.family<ScheduleModel?, int>(
  (ref, idSekolah) async {
    final repo = ref.watch(menuRepositoryProvider);
    return await repo.getTomorrowSchedule(idSekolah: idSekolah);
  },
);

/// State untuk aksi plotting jadwal (Admin SPPG)
class ScheduleCreateState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  ScheduleCreateState({this.isLoading = false, this.isSuccess = false, this.errorMessage});
  ScheduleCreateState copyWith({bool? isLoading, bool? isSuccess, String? errorMessage}) {
    return ScheduleCreateState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }
}

class ScheduleCreateNotifier extends StateNotifier<ScheduleCreateState> {
  final MenuRepository _repository;
  ScheduleCreateNotifier(this._repository) : super(ScheduleCreateState());

  Future<bool> createSchedule({
    required int idMenu,
    required int idSekolah,
    required String tanggalJadwal,
    required int targetTotalPorsi,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      await _repository.createSchedule(
        idMenu: idMenu,
        idSekolah: idSekolah,
        tanggalJadwal: tanggalJadwal,
        targetTotalPorsi: targetTotalPorsi,
      );
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}

final scheduleCreateProvider =
    StateNotifierProvider<ScheduleCreateNotifier, ScheduleCreateState>((ref) {
  return ScheduleCreateNotifier(ref.watch(menuRepositoryProvider));
});
