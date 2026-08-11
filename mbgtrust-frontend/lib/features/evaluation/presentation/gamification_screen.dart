import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/student_bottom_nav_bar.dart';
import '../../auth/presentation/providers/auth_provider.dart';

class GamificationScreen extends ConsumerStatefulWidget {
  final bool justEvaluated;

  const GamificationScreen({
    super.key,
    this.justEvaluated = false,
  });

  @override
  ConsumerState<GamificationScreen> createState() => _GamificationScreenState();
}

class _GamificationScreenState extends ConsumerState<GamificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showRankUpAnimation = false;

  final List<Map<String, dynamic>> _leaderboard = [
    {
      'rank': 1,
      'name': 'Faizullatif Fajran',
      'class': 'Kelas XII.FA-3',
      'xp': 1250,
      'wasteSavedKg': 4.2,
      'icon': Icons.workspace_premium_rounded,
      'iconColor': Color(0xFFD97706),
    },
    {
      'rank': 2,
      'name': 'Siti Nurhaliza',
      'class': 'Kelas XII.IPA-1',
      'xp': 1180,
      'wasteSavedKg': 3.9,
      'icon': Icons.military_tech_rounded,
      'iconColor': Color(0xFF64748B),
    },
    {
      'rank': 3,
      'name': 'Ahmad Fauzi',
      'class': 'Kelas XI.IPS-2',
      'xp': 1050,
      'wasteSavedKg': 3.5,
      'icon': Icons.stars_rounded,
      'iconColor': Color(0xFFB45309),
    },
    {
      'rank': 4,
      'name': 'Dewi Lestari',
      'class': 'Kelas XI.IPA-3',
      'xp': 920,
      'wasteSavedKg': 3.1,
      'icon': Icons.star_outline_rounded,
      'iconColor': AppColors.primary,
    },
    {
      'rank': 5,
      'name': 'Rizky Pratama',
      'class': 'Kelas X.1',
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
      'unlocked': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (widget.justEvaluated) {
      _showRankUpAnimation = true;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primary,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryDark, AppColors.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.emoji_events_rounded, color: AppColors.secondary, size: 20),
            ),
            const SizedBox(width: 8),
            const Text(
              'Papan Peringkat & Dampak',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.secondary,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(icon: Icon(Icons.emoji_events_rounded, size: 18), text: 'Papan Peringkat'),
            Tab(icon: Icon(Icons.eco_rounded, size: 18), text: 'Dampak Lingkungan'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildLeaderboardTab(),
            _buildImpactTab(),
          ],
        ),
      ),
      bottomNavigationBar: const StudentBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildLeaderboardTab() {
    final user = ref.watch(authProvider).user;
    final studentName = user?.namaLengkap ?? 'Faizullatif Fajran';
    final schoolName = user?.namaSekolah ?? 'MAN 2 Kota Padang';

    _leaderboard[0]['name'] = studentName;
    if (user?.tingkatKelas != null) {
      _leaderboard[0]['class'] = 'Kelas ${user!.tingkatKelas}';
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rank-Up Celebration Animated Banner
          if (_showRankUpAnimation) ...[
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFF59E0B), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.25),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.stars_rounded, color: Color(0xFFD97706), size: 24),
                                SizedBox(width: 8),
                                Text(
                                  'NAIK PERINGKAT SISWA! 🎉',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF92400E),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF92400E)),
                              onPressed: () => setState(() => _showRankUpAnimation = false),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Selamat! Ulasan & presensi MBG kamu baru saja menambah +50 XP. Posisi kamu naik ke Peringkat #1 Pahlawan Makanan!',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFB45309),
                            height: 1.3,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
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
                    children: [
                      Text(
                        studentName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Pahlawan Makanan Level 4 • $schoolName',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
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
