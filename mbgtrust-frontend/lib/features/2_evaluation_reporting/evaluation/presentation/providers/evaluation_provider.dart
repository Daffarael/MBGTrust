import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/evaluation_model.dart';
import '../../data/models/rejection_reason_model.dart';
import '../../data/repositories/evaluation_repository.dart';

/// Provider instansi EvaluationRepository
final evaluationRepositoryProvider = Provider<EvaluationRepository>((ref) {
  return EvaluationRepository();
});

/// Provider untuk daftar alasan penolakan (cached)
final rejectionReasonsProvider =
    FutureProvider.autoDispose<List<RejectionReasonModel>>((ref) async {
  final repo = ref.watch(evaluationRepositoryProvider);
  return await repo.getRejectionReasons();
});

/// State untuk aksi submit evaluasi
class EvaluationState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  EvaluationState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  EvaluationState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return EvaluationState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }
}

/// Notifier untuk aksi submit evaluasi dan konfirmasi
class EvaluationNotifier extends StateNotifier<EvaluationState> {
  final EvaluationRepository _repository;

  EvaluationNotifier(this._repository) : super(EvaluationState());

  /// Submit evaluasi post-konsumsi siswa
  Future<bool> submitEvaluation({
    required String idJadwal,
    required SubmitEvaluationRequest request,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      await _repository.submitEvaluation(idJadwal: idJadwal, request: request);
      state = state.copyWith(isLoading: false, isSuccess: true);
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

  void reset() => state = EvaluationState();
}

/// Provider State Evaluation
final evaluationProvider =
    StateNotifierProvider<EvaluationNotifier, EvaluationState>((ref) {
  final repository = ref.watch(evaluationRepositoryProvider);
  return EvaluationNotifier(repository);
});
