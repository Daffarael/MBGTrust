import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../evaluation/data/models/evaluation_model.dart';
import '../../../evaluation/data/models/rejection_reason_model.dart';
import '../../data/repositories/rating_repository.dart';

/// Provider instansi RatingRepository
final ratingRepositoryProvider = Provider<RatingRepository>((ref) {
  return RatingRepository();
});

/// Provider untuk daftar alasan penolakan (cached, dari rating feature)
final ratingRejectionReasonsProvider =
    FutureProvider.autoDispose<List<RejectionReasonModel>>((ref) async {
  final repo = ref.watch(ratingRepositoryProvider);
  return await repo.getRejectionReasons();
});

/// State untuk aksi rating gamified
class RatingState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final int poinXpDitambahkan; // untuk animasi gamifikasi

  RatingState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.poinXpDitambahkan = 0,
  });

  RatingState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    int? poinXpDitambahkan,
  }) {
    return RatingState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      poinXpDitambahkan: poinXpDitambahkan ?? this.poinXpDitambahkan,
    );
  }
}

/// Notifier Rating (gamified UX — +50 XP per evaluasi)
class RatingNotifier extends StateNotifier<RatingState> {
  final RatingRepository _repository;

  RatingNotifier(this._repository) : super(RatingState());

  /// Submit rating gamified — UI tampilkan animasi +50 XP saat sukses
  Future<bool> submitRating({
    required String idJadwal,
    required SubmitEvaluationRequest request,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
      poinXpDitambahkan: 0,
    );
    try {
      await _repository.submitRating(idJadwal: idJadwal, request: request);
      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        poinXpDitambahkan: 50, // Sesuai schema: poin_xp +50 per evaluasi
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Konfirmasi kehadiran besok
  Future<bool> confirmTomorrow({
    required String idJadwal,
    required ConfirmPresenceRequest request,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      await _repository.confirmTomorrowPresence(idJadwal: idJadwal, request: request);
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  void reset() => state = RatingState();
}

/// Provider State Rating
final ratingProvider =
    StateNotifierProvider<RatingNotifier, RatingState>((ref) {
  final repository = ref.watch(ratingRepositoryProvider);
  return RatingNotifier(repository);
});
