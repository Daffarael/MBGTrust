import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/responsive_layout.dart';

class GamificationScreen extends StatefulWidget {
  const GamificationScreen({super.key});

  @override
  State<GamificationScreen> createState() => _GamificationScreenState();
}

class _GamificationScreenState extends State<GamificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _leaderboard = [
    {
      'rank': 1,
      'name': 'Budi Santoso',
      'class': 'Kelas 5-A',
      'xp': 1250,
      'wasteSavedKg': 4.2,
      'icon': Icons.workspace_premium_rounded,
      'iconColor': Color(0xFFD97706),
    },
    {
      'rank': 2,
      'name': 'Siti Nurhaliza',
      'class': 'Kelas 5-B',
      'xp': 1180,
      'wasteSavedKg': 3.9,
      'icon': Icons.military_tech_rounded,
      'iconColor': Color(0xFF64748B),
    },
    {
      'rank': 3,
      'name': 'Ahmad Fauzi',
      'class': 'Kelas 5-A',
      'xp': 1050,
      'wasteSavedKg': 3.5,
      'icon': Icons.stars_rounded,
      'iconColor': Color(0xFFB45309),
    },
    {
      'rank': 4,
      'name': 'Dewi Lestari',
      'class': 'Kelas 4-C',
      'xp': 920,
      'wasteSavedKg': 3.1,
      'icon': Icons.star_outline_rounded,
      'iconColor': AppColors.primary,
    },
    {
      'rank': 5,
      'name': 'Rizky Pratama',
      'class': 'Kelas 5-A',
      'xp': 850,
      'wasteSavedKg': 2.8,
      'icon': Icons.verified_user_rounded,
      'iconColor': AppColors.primary,
    },
  ];

  final List<Map<String, dynamic>> _badges = [
    {
      'iconData': Icons.cleaning_services_rounded,
      'title': 'Piring Bersih 7 Hari',
      'desc': 'Menghabiskan makanan 7 hari berturut-turut',
      'unlocked': true,
    },
    {
      'iconData': Icons.eco_rounded,
      'title': 'Pahlawan Lingkungan',
      'desc': 'Berhasil mencegah 3 kg food waste',
      'unlocked': true,
    },
    {
      'iconData': Icons.access_time_filled_rounded,
      'title': 'Tepat Waktu',
      'desc': 'Mengonfirmasi presensi harian tepat waktu',
      'unlocked': true,
    },
    {
      'iconData': Icons.emoji_events_rounded,
      'title': 'Top 3 Peringkat',
      'desc': 'Masuk peringkat 3 besar siswa terhemat sekolah',
      'unlocked': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      appBar: AppBar(
        title: const Text(
          'Papan Peringkat & Dampak',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(icon: Icon(Icons.emoji_events_rounded), text: 'Papan Peringkat'),
            Tab(icon: Icon(Icons.eco_rounded), text: 'Dampak Lingkungan'),
          ],
        ),
      ),
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildLeaderboardTab(),
          _buildImpactTab(),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Profile Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.workspace_premium_rounded, size: 36, color: AppColors.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Budi Santoso',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Pahlawan Makanan Level 4 • SDN 01 Menteng',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '1.250 XP • Peringkat #1 di Sekolah',
                        style: TextStyle(
                          color: AppColors.secondaryLight,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Papan Peringkat Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Top Siswa Terhemat Makanan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Bulan Ini',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Leaderboard List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _leaderboard.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = _leaderboard[index];
              final isMe = index == 0;
              final IconData iconData = item['icon'] as IconData;
              final Color iconColor = item['iconColor'] as Color;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isMe ? AppColors.primaryLight.withValues(alpha: 0.4) : AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isMe ? AppColors.primary : AppColors.border,
                    width: isMe ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 28,
                      child: Text(
                        '#${item['rank']}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: index < 3 ? AppColors.secondaryDark : AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Icon(iconData, color: iconColor, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${item['class']} • ${item['wasteSavedKg']} kg diselamatkan',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${item['xp']} XP',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImpactTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dampak Nyata Kontribusimu',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Setiap porsi makanan yang kamu habiskan membantu menjaga bumi dari emisi gas rumah kaca.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),

          // 3 Environmental Metrics Grid
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  iconData: Icons.eco_rounded,
                  title: '4.2 kg',
                  subtitle: 'Emisi CO₂ Tercegah',
                  color: AppColors.primaryLight,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  iconData: Icons.water_drop_rounded,
                  title: '120 Liter',
                  subtitle: 'Air Bersih Dihemat',
                  color: const Color(0xFFE0F2FE),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  iconData: Icons.restaurant_rounded,
                  title: '14 Porsi',
                  subtitle: 'Makanan Diselamatkan',
                  color: AppColors.secondaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Badges Section
          const Text(
            'Lencana Penghargaan Siswa',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _badges.length,
            itemBuilder: (context, index) {
              final badge = _badges[index];
              final isUnlocked = badge['unlocked'] as bool;
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isUnlocked ? AppColors.surface : AppColors.border.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isUnlocked ? AppColors.primary.withValues(alpha: 0.5) : AppColors.border,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      badge['iconData'] as IconData,
                      size: 32,
                      color: isUnlocked ? AppColors.primary : AppColors.textLight,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      badge['title'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isUnlocked ? AppColors.textPrimary : AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      badge['desc'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        color: isUnlocked ? AppColors.textSecondary : AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData iconData,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(iconData, size: 28, color: AppColors.primaryDark),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
