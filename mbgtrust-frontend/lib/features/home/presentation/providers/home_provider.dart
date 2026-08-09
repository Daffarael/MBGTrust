import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../menu/data/models/schedule_model.dart';
import '../../data/repositories/home_repository.dart';

/// Provider instansi HomeRepository
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository();
});

/// State Home Screen
class HomeState {
  final ScheduleModel? jadwalHariIni;
  final ScheduleModel? jadwalBesok;
  final bool isLoading;
  final String? errorMessage;

  HomeState({
    this.jadwalHariIni,
    this.jadwalBesok,
    this.isLoading = false,
    this.errorMessage,
  });

  HomeState copyWith({
    ScheduleModel? jadwalHariIni,
    ScheduleModel? jadwalBesok,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HomeState(
      jadwalHariIni: jadwalHariIni ?? this.jadwalHariIni,
      jadwalBesok: jadwalBesok ?? this.jadwalBesok,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// Notifier Home
class HomeNotifier extends StateNotifier<HomeState> {
  final HomeRepository _repository;

  HomeNotifier(this._repository) : super(HomeState());

  /// Muat jadwal hari ini dan besok untuk sekolah tertentu
  Future<void> loadJadwal(int idSekolah) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final results = await Future.wait([
        _repository.getJadwalHariIni(idSekolah: idSekolah),
        _repository.getJadwalBesok(idSekolah: idSekolah),
      ]);
      state = state.copyWith(
        jadwalHariIni: results[0],
        jadwalBesok: results[1],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

/// Provider State Home
final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return HomeNotifier(repository);
});
