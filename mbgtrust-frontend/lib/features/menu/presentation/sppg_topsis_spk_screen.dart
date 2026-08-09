import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/mock_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../production/presentation/widgets/sppg_admin_layout.dart';

class SppgTopsisSpkScreen extends StatefulWidget {
  const SppgTopsisSpkScreen({super.key});

  @override
  State<SppgTopsisSpkScreen> createState() => _SppgTopsisSpkScreenState();
}

class _SppgTopsisSpkScreenState extends State<SppgTopsisSpkScreen> {
  // Simulator Bobot Penilaian (Default 100%)
  double _weightRasa = 25.0;
  double _weightKesukaan = 20.0;
  double _weightPorsi = 15.0;
  double _weightWaste = 25.0;
  double _weightPenolakan = 15.0;

  String _selectedCategoryTab = 'FAVORIT'; // 'FAVORIT' or 'EVALUASI'

  late List<Map<String, dynamic>> _recommendationList;

  @override
  void initState() {
    super.initState();
    _recommendationList = List.from(MockData.topsisRecommendations);
  }

  Color _getBadgeColor(double kepuasanNum) {
    if (kepuasanNum >= 85.0) {
      return AppColors.primary;
    } else if (kepuasanNum >= 50.0) {
      return Colors.blue.shade700;
    } else {
      return AppColors.error;
    }
  }

  /// Calculates normalized weights so the sum always equals 100%
  Map<String, double> _getNormalizedWeights() {
    final double total = _weightRasa +
        _weightKesukaan +
        _weightPorsi +
        _weightWaste +
        _weightPenolakan;
    if (total == 0) {
      return {
        'rasa': 20.0,
        'kesukaan': 20.0,
        'porsi': 20.0,
        'waste': 20.0,
        'penolakan': 20.0,
      };
    }
    return {
      'rasa': (_weightRasa / total) * 100,
      'kesukaan': (_weightKesukaan / total) * 100,
      'porsi': (_weightPorsi / total) * 100,
      'waste': (_weightWaste / total) * 100,
      'penolakan': (_weightPenolakan / total) * 100,
    };
  }

