import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/mock_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';
import 'rating_section.dart';

class MenuDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? menuData;

  const MenuDetailScreen({
    super.key,
    this.menuData,
  });

  @override
  State<MenuDetailScreen> createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  late Map<String, dynamic> _menu;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _menu = widget.menuData ?? MockData.todayMenu;
  }

  @override
  Widget build(BuildContext context) {
    final title = _menu['nama_menu'] ?? _menu['name'] ?? 'Nasi Ayam Bakar Kecap & Tumis Buncis';
    final calories = (_menu['kalori_kkal'] ?? _menu['calories'] ?? 550).toString();
    final protein = '${_menu['protein_gram'] ?? 28.5}g';
    final carbs = '${_menu['karbohidrat_gram'] ?? 65.0}g';
    final fats = '${_menu['lemak_gram'] ?? 14.2}g';
    final photoUrl = _menu['foto_url'] ?? _menu['photoUrl'] ??
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80';
    final rating = (_menu['rating_rata_rata'] ?? _menu['rating'] ?? 4.9 as num).toDouble();
    final dateFormatted = _menu['tanggal_jadwal'] as String? ?? 'Sabtu, 8 Agustus 2026';

    final isPreview = (_menu['isPreview'] as bool?) ?? false;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Large Hero Image Sliver AppBar
          SliverAppBar(
            expandedHeight: 280.0,
            pinned: true,
            backgroundColor: AppColors.surface,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 18),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/home');
                  }
                },
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    _isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: _isFavorite ? AppColors.error : Colors.white,
                    size: 22,
                  ),
                  onPressed: () {
                    setState(() => _isFavorite = !_isFavorite);
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  MbgFoodImage(
                    imageUrl: photoUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isPreview ? const Color(0xFFD97706) : AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isPreview ? 'Pratinjau Menu Esok Hari' : 'Program Gizi Gratis',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isPreview ? const Color(0xFFFEF3C7) : AppColors.secondaryLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isPreview ? Icons.schedule_rounded : Icons.star_rounded,
                                color: isPreview ? const Color(0xFFD97706) : AppColors.secondary,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isPreview ? 'Belum Disajikan' : rating.toStringAsFixed(1),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isPreview ? const Color(0xFF92400E) : AppColors.secondaryDark,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Scrollable Menu Details Body
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.background,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title & Date Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dateFormatted,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Nutrition Cards Grid Row
                    Row(
                      children: [
                        _buildNutritionBadge(
                          label: 'Energi',
                          value: '$calories kkal',
                          icon: Icons.local_fire_department_rounded,
                          color: const Color(0xFFEF4444),
                        ),
                        const SizedBox(width: 8),
                        _buildNutritionBadge(
                          label: 'Protein',
                          value: protein,
                          icon: Icons.fitness_center_rounded,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        _buildNutritionBadge(
                          label: 'Karbo',
                          value: carbs,
                          icon: Icons.grain_rounded,
                          color: const Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 8),
                        _buildNutritionBadge(
                          label: 'Lemak',
                          value: fats,
                          icon: Icons.opacity_rounded,
                          color: const Color(0xFF3B82F6),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Ingredients Detail List Section
                    const Text(
                      'Komposisi Bahan Makanan',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Builder(
                      builder: (context) {
                        final ingredientsDetail = (_menu['komposisi_bahan_detail'] as List<dynamic>?) ?? [];
                        final ingredients = (_menu['komposisi_bahan'] as List<dynamic>?) ?? ['Dada Ayam Bakar Kecap', 'Tumis Buncis & Wortel', 'Nasi Putih Warm'];

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            children: [
                              if (ingredientsDetail.isNotEmpty)
                                for (int i = 0; i < ingredientsDetail.length; i++) ...[
                                  if (i > 0) const Divider(height: 16, color: AppColors.border),
                                  _IngredientTile(
                                    name: ingredientsDetail[i]['nama']?.toString() ?? '',
                                    portion: ingredientsDetail[i]['berat']?.toString() ?? '',
                                    note: ingredientsDetail[i]['sub']?.toString() ?? '',
                                  ),
                                ]
                              else
                                for (int i = 0; i < ingredients.length; i++) ...[
                                  if (i > 0) const Divider(height: 16, color: AppColors.border),
                                  _IngredientTile(
                                    name: ingredients[i].toString(),
                                    portion: 'Porsi Seimbang',
                                    note: 'Bahan Baku Pilihan SPPG',
                                  ),
                                ]
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 28),

                    // Jika Pratinjau Menu Esok Hari: Tampilkan Status Rantai Pasok & Dapur SPPG (Bukan Form Ulasan)
                    if (isPreview)
                      _buildTomorrowProductionStatusSection()
                    else
                      RatingSection(
                        onSubmitted: () {
                          // Handled by Gamification Dialog inside RatingSection
                        },
                        onOpenNextDayConfirmation: () {
                          context.push('/next-day-confirmation');
                        },
                      ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTomorrowProductionStatusSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.soup_kitchen_rounded, color: AppColors.primary, size: 24),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Alur Persiapan & Pengiriman Menu Esok Hari',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Tahapan jadwal operasional Dapur SPPG MAN 2 Kota Padang:',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),

          // Timeline Menyambung Bergaris dengan Jam Operasional Dinamis
          _buildConnectedTimeline(
            steps: [
              {
                'time': '17:00 WIB',
                'title': 'Inspeksi & Verifikasi Kesegaran Bahan',
                'subtitle': 'Bahan segar lokal (protein, buah, & sayur) diperiksa tim gizi dan disimpan aman di Cold Storage SPPG.',
                'isCompleted': true,
                'isCurrent': false,
              },
              {
                'time': '04:30 WIB',
                'title': 'Olah Dapur & Pengemasan Gizi Seimbang',
                'subtitle': 'Koki SPPG mengolah masakan higienis dan mengemas porsi dalam wadah ramah lingkungan.',
                'isCompleted': false,
                'isCurrent': true,
              },
              {
                'time': '06:30 WIB',
                'title': 'Pengiriman Armada MBGTrust ke Sekolah',
                'subtitle': 'Mobil kurir khusus bertolak mengantar porsi hangat langsung dari Dapur SPPG ke MAN 2 Kota Padang.',
                'isCompleted': false,
                'isCurrent': false,
              },
              {
                'time': '07:15 WIB',
                'title': 'Tiba di Sekolah & Siap Disajikan',
                'subtitle': 'Porsi MBG diterima tim sekolah dan siap disajikan hangat bagi siswa saat jam istirahat.',
                'isCompleted': false,
                'isCurrent': false,
              },
            ],
          ),

          const SizedBox(height: 16),

          // Banner Jumlah Porsi
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: const [
                Icon(Icons.info_outline_rounded, color: AppColors.primaryDark, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Dapur SPPG menyiapkan 450 porsi seimbang sesuai standar BGN RI untuk esok hari.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Tombol Pengingat Notifikasi Presensi Besok
          CustomButton(
            text: 'Pasang Pengingat Presensi Besok',
            prefixIcon: const Icon(Icons.notifications_active_rounded, color: Colors.white, size: 18),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pengingat Berhasil Dipasang! Anda akan menerima notifikasi saat porsi MBG esok hari siap disajikan.'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConnectedTimeline({
    required List<Map<String, dynamic>> steps,
  }) {
    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final bool isLast = index == steps.length - 1;
        final bool isCompleted = step['isCompleted'] as bool;
        final bool isCurrent = step['isCurrent'] as bool;
        final String timeStr = step['time'] as String;
        final String title = step['title'] as String;
        final String subtitle = step['subtitle'] as String;

        final Color nodeColor = isCompleted
            ? AppColors.primary
            : isCurrent
                ? const Color(0xFFD97706)
                : AppColors.textLight;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Kolom 1: Lencana Waktu (Jam)
              SizedBox(
                width: 65,
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    timeStr,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isCompleted
                          ? AppColors.primaryDark
                          : isCurrent
                              ? const Color(0xFF92400E)
                              : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),

              // Kolom 2: Lingkaran Node & Garis Menyambung
              SizedBox(
                width: 28,
                child: Column(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: isCompleted || isCurrent ? nodeColor : AppColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: nodeColor, width: 2),
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                  color: const Color(0xFFD97706).withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(Icons.check_rounded, color: Colors.white, size: 13)
                            : isCurrent
                                ? const Icon(Icons.microwave_rounded, color: Colors.white, size: 11)
                                : Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: nodeColor,
                                    ),
                                  ),
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: isCompleted
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Kolom 3: Kartu Informasi Tahapan
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? const Color(0xFFFEF3C7).withValues(alpha: 0.6)
                        : isCompleted
                            ? AppColors.primaryLight.withValues(alpha: 0.3)
                            : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isCurrent
                          ? const Color(0xFFF59E0B)
                          : isCompleted
                              ? AppColors.primary.withValues(alpha: 0.3)
                              : AppColors.border,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isCurrent ? const Color(0xFF92400E) : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (isCurrent)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD97706),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Proses Aktif',
                                style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildNutritionBadge({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IngredientTile extends StatelessWidget {
  final String name;
  final String portion;
  final String note;

  const _IngredientTile({
    required this.name,
    required this.portion,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check_circle_outline_rounded,
            size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                note,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Text(
          portion,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
