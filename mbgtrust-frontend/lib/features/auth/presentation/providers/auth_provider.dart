import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

/// Provider instansi AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// State Autentikasi Pengguna
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthenticated;

  AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? errorMessage,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

/// Notifier State Auth
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState()) {
    checkCurrentUser();
  }

  /// Cek profil pengguna yang sedang aktif saat aplikasi dibuka
  Future<void> checkCurrentUser() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repository.getMyProfile();
      state = state.copyWith(
        user: user,
        isLoading: false,
        isAuthenticated: true,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
      );
    }
  }

  /// Login Penerima Manfaat (Siswa) - Endpoint 1.2
  Future<bool> loginBeneficiary(String nikNisn, String kataSandi) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final res = await _repository.loginBeneficiary(
        nikNisn: nikNisn,
        kataSandi: kataSandi,
      );
      state = state.copyWith(
        user: res.pengguna,
        isLoading: false,
        isAuthenticated: true,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Login Admin SPPG - Endpoint 1.3
  Future<bool> loginSppgAdmin(String usernameEmail, String kataSandi) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final res = await _repository.loginSppgAdmin(
        usernameEmail: usernameEmail,
        kataSandi: kataSandi,
      );
      state = state.copyWith(
        user: res.pengguna,
        isLoading: false,
        isAuthenticated: true,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Register Siswa - Endpoint 1.1
  Future<bool> registerBeneficiary({
    required String nikNisn,
    required String namaLengkap,
    required String idSekolah,
    required String tingkatKelas,
    required String kataSandi,
    List<String> riwayatAlergi = const [],
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repository.registerBeneficiary(
        nikNisn: nikNisn,
        namaLengkap: namaLengkap,
        idSekolah: idSekolah,
        tingkatKelas: tingkatKelas,
        kataSandi: kataSandi,
        riwayatAlergi: riwayatAlergi,
      );
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    await _repository.logout();
    state = AuthState();
  }
}

/// Provider State Auth
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
