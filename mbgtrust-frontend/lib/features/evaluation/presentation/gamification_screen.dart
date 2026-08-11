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
  bool _isRankedUp = false;

  // Data Papan Peringkat Awal (Faizullatif Fajran berada di Peringkat #4 sebelum evaluasi)
  final List<Map<String, dynamic>> _initialLeaderboard = [
    {
      'id': 'usr_2',
      'rank': 1,
      'name': 'Siti Nurhaliza',
      'class': 'Kelas XII.IPA-1',
      'xp': 1250,
      'wasteSavedKg': 4.2,
      'icon': Icons.workspace_premium_rounded,
      'iconColor': Color(0xFFD97706),
      'isUser': false,
    },
    {
      'id': 'usr_3',
      'rank': 2,
      'name': 'Ahmad Fauzi',
      'class': 'Kelas XI.IPS-2',
      'xp': 1180,
      'wasteSavedKg': 3.9,
      'icon': Icons.military_tech_rounded,
      'iconColor': Color(0xFF64748B),
      'isUser': false,
    },
    {
      'id': 'usr_4',
      'rank': 3,
      'name': 'Dewi Lestari',
      'class': 'Kelas XI.IPA-3',
      'xp': 1050,
      'wasteSavedKg': 3.5,
      'icon': Icons.stars_rounded,
      'iconColor': Color(0xFFB45309),
      'isUser': false,
    },
    {
      'id': 'usr_1',
      'rank': 4,
      'name': 'Faizullatif Fajran',
      'class': 'Kelas XII.FA-3',
      'xp': 950,
      'wasteSavedKg': 3.1,
      'icon': Icons.star_outline_rounded,
      'iconColor': AppColors.primary,
      'isUser': true,
    },
    {
      'id': 'usr_5',
      'rank': 5,
      'name': 'Rizky Pratama',
      'class': 'Kelas X.1',
      'xp': 850,
      'wasteSavedKg': 2.8,
      'icon': Icons.verified_user_rounded,
      'iconColor': AppColors.primary,
      'isUser': false,
    },
  ];

  // Data Papan Peringkat Setelah Evaluasi (Faizullatif Fajran NAIK PERINGKAT ke #1)
  final List<Map<String, dynamic>> _rankedUpLeaderboard = [
    {
      'id': 'usr_1',
      'rank': 1,
      'name': 'Faizullatif Fajran',
      'class': 'Kelas XII.FA-3',
      'xp': 1300,
      'wasteSavedKg': 4.5,
      'icon': Icons.workspace_premium_rounded,
      'iconColor': Color(0xFFD97706),
      'isUser': true,
    },
    {
      'id': 'usr_2',
      'rank': 2,
      'name': 'Siti Nurhaliza',
      'class': 'Kelas XII.IPA-1',
      'xp': 1250,
      'wasteSavedKg': 4.2,
      'icon': Icons.military_tech_rounded,
      'iconColor': Color(0xFF64748B),
      'isUser': false,
    },
    {
      'id': 'usr_3',
      'rank': 3,
      'name': 'Ahmad Fauzi',
      'class': 'Kelas XI.IPS-2',
      'xp': 1180,
      'wasteSavedKg': 3.9,
      'icon': Icons.stars_rounded,
      'iconColor': Color(0xFFB45309),
      'isUser': false,
    },
    {
      'id': 'usr_4',
      'rank': 4,
      'name': 'Dewi Lestari',
      'class': 'Kelas XI.IPA-3',
      'xp': 1050,
      'wasteSavedKg': 3.5,
      'icon': Icons.star_outline_rounded,
      'iconColor': AppColors.primary,
      'isUser': false,
    },
    {
      'id': 'usr_5',
      'rank': 5,
      'name': 'Rizky Pratama',
      'class': 'Kelas X.1',
      'xp': 850,
      'wasteSavedKg': 2.8,
      'icon': Icons.verified_user_rounded,
      'iconColor': AppColors.primary,
      'isUser': false,
    },
  ];



  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (widget.justEvaluated) {
      _triggerRankUpSequence();
    }
  }

  void _triggerRankUpSequence() {
    setState(() {
      _isRankedUp = false;
      _showRankUpAnimation = true;
    });

    // Menjalankan sekuens animasi perpindahan peringkat dari #4 ke #1 secara otomatis!
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() {
          _isRankedUp = true;
        });
      }
    });
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
      bottomNavigationBar: const StudentBottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildLeaderboardTab() {
    final user = ref.watch(authProvider).user;
    final studentName = user?.namaLengkap ?? 'Faizullatif Fajran';
    final schoolName = user?.namaSekolah ?? 'MAN 2 Kota Padang';

    final currentList = _isRankedUp ? _rankedUpLeaderboard : _initialLeaderboard;

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
                                  'SELEBRASI NAIK PERINGKAT! 🎉',
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
                        Text(
                          _isRankedUp
                              ? 'Selamat Faizullatif! Ulasan jujur kamu berhasil menambah +350 XP. Posisi kamu NAIK PERINGKAT dari #4 ke #1 Pahlawan Makanan Sekolah!'
                              : 'Memproses penambahan +350 XP presensi & ulasan MBG hari ini...',
                          style: const TextStyle(
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

          // Hero Profile Card (Animated Rank & XP)
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isRankedUp
                    ? [const Color(0xFF047857), const Color(0xFF065F46)]
                    : [AppColors.primary, AppColors.primaryDark],
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
                  child: Icon(
                    _isRankedUp ? Icons.workspace_premium_rounded : Icons.star_rounded,
                    size: 36,
                    color: _isRankedUp ? const Color(0xFFD97706) : AppColors.primary,
                  ),
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
                        'Pahlawan Makanan • $schoolName',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: Text(
                          _isRankedUp
                              ? '1.300 XP • Peringkat #1 di Sekolah 🎉'
                              : '950 XP • Peringkat #4 di Sekolah',
                          key: ValueKey(_isRankedUp),
                          style: const TextStyle(
                            color: AppColors.secondaryLight,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Papan Peringkat Header & Simulasi Button (Siswa Teladan Gizi)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Siswa Teladan Gizi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: _triggerRankUpSequence,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.flash_on_rounded, size: 14, color: AppColors.primaryDark),
                      SizedBox(width: 4),
                      Text(
                        'Simulasi Naik',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Leaderboard List (Animated Item Swap)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            switchInCurve: Curves.easeOutBack,
            switchOutCurve: Curves.easeIn,
            child: ListView.separated(
              key: ValueKey(_isRankedUp),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: currentList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = currentList[index];
                final bool isUser = item['isUser'] as bool? ?? false;
                final IconData iconData = item['icon'] as IconData;
                final Color iconColor = item['iconColor'] as Color;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isUser
                        ? AppColors.primaryLight.withValues(alpha: 0.6)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isUser ? AppColors.primary : AppColors.border,
                      width: isUser ? 2.0 : 1.0,
                    ),
                    boxShadow: isUser
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
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
                            Row(
                              children: [
                                Text(
                                  item['name'] as String,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isUser ? AppColors.primaryDark : AppColors.textPrimary,
                                  ),
                                ),
                                if (isUser) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'Saya',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            Text(
                              item['class'] as String,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${item['xp']} XP',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            '${item['wasteSavedKg']} kg hemat',
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
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
            'Dampak Nyata Aksi Gizi Siswa',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Dengan menghabiskan porsi MBG harian, kamu aktif menyelamatkan sumber daya alam & mendukung keberlanjutan program gizi sekolah!',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
          ),
          const SizedBox(height: 16),

          // 3 Environmental & Social Metric Cards
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  iconData: Icons.restaurant_rounded,
                  title: '4.2 kg',
                  subtitle: 'Food Waste Diselamatkan',
                  color: AppColors.primaryLight,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricCard(
                  iconData: Icons.eco_rounded,
                  title: '12.6 kg',
                  subtitle: 'Emisi CO₂ Tercegah',
                  color: const Color(0xFFDCFCE7),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricCard(
                  iconData: Icons.water_drop_rounded,
                  title: '360 Liter',
                  subtitle: 'Air Bersih Dihemat',
                  color: const Color(0xFFE0F2FE),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Kartu Analogi Dampak Nyata
          const Text(
            'Setara Dampak Nyata di Lingkungan:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          _buildImpactEquivalencyCard(
            icon: Icons.groups_rounded,
            color: const Color(0xFFD97706),
            title: '14 Porsi Makanan Utuh',
            description: 'Jumlah makanan yang berhasil kamu hemat setara dengan memberi makan 14 porsi tambahan bagi yang membutuhkan!',
          ),
          const SizedBox(height: 10),
          _buildImpactEquivalencyCard(
            icon: Icons.park_rounded,
            color: AppColors.primary,
            title: 'Menanam 2 Pohon Rindang',
            description: 'Pencegahan gas metana dari food waste setara dengan manfaat penyerapan karbon oleh 2 pohon di MAN 2 Kota Padang.',
          ),
          const SizedBox(height: 10),
          _buildImpactEquivalencyCard(
            icon: Icons.shower_rounded,
            color: const Color(0xFF0284C7),
            title: '18 Kali Mandi Bersih',
            description: 'Penghematan air virtual bahan pertanian yang kamu jaga setara dengan 18 kali alokasi mandi harian.',
          ),

          const SizedBox(height: 28),

          // Banner Ajakan Pahlawan Piring Bersih
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF065F46), Color(0xFF047857)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF047857).withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: const [
                Icon(Icons.volunteer_activism_rounded, color: Color(0xFFFDE68A), size: 36),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jadilah Pahlawan Piring Bersih!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Ajak teman sekelasmu untuk selalu mengonsumsi porsi MBG secara bijak setiap hari.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildImpactEquivalencyCard({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(iconData, color: AppColors.primaryDark, size: 22),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
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
