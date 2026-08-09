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
  // Simulator Bobot Penilaian
  double _weightRasa = 20.0;
  double _weightKesukaan = 15.0;
  double _weightPorsi = 10.0;
  double _weightWaste = 30.0;
  double _weightPenolakan = 25.0;

  bool _isWeightExpanded = false;
  String _selectedCategoryTab = 'TOP_FAVORIT'; // 'TOP_FAVORIT' or 'EVALUASI_DIGANTI'

  late List<Map<String, dynamic>> _recommendationList;

  @override
  void initState() {
    super.initState();
    _recommendationList = List.from(MockData.topsisRecommendations);
  }

  Color _getBadgeColor(String status) {
    if (status == 'DIPERTAHANKAN') {
      return AppColors.primary;
    } else if (status == 'MODIFIKASI_RESEP' || status == 'DIPERBAIKI') {
      return Colors.amber.shade800;
    } else if (status == 'DIHAPUS_GANTI_MENU' || status == 'DIBUANG') {
      return AppColors.error;
    }
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    // Separate Top Favorites vs Needs Evaluation
    final topFavorites = _recommendationList.where((rec) {
      final status = (rec['keputusan'] ?? '').toString();
      return status == 'DIPERTAHANKAN';
    }).toList();

    final needsEvaluation = _recommendationList.where((rec) {
      final status = (rec['keputusan'] ?? '').toString();
      return status == 'MODIFIKASI_RESEP' ||
          status == 'DIPERBAIKI' ||
          status == 'DIHAPUS_GANTI_MENU' ||
          status == 'DIBUANG';
    }).toList();

    final displayedList =
        _selectedCategoryTab == 'TOP_FAVORIT' ? topFavorites : needsEvaluation;

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
                // 1. KARTU PROGRES SURVEI & KEPUASAN SISWA HARI INI (PALING ATAS)
                // =============================================================
                Container(
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
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.analytics_rounded,
                                color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Survei Kepuasan Siswa Hari Ini',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white70,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Nasi Daging Sapi Lada Hitam & Capcay',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              '94.0% Kepuasan',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(color: Colors.white24, height: 1),
                      const SizedBox(height: 12),

                      // Indicators Progres Survei
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
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
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
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
                                'Survei berjalan berkelanjutan secara otomatis setiap hari. Persentase kepuasan dan rekomendasi menu diperbarui secara real-time berdasarkan masukan siswa.',
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
                // 2. SIMULATOR BOBOT PENILAIAN MENU (COLLAPSIBLE)
                // =============================================================
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: ExpansionTile(
                    initiallyExpanded: _isWeightExpanded,
                    onExpansionChanged: (val) =>
                        setState(() => _isWeightExpanded = val),
                    leading: const Icon(Icons.tune_rounded,
                        color: AppColors.primary, size: 22),
                    title: const Text(
                      'Atur Bobot Prioritas Penilaian',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: const Text(
                      'Sesuaikan bobot pertimbangan rasa, porsi, dan penolakan siswa',
                      style: TextStyle(
                          fontSize: 11, color: AppColors.textSecondary),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          children: [
                            _buildWeightSlider(
                                '1. Penilaian Rasa (⭐)', _weightRasa, (val) {
                              setState(() => _weightRasa = val);
                            }),
                            _buildWeightSlider(
                                '2. Tingkat Kesukaan (⭐)', _weightKesukaan,
                                (val) {
                              setState(() => _weightKesukaan = val);
                            }),
                            _buildWeightSlider(
                                '3. Kecukupan Porsi (⭐)', _weightPorsi, (val) {
                              setState(() => _weightPorsi = val);
                            }),
                            _buildWeightSlider(
                                '4. Makanan Dipertahankan / Sisa (🗑️)',
                                _weightWaste, (val) {
                              setState(() => _weightWaste = val);
                            }),
                            _buildWeightSlider(
                                '5. Tingkat Penolakan Presensi (❌)',
                                _weightPenolakan, (val) {
                              setState(() => _weightPenolakan = val);
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // =============================================================
                // 3. SEGMENTED BUTTON FILTER: TOP 5 FAVORIT VS PERLU EVALUASI
                // =============================================================
                const Text(
                  'Kategori Analisis Rekomendasi Menu',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      // Tombol Kiri: Top 5 Favorit
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedCategoryTab = 'TOP_FAVORIT';
                            });
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _selectedCategoryTab == 'TOP_FAVORIT'
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
                                  color: _selectedCategoryTab == 'TOP_FAVORIT'
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Top Menu Terfavorit (${topFavorites.length})',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: _selectedCategoryTab == 'TOP_FAVORIT'
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

                      // Tombol Kanan: Perlu Evaluasi / Diganti
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedCategoryTab = 'EVALUASI_DIGANTI';
                            });
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _selectedCategoryTab == 'EVALUASI_DIGANTI'
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
                                  color:
                                      _selectedCategoryTab == 'EVALUASI_DIGANTI'
                                          ? Colors.white
                                          : AppColors.textSecondary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Perlu Evaluasi (${needsEvaluation.length})',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        _selectedCategoryTab == 'EVALUASI_DIGANTI'
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
                // 4. DAFTAR KARTU REKOMENDASI MENU
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
                          final String status =
                              (rec['keputusan'] ?? '').toString();
                          final Color badgeColor = _getBadgeColor(status);

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
                                            ),
                                          ),
                                          const SizedBox(height: 2),
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
                                    const SizedBox(width: 6),
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

                                // Real Survey Numbers Row
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildMetricItem(
                                          'Rasa', '${rec['skor_rasa']} ⭐'),
                                      _buildMetricItem('Kesukaan',
                                          '${rec['skor_kesukaan']} ⭐'),
                                      _buildMetricItem(
                                          'Porsi', '${rec['skor_porsi']} ⭐'),
                                      _buildMetricItem('Sisa Food',
                                          '${rec['sisa_makanan_pct']}% 🗑️'),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Qualitative Comment
                                Text(
                                  '💬 "${rec['ulasan_singkat']}"',
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Card Footer (Decision Badge & Schedule Button anchored to right)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color:
                                              badgeColor.withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          rec['keputusanLabel'],
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: badgeColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        side: const BorderSide(
                                            color: AppColors.primary),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      icon: const Icon(
                                          Icons.event_available_rounded,
                                          color: AppColors.primary,
                                          size: 15),
                                      label: const Text(
                                        'Jadwalkan Menu Ini',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
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
                                  ],
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

  Widget _buildWeightSlider(
      String label, double value, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textPrimary)),
              Text('${value.toInt()}%',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary)),
            ],
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
}
