import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/production_plan_model.dart';
import '../../data/repositories/production_repository.dart';

/// Provider instansi ProductionRepository
/// (ProductionRepository juga menangani endpoint distribusi)
final productionRepositoryProvider = Provider<ProductionRepository>((ref) {
  return ProductionRepository();
});

/// State Production & Distribusi
class ProductionState {
  final List<ActiveProductionModel> daftarProduksiAktif;
  final ProductionPlanModel? rencanaProduksi;
  final bool isLoading;
  final String? errorMessage;

  ProductionState({
    this.daftarProduksiAktif = const [],
    this.rencanaProduksi,
    this.isLoading = false,
    this.errorMessage,
  });

  ProductionState copyWith({
    List<ActiveProductionModel>? daftarProduksiAktif,
    ProductionPlanModel? rencanaProduksi,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProductionState(
      daftarProduksiAktif: daftarProduksiAktif ?? this.daftarProduksiAktif,
      rencanaProduksi: rencanaProduksi ?? this.rencanaProduksi,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// Notifier Production & Distribusi
class ProductionNotifier extends StateNotifier<ProductionState> {
  final ProductionRepository _repository;

  ProductionNotifier(this._repository) : super(ProductionState());

  /// Ambil rencana produksi harian berdasarkan tanggal
  Future<void> loadRencanaProduksi(String tanggal) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final rencana = await _repository.getDailyProductionPlan(tanggal);
      state = state.copyWith(rencanaProduksi: rencana, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Ambil daftar siklus produksi aktif hari ini
  Future<void> loadProduksiAktif() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final list = await _repository.getActiveProductionCycles();
      state = state.copyWith(daftarProduksiAktif: list, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Update status memasak produksi (PERSIAPAN → MEMASAK → SELESAI)
  Future<bool> updateStatusProduksi({
    required String idProduksi,
    required String statusProduksi,
  }) async {
    try {
      await _repository.updateProductionStatus(
        idProduksi: idProduksi,
        statusProduksi: statusProduksi,
      );
      await loadProduksiAktif(); // Refresh list
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  /// Update status pengiriman distribusi (DISIAPKAN → DIKIRIM → TIBA_DI_SEKOLAH)
  Future<bool> updateStatusDistribusi({
    required String idDistribusi,
    required String statusDistribusi,
    String? waktuTiba,
  }) async {
    try {
      await _repository.updateDistributionStatus(
        idDistribusi: idDistribusi,
        statusDistribusi: statusDistribusi,
        waktuTiba: waktuTiba,
      );
      await loadProduksiAktif(); // Refresh list
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  /// Hitung ulang estimasi produksi
  Future<int> hitungUlangEstimasi(String tanggalTarget) async {
    try {
      return await _repository.recalculateProductionEstimate(tanggalTarget);
    } catch (_) {
      return 0;
    }
  }
}

/// Provider State Production (mencakup distribusi)
final productionProvider =
    StateNotifierProvider<ProductionNotifier, ProductionState>((ref) {
  final repository = ref.watch(productionRepositoryProvider);
  return ProductionNotifier(repository);
});
