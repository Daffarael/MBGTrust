/// Konfigurasi URL base API terpusat.
///
/// Cara penggunaan:
///   Dev (Android Emulator) : flutter run
///   Dev (Device Fisik)     : flutter run --dart-define=BASE_URL=http://192.168.x.x:3000/api/v1
///   Production (APK/Web)   : flutter build apk --dart-define=BASE_URL=https://mbgtrust-backend.railway.app/api/v1
class AppConfig {
  AppConfig._();

  /// URL produksi Railway — diperbarui saat Fase 7 setelah deploy selesai.
  static const String _productionBaseUrl =
      'https://mbgtrust-backend.railway.app/api/v1';

  /// URL dev lokal untuk Android Emulator (10.0.2.2 = localhost PC dari emulator).
  static const String _emulatorBaseUrl = 'http://10.0.2.2:3000/api/v1';

  /// Ambil URL dari dart-define saat build, fallback ke emulator dev URL.
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: _emulatorBaseUrl,
  );

  /// URL production (dipakai langsung jika tidak pakai dart-define).
  static const String productionBaseUrl = _productionBaseUrl;
}
