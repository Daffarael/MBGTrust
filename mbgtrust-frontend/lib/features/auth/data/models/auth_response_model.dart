import 'user_model.dart';

/// Respon login berhasil dari API (/otentikasi/masuk & /otentikasi/sppg/masuk)
class AuthResponseModel {
  final String tokenAkses;
  final String tokenPenyegar;
  final String jenisToken;
  final int kadaluwarsaDalamDetik;
  final UserModel pengguna;

  AuthResponseModel({
    required this.tokenAkses,
    required this.tokenPenyegar,
    required this.jenisToken,
    required this.kadaluwarsaDalamDetik,
    required this.pengguna,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      tokenAkses: json['token_akses'] as String? ?? '',
      tokenPenyegar: json['token_penyegar'] as String? ?? '',
      jenisToken: json['jenis_token'] as String? ?? 'Bearer',
      kadaluwarsaDalamDetik: json['kadaluwarsa_dalam_detik'] as int? ?? 86400,
      pengguna: UserModel.fromJson(
          json['pengguna'] as Map<String, dynamic>? ?? {}),
    );
  }
}
