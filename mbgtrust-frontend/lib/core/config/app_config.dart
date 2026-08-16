// ignore_for_file: do_not_use_environment
import 'package:flutter/foundation.dart';

/// Konfigurasi URL base API terpusat.
///
/// Cara penggunaan:
///   Dev Web/Desktop        : flutter run -d chrome  (otomatis localhost:3000)
///   Dev Android Emulator   : flutter run -d emulator (otomatis 10.0.2.2:3000)
///   Dev Device Fisik       : flutter run --dart-define=BASE_URL=http://192.168.x.x:3000/api/v1
///   Production             : flutter build --dart-define=BASE_URL=https://mbgtrust-production.up.railway.app/api/v1
class AppConfig {
  AppConfig._();

  /// URL produksi Railway.
  static const String _productionBaseUrl =
      'https://mbgtrust-production.up.railway.app/api/v1';

  /// URL dev lokal untuk Android Emulator (10.0.2.2 = localhost PC dari emulator).
  static const String _emulatorBaseUrl = 'http://10.0.2.2:3000/api/v1';

  /// URL dev lokal untuk Web / Windows Desktop (langsung ke localhost).
  static const String _webLocalBaseUrl = 'http://localhost:3000/api/v1';

  /// Ambil URL dari dart-define saat build.
  /// Jika tidak di-define: Web/Desktop pakai localhost, Android Emulator pakai 10.0.2.2.
  static String get baseUrl {
    const defined = String.fromEnvironment('BASE_URL', defaultValue: '');
    if (defined.isNotEmpty) return defined;
    // Web & Desktop: gunakan localhost langsung
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.windows) {
      return _webLocalBaseUrl;
    }
    // Android Emulator: gunakan 10.0.2.2 (alias localhost dari emulator)
    return _emulatorBaseUrl;
  }

  /// URL production (dipakai langsung jika tidak pakai dart-define).
  static const String productionBaseUrl = _productionBaseUrl;
}
