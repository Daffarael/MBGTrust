import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';
import 'api_response.dart';

/// HTTP Client terpusat menggunakan Dio untuk MBGTrust
class ApiClient {
  static const String defaultBaseUrl = AppConfig.baseUrl;
  static const Duration connectTimeoutDuration = Duration(seconds: 15);
  static const Duration receiveTimeoutDuration = Duration(seconds: 15);

  static const String accessTokenKey = 'jwt_access_token';
  static const String refreshTokenKey = 'jwt_refresh_token';

  late final Dio _dio;
  final FlutterSecureStorage _storage;

  ApiClient({
    FlutterSecureStorage? storage,
    String? baseUrl,
  }) : _storage = storage ?? const FlutterSecureStorage() {
    final options = BaseOptions(
      baseUrl: baseUrl ?? defaultBaseUrl,
      connectTimeout: connectTimeoutDuration,
      receiveTimeout: receiveTimeoutDuration,
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _dio = Dio(options);
    _setupInterceptors();
  }

  /// Getter instansi Dio
  Dio get dio => _dio;

  /// Simpan Token Akses dan Token Penyegar
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _storage.write(key: accessTokenKey, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: refreshTokenKey, value: refreshToken);
    }
  }

  /// Hapus Token (Logout)
  Future<void> clearTokens() async {
    await _storage.delete(key: accessTokenKey);
    await _storage.delete(key: refreshTokenKey);
  }

  /// Membaca Token Akses
  Future<String?> getAccessToken() async {
    return await _storage.read(key: accessTokenKey);
  }

  /// Membaca Token Penyegar
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: refreshTokenKey);
  }

  /// Mengonfigurasi Interceptors untuk JWT Auth & Automatic Token Refresh
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          // Penanganan token kedaluwarsa (401 Unauthorized)
          if (error.response?.statusCode == 401) {
            final refreshToken = await getRefreshToken();
            if (refreshToken != null && refreshToken.isNotEmpty) {
              try {
                final refreshResponse = await _dio.post(
                  '/otentikasi/perbarui-token',
                  data: {'token_penyegar': refreshToken},
                  options: Options(headers: {'Authorization': null}),
                );

                if (refreshResponse.statusCode == 200 &&
                    refreshResponse.data['sukses'] == true) {
                  final newAccessToken =
                      refreshResponse.data['data']['token_akses'];
                  await saveTokens(accessToken: newAccessToken);

                  // Ulangi request asli dengan token baru
                  final retryOptions = error.requestOptions;
                  retryOptions.headers['Authorization'] =
                      'Bearer $newAccessToken';

                  final response = await _dio.fetch(retryOptions);
                  return handler.resolve(response);
                }
              } catch (_) {
                await clearTokens();
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  /// Request HTTP GET dengan parsing ApiResponseEnvelope
  Future<ApiResponseEnvelope<T>> getEnvelope<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic jsonData)? fromJsonT,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return ApiResponseEnvelope<T>.fromJson(
        response.data as Map<String, dynamic>,
        fromJsonT,
      );
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        throw ApiErrorEnvelope.fromJson(
            e.response!.data as Map<String, dynamic>);
      }
      throw ApiErrorEnvelope(
        sukses: false,
        kodeStatus: e.response?.statusCode ?? 500,
        pesan: e.message ?? 'Kesalahan koneksi jaringan.',
      );
    }
  }

  /// Request HTTP POST dengan parsing ApiResponseEnvelope
  Future<ApiResponseEnvelope<T>> postEnvelope<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic jsonData)? fromJsonT,
  }) async {
    try {
      final response = await _dio.post(path, data: data, queryParameters: queryParameters);
      return ApiResponseEnvelope<T>.fromJson(
        response.data as Map<String, dynamic>,
        fromJsonT,
      );
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        throw ApiErrorEnvelope.fromJson(
            e.response!.data as Map<String, dynamic>);
      }
      throw ApiErrorEnvelope(
        sukses: false,
        kodeStatus: e.response?.statusCode ?? 500,
        pesan: e.message ?? 'Kesalahan koneksi jaringan.',
      );
    }
  }

  /// Request HTTP PATCH dengan parsing ApiResponseEnvelope
  Future<ApiResponseEnvelope<T>> patchEnvelope<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic jsonData)? fromJsonT,
  }) async {
    try {
      final response = await _dio.patch(path, data: data, queryParameters: queryParameters);
      return ApiResponseEnvelope<T>.fromJson(
        response.data as Map<String, dynamic>,
        fromJsonT,
      );
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        throw ApiErrorEnvelope.fromJson(
            e.response!.data as Map<String, dynamic>);
      }
      throw ApiErrorEnvelope(
        sukses: false,
        kodeStatus: e.response?.statusCode ?? 500,
        pesan: e.message ?? 'Kesalahan koneksi jaringan.',
      );
    }
  }
}
