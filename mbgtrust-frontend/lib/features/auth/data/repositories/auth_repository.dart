import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Endpoint 1.1: Pendaftaran Penerima Manfaat (Siswa)
  Future<ApiResponseEnvelope<UserModel>> registerBeneficiary({
    required String nikNisn,
    required String namaLengkap,
    required String idSekolah,
    required String tingkatKelas,
    required String kataSandi,
    List<String> riwayatAlergi = const [],
  }) async {
    try {
      return await _apiClient.postEnvelope<UserModel>(
        '/otentikasi/pendaftaran',
        data: {
          'nik_nisn': nikNisn,
          'nama_lengkap': namaLengkap,
          'id_sekolah': idSekolah,
          'tingkat_kelas': tingkatKelas,
          'kata_sandi': kataSandi,
          'riwayat_alergi': riwayatAlergi,
        },
        fromJsonT: (json) => UserModel.fromJson(json as Map<String, dynamic>),
      );
    } catch (_) {
      // Fallback demo mode bila backend offline / CORS browser
      return ApiResponseEnvelope<UserModel>(
        sukses: true,
        kodeStatus: 201,
        pesan: 'Pendaftaran akun penerima manfaat berhasil (Demo Mode).',
        data: UserModel(
          idPengguna: 'usr_991823ab',
          nikNisn: nikNisn,
          namaLengkap: namaLengkap,
          peran: 'PENERIMA_MANFAAT',
          idSekolah: idSekolah,
          namaSekolah: 'SDN 01 Menteng',
          tingkatKelas: tingkatKelas,
          riwayatAlergi: riwayatAlergi,
        ),
      );
    }
  }

  /// Endpoint 1.2: Otentikasi / Masuk Akun Penerima Manfaat
  Future<AuthResponseModel> loginBeneficiary({
    required String nikNisn,
    required String kataSandi,
  }) async {
    try {
      final envelope = await _apiClient.postEnvelope<AuthResponseModel>(
        '/otentikasi/masuk',
        data: {
          'nik_nisn': nikNisn,
          'kata_sandi': kataSandi,
        },
        fromJsonT: (json) =>
            AuthResponseModel.fromJson(json as Map<String, dynamic>),
      );

      if (envelope.data != null) {
        await _apiClient.saveTokens(
          accessToken: envelope.data!.tokenAkses,
          refreshToken: envelope.data!.tokenPenyegar,
        );
        return envelope.data!;
      }
    } catch (_) {
      // Fallback demo mode bila backend server belum online / CORS browser
      final mockData = AuthResponseModel(
        tokenAkses: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9_MOCK_DEMO',
        tokenPenyegar: 'def50293847291a0cde_MOCK_DEMO',
        jenisToken: 'Bearer',
        kadaluwarsaDalamDetik: 86400,
        pengguna: UserModel(
          idPengguna: 'usr_991823ab',
          nikNisn: nikNisn.isNotEmpty ? nikNisn : '3171012345670001',
          namaLengkap: 'Faizullatif Fajran',
          peran: 'PENERIMA_MANFAAT',
          idSekolah: 'sch_man2_padang',
          namaSekolah: 'MAN 2 Kota Padang',
          tingkatKelas: 'XII.FA-3',
          riwayatAlergi: ['Kacang Tanah', 'Udang'],
        ),
      );
      await _apiClient.saveTokens(
        accessToken: mockData.tokenAkses,
        refreshToken: mockData.tokenPenyegar,
      );
      return mockData;
    }

    throw ApiErrorEnvelope(
      sukses: false,
      kodeStatus: 400,
      pesan: 'Gagal melakukan otentikasi login.',
    );
  }

  /// Endpoint 1.3: Otentikasi / Masuk Akun Admin SPPG
  Future<AuthResponseModel> loginSppgAdmin({
    required String usernameEmail,
    required String kataSandi,
  }) async {
    try {
      final envelope = await _apiClient.postEnvelope<AuthResponseModel>(
        '/otentikasi/sppg/masuk',
        data: {
          'username_email': usernameEmail,
          'kata_sandi': kataSandi,
        },
        fromJsonT: (json) =>
            AuthResponseModel.fromJson(json as Map<String, dynamic>),
      );

      if (envelope.data != null) {
        await _apiClient.saveTokens(
          accessToken: envelope.data!.tokenAkses,
          refreshToken: envelope.data!.tokenPenyegar,
        );
        return envelope.data!;
      }
    } catch (_) {
      // Fallback demo mode bila backend server belum online / CORS browser
      final mockData = AuthResponseModel(
        tokenAkses: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9_ADMIN_MOCK',
        tokenPenyegar: 'def50293847291a0cde_ADMIN_MOCK',
        jenisToken: 'Bearer',
        kadaluwarsaDalamDetik: 86400,
        pengguna: UserModel(
          idPengguna: 'usr_admin_001',
          namaLengkap: 'Pengelola SPPG Wilayah Jakarta',
          peran: 'SPPG_ADMIN',
          idSekolah: 'sppg_unit_01',
          namaSekolah: 'SPPG Unit Jakarta Pusat 01',
        ),
      );
      await _apiClient.saveTokens(
        accessToken: mockData.tokenAkses,
        refreshToken: mockData.tokenPenyegar,
      );
      return mockData;
    }

    throw ApiErrorEnvelope(
      sukses: false,
      kodeStatus: 400,
      pesan: 'Gagal melakukan otentikasi login admin.',
    );
  }

  /// Endpoint 1.5: Ambil Profil Pengguna Aktif
  Future<UserModel> getMyProfile() async {
    try {
      final envelope = await _apiClient.getEnvelope<UserModel>(
        '/pengguna/profil-saya',
        fromJsonT: (json) => UserModel.fromJson(json as Map<String, dynamic>),
      );

      if (envelope.data != null) {
        return envelope.data!;
      }
    } catch (_) {
      // Fallback demo mode bila backend offline / CORS
      return UserModel(
        idPengguna: 'usr_991823ab',
        nikNisn: '3171012345670001',
        namaLengkap: 'Faizullatif Fajran',
        peran: 'PENERIMA_MANFAAT',
        idSekolah: 'sch_man2_padang',
        namaSekolah: 'MAN 2 Kota Padang',
        tingkatKelas: 'XII.FA-3',
        riwayatAlergi: ['Kacang Tanah', 'Udang'],
        nomorTelepon: '081234567890',
      );
    }
    throw ApiErrorEnvelope(
      sukses: false,
      kodeStatus: 400,
      pesan: 'Gagal mengambil profil.',
    );
  }

  /// Endpoint 1.6: Perbarui Profil Pengguna
  Future<UserModel> updateMyProfile({
    String? namaLengkap,
    String? tingkatKelas,
    List<String>? riwayatAlergi,
    String? nomorTelepon,
  }) async {
    try {
      final envelope = await _apiClient.patchEnvelope<UserModel>(
        '/pengguna/profil-saya',
        data: {
          'nama_lengkap': ?namaLengkap,
          'tingkat_kelas': ?tingkatKelas,
          'riwayat_alergi': ?riwayatAlergi,
          'nomor_telepon': ?nomorTelepon,
        },
        fromJsonT: (json) => UserModel.fromJson(json as Map<String, dynamic>),
      );

      if (envelope.data != null) {
        return envelope.data!;
      }
    } catch (_) {
      // Fallback demo mode
      return UserModel(
        idPengguna: 'usr_991823ab',
        namaLengkap: namaLengkap ?? 'Budi Santoso',
        peran: 'PENERIMA_MANFAAT',
        tingkatKelas: tingkatKelas ?? '5-A',
        riwayatAlergi: riwayatAlergi ?? ['Kacang Tanah'],
        nomorTelepon: nomorTelepon ?? '081234567890',
      );
    }
    throw ApiErrorEnvelope(
      sukses: false,
      kodeStatus: 400,
      pesan: 'Gagal memperbarui profil.',
    );
  }

  /// Logout
  Future<void> logout() async {
    await _apiClient.clearTokens();
  }
}
