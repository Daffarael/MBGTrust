import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mbgtrust/core/theme/app_colors.dart';
import 'package:mbgtrust/core/widgets/responsive_layout.dart';

class AiRecommendationsScreen extends StatelessWidget {
  const AiRecommendationsScreen({super.key});

  final List<Map<String, dynamic>> _recommendations = const [
    {
      'menu': 'Nasi Ayam Bakar Kecap & Tumis Buncis',
      'action': 'DIPERTAHANKAN',
      'topsisScore': 0.8425,
      'color': AppColors.primary,
      'aiSummary': 'Menu favorit siswa dengan skor penerimaan 94%. Pertahankan komposisi resep dan porsi saat ini.',
      'portionAction': 'Tetap 550 kkal / porsi',
    },
    {
      'menu': 'Nasi Semur Daging Sapi & Sup Sayur',
      'action': 'DIEVALUASI',
      'topsisScore': 0.5120,
      'color': AppColors.secondaryDark,
      'aiSummary': 'Masukan ulasan NLP menunjukkan kadar garam sup agak tinggi (15% ulasan negatif). Kurangi takaran garam 10%.',
      'portionAction': 'Kurangi Garam 10% & Nasi -10g',
    },
    {
      'menu': 'Nasi Ikan Kembung Goreng & Sayur Lodeh',
      'action': 'DIGANTI',
      'topsisScore': 0.2840,
      'color': AppColors.error,
      'aiSummary': 'Sisa makanan tinggi (35%) dikarenakan duri ikan sulit dibersihkan oleh siswa SD kelas rendah. Direkomendasikan ganti dengan fillet ikan tanpa duri.',
      'portionAction': 'Ganti ke Fillet Ikan Fillet',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      appBar: AppBar(
        title: const Text(
          'Rekomendasi AI & Porsi Menu',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: const [
                  Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 36),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Gemini Intelligent Advisory Engine',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Sintesis otomatis data evaluasi TOPSIS & Ulasan NLP untuk mengoptimalkan porsi dan menurunkan tingkat sisa makanan.',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Rekomendasi Status Kebijakan Menu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recommendations.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _recommendations[index];
                final actionColor = item['color'] as Color;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item['menu'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: actionColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: actionColor),
                            ),
                            child: Text(
                              item['action'] as String,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: actionColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.analytics_rounded, size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            'Skor Preferensi TOPSIS: ${item['topsisScore']}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.psychology_rounded, size: 16, color: AppColors.primary),
                                SizedBox(width: 6),
                                Text(
                                  'Narasi Pertimbangan AI:',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['aiSummary'] as String,
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.straighten_rounded, size: 16, color: AppColors.secondaryDark),
                                const SizedBox(width: 6),
                                Text(
                                  'Aksi Penyesuaian Porsi: ',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                ),
                                Text(
                                  item['portionAction'] as String,
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: actionColor),
                                ),
                              ],
                            ),
                          ],
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
    );
  }
}