  void _confirmApplyWeights() {
    final norm = _getNormalizedWeights();
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.tune_rounded, color: AppColors.primary, size: 22),
            SizedBox(width: 8),
            Text('Konfirmasi Ubah Bobot',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Apakah Anda yakin ingin memperbarui bobot kriteria SPK? Bobot baru akan dinormalisasi (Total 100%) sebagai berikut:',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildNormRow(
                      '1. Penilaian Rasa', '${norm['rasa']!.toStringAsFixed(1)}%'),
                  _buildNormRow('2. Tingkat Kesukaan',
                      '${norm['kesukaan']!.toStringAsFixed(1)}%'),
                  _buildNormRow('3. Kecukupan Porsi',
                      '${norm['porsi']!.toStringAsFixed(1)}%'),
                  _buildNormRow('4. Makanan Sisa',
                      '${norm['waste']!.toStringAsFixed(1)}%'),
                  _buildNormRow('5. Penolakan Presensi',
                      '${norm['penolakan']!.toStringAsFixed(1)}%'),
                  const Divider(height: 12),
                  _buildNormRow('Total Bobot Ter-Normalisasi', '100.0%',
                      isBold: true),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Batal',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(dialogCtx);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Bobot kriteria berhasil diperbarui & dinormalisasi (100%)!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Ya, Terapkan'),
          ),
        ],
      ),
    );
  }

  /// Opens Modal BottomSheet for Weight Slider Adjustment with Criteria Sub-Explanations
  void _openWeightModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.tune_rounded,
                            color: AppColors.primary, size: 24),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Atur Bobot Penilaian',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded,
                              color: AppColors.textSecondary),
                          onPressed: () => Navigator.pop(sheetCtx),
                        ),
                      ],
                    ),
                    const Text(
                      'Sesuaikan bobot prioritas kriteria penilaian SPK. Setiap kriteria memiliki penjelasan definisi di bawah ini.',
                      style: TextStyle(
                          fontSize: 11.5, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 12),

                    _buildWeightSliderWithDesc(
                      '1. Penilaian Rasa (⭐)',
                      'Tingkat kelezatan bumbu & cita rasa makanan menurut ulasan siswa.',
                      _weightRasa,
                      (val) => setModalState(() => _weightRasa = val),
                    ),
                    _buildWeightSliderWithDesc(
                      '2. Tingkat Kesukaan (⭐)',
                      'Tingkat kepuasan & preferensi penerimaan siswa terhadap variasi menu.',
                      _weightKesukaan,
                      (val) => setModalState(() => _weightKesukaan = val),
                    ),
                    _buildWeightSliderWithDesc(
                      '3. Kecukupan Porsi (⭐)',
                      'Kesesuaian volume porsi makanan dengan kebutuhan gizi & kenyang siswa.',
                      _weightPorsi,
                      (val) => setModalState(() => _weightPorsi = val),
                    ),
                    _buildWeightSliderWithDesc(
                      '4. Makanan Sisa (🗑️)',
                      'Persentase volume makanan tidak terhabiskan yang berpotensi menjadi sisa food waste.',
                      _weightWaste,
                      (val) => setModalState(() => _weightWaste = val),
                    ),
                    _buildWeightSliderWithDesc(
                      '5. Penolakan Presensi (❌)',
                      'Persentase siswa yang menolak / membatalkan porsi sebelum jam batas konfirmasi.',
                      _weightPenolakan,
                      (val) => setModalState(() => _weightPenolakan = val),
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.check_circle_rounded, size: 18),
                        label: const Text(
                          'Simpan & Terapkan Bobot',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.pop(sheetCtx);
                          _confirmApplyWeights();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNormRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: AppColors.textPrimary)),
          Text(value,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isBold ? AppColors.primary : AppColors.primaryDark)),
        ],
      ),
    );
  }

  Widget _buildWeightSliderWithDesc(String title, String description,
      double value, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
              Text('${value.toInt()}%',
                  style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            description,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          Slider(
            value: value,
            min: 0,
            max: 50,
            divisions: 10,
            activeColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Categorize: Menu Favorit (Kepuasan >= 50%) vs Perlu Evaluasi (Kepuasan < 50%)
    final topFavorites = _recommendationList.where((rec) {
      final double kepuasan = (rec['kepuasan_num'] ?? 0.0) as double;
      return kepuasan >= 50.0;
    }).toList();

    final needsEvaluation = _recommendationList.where((rec) {
      final double kepuasan = (rec['kepuasan_num'] ?? 0.0) as double;
      return kepuasan < 50.0;
    }).toList();

    final displayedList =
        _selectedCategoryTab == 'FAVORIT' ? topFavorites : needsEvaluation;

    return SppgAdminLayout(
      currentRoute: '/sppg/topsis-spk-engine',
      title: 'Rekomendasi Menu',
      subtitle: 'Analisis Rekomendasi Menu Terfavorit Siswa',
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 720),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =============================================================
                // 1. KARTU PROGRES SURVEI SISWA HARI INI (PALING ATAS - NO OVERFLOW)
                // =============================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.analytics_rounded,
                                color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Survei Kepuasan Siswa Hari Ini',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white70,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Nasi Daging Sapi Lada Hitam & Capcay',
                                  softWrap: true,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '94.0% Kepuasan',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: Colors.white24, height: 1),
                      const SizedBox(height: 10),

                      // Indicators Progres Survei (Responsive Flexible)
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Progres Survei Ulasan Siswa:',
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.white70),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  '425 / 450 Siswa (94.4% Selesai)',
                                  softWrap: true,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'SURVEI LENGKAP',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Info Catatan Harian
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.info_outline_rounded,
                                color: Colors.white, size: 16),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Survei berjalan berkelanjutan secara otomatis setiap hari. Persentase kepuasan diperbarui secara real-time berdasarkan masukan siswa.',
                                style: TextStyle(
                                    fontSize: 10.5, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // =============================================================
                // 2. HEADER KATEGORI & BUTTON ATUR BOBOT POJOK KANAN ATAS
                // =============================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Kategori Rekomendasi Menu',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.tune_rounded,
                          color: AppColors.primary, size: 15),
                      label: const Text(
                        'Atur Bobot',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      onPressed: _openWeightModal,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // SEGMENTED BUTTON 2 KATA (Menu Favorit vs Perlu Evaluasi)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      // Tombol Kiri: Menu Favorit (2 Kata)
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedCategoryTab = 'FAVORIT';
                            });
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _selectedCategoryTab == 'FAVORIT'
                                  ? AppColors.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  size: 16,
                                  color: _selectedCategoryTab == 'FAVORIT'
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Menu Favorit (${topFavorites.length})',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: _selectedCategoryTab == 'FAVORIT'
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),

                      // Tombol Kanan: Perlu Evaluasi (2 Kata)
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedCategoryTab = 'EVALUASI';
                            });
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _selectedCategoryTab == 'EVALUASI'
                                  ? AppColors.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  size: 16,
                                  color: _selectedCategoryTab == 'EVALUASI'
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Perlu Evaluasi (${needsEvaluation.length})',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: _selectedCategoryTab == 'EVALUASI'
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // =============================================================
                // 3. DAFTAR KARTU REKOMENDASI MENU (DETIL IDSS AI & NO ELLIPSIS)
                // =============================================================
                displayedList.isEmpty
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Center(
                          child: Text(
                            'Tidak ada menu dalam kategori ini.',
                            style: TextStyle(
                                fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: displayedList.length,
                        itemBuilder: (context, index) {
                          final rec = displayedList[index];
                          final double kepuasanNum =
                              (rec['kepuasan_num'] ?? 0.0) as double;
                          final Color badgeColor = _getBadgeColor(kepuasanNum);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: badgeColor.withValues(alpha: 0.4)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header Row (Rank + Name + Satisfaction)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: index == 0
                                            ? const Color(0xFFFFD700)
                                            : (index == 1
                                                ? const Color(0xFFC0C0C0)
                                                : (index == 2
                                                    ? const Color(0xFFCD7F32)
                                                    : AppColors.primaryLight)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '#${index + 1}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: index < 3
                                                ? Colors.black87
                                                : AppColors.primaryDark,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            rec['nama_menu'],
                                            softWrap: true,
                                            style: const TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                              height: 1.25,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            '${rec['kategori']} • ${rec['kalori']}',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryLight,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            rec['skor_kepuasan'],
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryDark,
                                            ),
                                          ),
                                          const Text(
                                            'Kepuasan Siswa',
                                            style: TextStyle(
                                              fontSize: 8.5,
                                              color: AppColors.primaryDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // Metric Numbers Row
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      // Baris 1: Rasa, Kesukaan, Porsi
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          _buildMetricItem(
                                              'Rasa', '${rec['skor_rasa']} ⭐'),
                                          _buildMetricItem('Kesukaan',
                                              '${rec['skor_kesukaan']} ⭐'),
                                          _buildMetricItem(
                                              'Porsi', '${rec['skor_porsi']} ⭐'),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      // Baris 2: Sisa Makanan, Penolakan
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          _buildMetricItem('Sisa Makanan',
                                              '${rec['sisa_makanan_pct']}%'),
                                          _buildMetricItem('Penolakan',
                                              '${rec['penolakan_pct']}%'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // PENJELASAN KECERDASAN IDSS AI
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: badgeColor.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: badgeColor.withValues(alpha: 0.25)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.psychology_rounded,
                                              size: 16, color: badgeColor),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              rec['keputusanLabel'],
                                              softWrap: true,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: badgeColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        rec['idss_insight'] ??
                                            'Analisis IDSS: Menu ini memiliki tingkat penerimaan yang stabil.',
                                        softWrap: true,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textPrimary,
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // TOMBOL PENUH "JADWALKAN MENU INI"
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    icon: const Icon(
                                        Icons.event_available_rounded,
                                        size: 16),
                                    label: const Text(
                                      'Jadwalkan Menu Ini',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () {
                                      context.push('/create-schedule',
                                          extra: rec);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Menu "${rec['nama_menu']}" terpilih! Mengalihkan ke form jadwal.'),
                                          backgroundColor: AppColors.primary,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
