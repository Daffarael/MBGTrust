import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  final List<Map<String, dynamic>> _recommendationList = [
    {
      'id': 'rec_01',
      'nama_menu': 'Nasi Ayam Bakar Kecap & Tumis Buncis',
      'kategori': 'Makanan Berat',
      'kalori': '550 kcal',
      'skor_kepuasan': '96.5%',
      'skor_rasa': 4.8,
      'skor_kesukaan': 4.9,
      'skor_porsi': 4.7,
      'sisa_makanan_pct': 4.2,
      'penolakan_pct': 2.1,
      'keputusan': 'DIPERTAHANKAN',
      'keputusanLabel': 'Dipertahankan (Sangat Direkomendasikan)',
      'badgeColor': AppColors.primary,
      'ulasan_singkat': 'Favorit utama siswa, bumbu meresap & porsi sangat pas.',
    },
    {
      'id': 'rec_02',
      'nama_menu': 'Nasi Daging Sapi Lada Hitam & Capcay',
      'kategori': 'Makanan Berat',
      'kalori': '620 kcal',
      'skor_kepuasan': '94.0%',
      'skor_rasa': 4.7,
      'skor_kesukaan': 4.8,
      'skor_porsi': 4.6,
      'sisa_makanan_pct': 5.0,
      'penolakan_pct': 3.0,
      'keputusan': 'DIPERTAHANKAN',
      'keputusanLabel': 'Dipertahankan (Sangat Direkomendasikan)',
      'badgeColor': AppColors.primary,
      'ulasan_singkat': 'Daging empuk, sisa makanan sangat rendah di sekolah.',
    },
    {
      'id': 'rec_03',
      'nama_menu': 'Nasi Ikan Gurame Asam Manis & Sup Sayur',
      'kategori': 'Makanan Berat',
      'kalori': '580 kcal',
      'skor_kepuasan': '91.8%',
      'skor_rasa': 4.6,
      'skor_kesukaan': 4.5,
      'skor_porsi': 4.5,
      'sisa_makanan_pct': 7.5,
      'penolakan_pct': 4.2,
      'keputusan': 'DIPERTAHANKAN',
      'keputusanLabel': 'Dipertahankan (Direkomendasikan)',
      'badgeColor': Colors.blue,
      'ulasan_singkat': 'Pilihan utama siswa untuk variasi olahan ikan segar.',
    },
    {
      'id': 'rec_04',
      'nama_menu': 'Nasi Ayam Goreng Lengkuas & Lalapan',
      'kategori': 'Makanan Berat',
      'kalori': '560 kcal',
      'skor_kepuasan': '78.5%',
      'skor_rasa': 4.2,
      'skor_kesukaan': 4.0,
      'skor_porsi': 3.8,
      'sisa_makanan_pct': 14.8,
      'penolakan_pct': 8.5,
      'keputusan': 'DIPERBAIKI',
      'keputusanLabel': 'Diperbaiki / Evaluasi Porsi & Bumbu',
      'badgeColor': Colors.amber.shade800,
      'ulasan_singkat': 'Siswa menyukai ayam namun sisa lalapan bumbu agak banyak.',
    },
    {
      'id': 'rec_05',
      'nama_menu': 'Nasi Ikan Asin Pedas & Sayur Lodeh',
      'kategori': 'Makanan Berat',
      'kalori': '490 kcal',
      'skor_kepuasan': '42.0%',
      'skor_rasa': 2.8,
      'skor_kesukaan': 2.5,
      'skor_porsi': 3.2,
      'sisa_makanan_pct': 32.5,
      'penolakan_pct': 28.0,
      'keputusan': 'DIBUANG',
      'keputusanLabel': 'Perlu Dibuang / Diganti (Kurang Disukai)',
      'badgeColor': AppColors.error,
      'ulasan_singkat': 'Sisa makanan tinggi (32.5%) & tingkat penolakan tinggi.',
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                // Executive Summary IDSS AI Insight Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.psychology_rounded,
                              color: AppColors.primaryDark, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Ringkasan Analisis Dapur SPPG',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Berdasarkan survei ulasan rasa, kecukupan porsi, dan persentase makanan yang dihabiskan siswa, menu Nasi Ayam Bakar Kecap mendapatkan rekomendasi tertinggi (96.5%). Sebaliknya, Nasi Ikan Asin Pedas disarankan untuk dievaluasi total atau diganti karena persentase sisa makanan mencapai 32.5%.',
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AppColors.primaryDark,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Simulator Bobot Kriteria Interaktif
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: ExpansionTile(
                    shape: const Border(),
                    initiallyExpanded: _isWeightExpanded,
                    onExpansionChanged: (val) {
                      setState(() => _isWeightExpanded = val);
                    },
                    leading: const Icon(Icons.tune_rounded,
                        color: AppColors.primary),
                    title: const Text(
                      'Simulator Bobot Penilaian Menu',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: const Text(
                      'Sesuaikan bobot persentase penilaian dapur secara langsung',
                      style: TextStyle(
                          fontSize: 11, color: AppColors.textSecondary),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          children: [
                            _buildWeightSlider('1. Penilaian Rasa (⭐)', _weightRasa, (val) {
                              setState(() => _weightRasa = val);
                            }),
                            _buildWeightSlider('2. Tingkat Kesukaan (⭐)', _weightKesukaan, (val) {
                              setState(() => _weightKesukaan = val);
                            }),
                            _buildWeightSlider('3. Kecukupan Porsi (⭐)', _weightPorsi, (val) {
                              setState(() => _weightPorsi = val);
                            }),
                            _buildWeightSlider('4. Makanan Dipertahankan / Sisa (🗑️)', _weightWaste, (val) {
                              setState(() => _weightWaste = val);
                            }),
                            _buildWeightSlider('5. Tingkat Penolakan Presensi (❌)', _weightPenolakan, (val) {
                              setState(() => _weightPenolakan = val);
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Section Title Daftar Rekomendasi Menu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Expanded(
                      child: Text(
                        'Daftar Rekomendasi Menu Makanan',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      'Berdasarkan Survei Siswa',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // List of Recommendation Cards
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _recommendationList.length,
                  itemBuilder: (context, index) {
                    final rec = _recommendationList[index];
                    final Color badgeColor = rec['badgeColor'];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildMetricItem('Rasa', '${rec['skor_rasa']} ⭐'),
                                _buildMetricItem('Kesukaan', '${rec['skor_kesukaan']} ⭐'),
                                _buildMetricItem('Porsi', '${rec['skor_porsi']} ⭐'),
                                _buildMetricItem('Sisa Food', '${rec['sisa_makanan_pct']}% 🗑️'),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: badgeColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
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
                                  side:
                                      const BorderSide(color: AppColors.primary),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                icon: const Icon(Icons.event_available_rounded,
                                    color: AppColors.primary, size: 15),
                                label: const Text(
                                  'Jadwalkan Menu Ini',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                onPressed: () {
                                  context.push('/create-schedule', extra: rec);
                                  ScaffoldMessenger.of(context).showSnackBar(
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

  Widget _buildWeightSlider(
      String label, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.bold)),
            Text('${value.toInt()}%',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark)),
          ],
        ),
        Slider(
          value: value,
          min: 0.0,
          max: 50.0,
          divisions: 10,
          activeColor: AppColors.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildMetricItem(String label, String val) {
    return Column(
      children: [
        Text(
          val,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9.5,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
