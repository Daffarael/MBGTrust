import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/mock_data.dart';
import '../../../core/theme/app_colors.dart';
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
                  Image.network(
                    photoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(
                      color: AppColors.primaryLight,
                      child: const Center(
                        child: Icon(
                          Icons.restaurant_menu_rounded,
                          size: 60,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
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
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Program Gizi Gratis',
                            style: TextStyle(
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
                            color: AppColors.secondaryLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: AppColors.secondary,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondaryDark,
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

          // Main Menu Content Body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateFormatted,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nutrition Badges Row
                  const Text(
                    'Kandungan Gizi per Porsi:',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildNutritionBadge(
                        label: 'Energi',
                        value: '$calories kcal',
                        icon: Icons.local_fire_department_rounded,
                        color: AppColors.secondary,
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
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(width: 8),
                      _buildNutritionBadge(
                        label: 'Lemak',
                        value: fats,
                        icon: Icons.opacity_rounded,
                        color: Colors.orangeAccent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Ingredients Section
                  const Text(
                    'Bahan Makanan Sehat:',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: const [
                        _IngredientTile(
                          name: 'Dada Ayam Bakar Kecap',
                          portion: '80 gram',
                          note: 'Sumber Utama Protein & Zat Besi',
                        ),
                        Divider(height: 16, color: AppColors.border),
                        _IngredientTile(
                          name: 'Tumis Buncis & Wortel',
                          portion: '60 gram',
                          note: 'Kaya Serat & Vitamin A',
                        ),
                        Divider(height: 16, color: AppColors.border),
                        _IngredientTile(
                          name: 'Nasi Putih Warm',
                          portion: '150 gram',
                          note: 'Karbohidrat Kompleks',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Interactive Rating Section (Gamification trigger handled inside)
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
        ],
      ),
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
