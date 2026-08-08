class ImageUtils {
  /// Mengonversi link berbagi Google Drive standar menjadi Direct Image Stream URL
  ///
  /// Contoh Input Link Google Drive:
  /// - https://drive.google.com/file/d/1A2B3C4D5E6F7G8H9/view?usp=sharing
  /// - https://drive.google.com/open?id=1A2B3C4D5E6F7G8H9
  ///
  /// Output Direct Stream URL:
  /// - https://lh3.googleusercontent.com/d/1A2B3C4D5E6F7G8H9
  static String getDirectImageUrl(String rawUrl) {
    if (rawUrl.isEmpty) return rawUrl;

    final trimmed = rawUrl.trim();

    // Cek jika URL adalah link Google Drive
    if (trimmed.contains('drive.google.com')) {
      String? fileId;

      // Pola 1: /file/d/FILE_ID/view
      if (trimmed.contains('/file/d/')) {
        final parts = trimmed.split('/file/d/');
        if (parts.length > 1) {
          fileId = parts[1].split('/')[0].split('?')[0];
        }
      }
      // Pola 2: id=FILE_ID
      else if (trimmed.contains('id=')) {
        final Uri uri = Uri.parse(trimmed);
        fileId = uri.queryParameters['id'];
      }

      if (fileId != null && fileId.isNotEmpty) {
        // Gunakan CDN Google lh3 untuk gambar cepat & stabil
        return 'https://lh3.googleusercontent.com/d/$fileId';
      }
    }

    return trimmed;
  }
}
