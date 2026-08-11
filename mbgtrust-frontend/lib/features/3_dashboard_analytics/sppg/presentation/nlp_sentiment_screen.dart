import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mbgtrust/core/theme/app_colors.dart';
import 'package:mbgtrust/core/widgets/responsive_layout.dart';

class NlpSentimentScreen extends StatelessWidget {
  const NlpSentimentScreen({super.key});

  final List<Map<String, dynamic>> _sentimentSummary = const [
    {'type': 'Positif', 'percentage': 72.5, 'count': 326, 'color': AppColors.primary},
    {'type': 'Netral', 'percentage': 18.0, 'count': 81, 'color': AppColors.secondary},
    {'type': 'Negatif', 'percentage': 9.5, 'count': 43, 'color': AppColors.error},
  ];

  final List<Map<String, dynamic>> _keywords = const [
    {'word': 'Daging Empuk', 'category': 'Positif', 'count': 142},
    {'word': 'Rasa Gurih', 'category': 'Positif', 'count': 118},
    {'word': 'Bumbu Pas', 'category': 'Positif', 'count': 95},
    {'word': 'Sayur Agak Layu', 'category': 'Negatif', 'count': 28},
    {'word': 'Terlalu Asin', 'category': 'Negatif', 'count': 15},
    {'word': 'Porsi Nasi Banyak', 'category': 'Netral', 'count': 42},
  ];

  final List<Map<String, String>> _recentReviews = const [
    {
      'student': 'Siswa Kelas 5-A',
      'review': 'Daging ayamnya empuk banget dan bumbunya manis pas!',
      'sentiment': 'Positif',
      'menu': 'Nasi Ayam Bakar Kecap',
    },
    {
      'student': 'Siswa Kelas 4-B',
      'review': 'Sayur buncisnya agak layu, tapi ikannya enak.',
      'sentiment': 'Netral',
      'menu': 'Nasi Ikan Goreng',
    },
    {
      'student': 'Siswa Kelas 5-B',
      'review': 'Supnya agak asin untuk lidah saya.',
      'sentiment': 'Negatif',
      'menu': 'Nasi Semur Daging',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      appBar: AppBar(
        title: const Text(
          'Analitik Sentimen NLP Ulasan',
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
            // Header Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E8FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFC084FC)),
              ),
              child: Row(
                children: const [
                  Text('🧠', style: TextStyle(fontSize: 32)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NLP Sentiment Engine',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF6B21A8),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Menganalisis masukan kualitatif ulasan teks siswa secara otomatis untuk mendeteksi akar penyebab food waste.',
                          style: TextStyle(fontSize: 11, color: Color(0xFF581C87)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Distribusi Sentimen Overall
            const Text(
              'Distribusi Sentimen Ulasan Siswa',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: _sentimentSummary.map((item) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: (item['color'] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: item['color'] as Color),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${item['percentage']}%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: item['color'] as Color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['type'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: item['color'] as Color,
                          ),
                        ),
                        Text(
                          '${item['count']} ulasan',
                          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Word Cloud Kata Kunci Utama
            const Text(
              'Kata Kunci Terbanyak (Word Cloud Insight)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _keywords.map((kw) {
                final category = kw['category'] as String;
                Color chipColor;
                if (category == 'Positif') {
                  chipColor = AppColors.primary;
                } else if (category == 'Negatif') {
                  chipColor = AppColors.error;
                } else {
                  chipColor = AppColors.secondaryDark;
                }

                return Chip(
                  avatar: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      '${kw['count']}',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: chipColor),
                    ),
                  ),
                  label: Text(
                    kw['word'] as String,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: chipColor,
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // Sampel Ulasan Langsung
            const Text(
              'Sampel Ulasan Terakhir Siswa',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recentReviews.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final rev = _recentReviews[index];
                final isPos = rev['sentiment'] == 'Positif';
                final isNeg = rev['sentiment'] == 'Negatif';
                final badgeColor = isPos
                    ? AppColors.primary
                    : isNeg
                        ? AppColors.error
                        : AppColors.secondaryDark;

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            rev['student']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: badgeColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              rev['sentiment']!,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: badgeColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Menu: ${rev['menu']}',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '"${rev['review']}"',
                        style: const TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: AppColors.textPrimary,
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


