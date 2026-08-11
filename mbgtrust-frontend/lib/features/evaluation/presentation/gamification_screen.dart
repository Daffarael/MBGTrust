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
  bool _isRankedUp = false;

  // 10 Lencana Prestasi Resmi MBGTrust
  final List<Map<String, dynamic>> _badges = [
    {
      'iconData': Icons.cleaning_services_rounded,
      'title': 'Pahlawan Piring Bersih',
      'desc': 'Menghabiskan 7 porsi MBG berturut-turut',
      'unlocked': true,
    },
    {
      'iconData': Icons.eco_rounded,
      'title': 'Penyelamat Pangan',
      'desc': 'Berhasil mencegah 3 kg sisa makanan (food waste)',
      'unlocked': true,
    },
    {
      'iconData': Icons.access_time_filled_rounded,
      'title': 'Presensi Disiplin',
      'desc': 'Konfirmasi konsumsi MBG 5 hari tepat waktu',
      'unlocked': true,
    },
    {
      'iconData': Icons.emoji_events_rounded,
      'title': 'Siswa Teladan Gizi',
      'desc': 'Masuk jajaran 15 besar siswa terhemat sekolah',
      'unlocked': true,
    },
    {
      'iconData': Icons.spa_rounded,
      'title': 'Sahabat Sayur & Buah',
      'desc': 'Mengulas menu berserat seimbang 10 kali',
      'unlocked': true,
    },
    {
      'iconData': Icons.water_drop_rounded,
      'title': 'Pelestari Air Bersih',
      'desc': 'Menghemat 200 liter air virtual pertanian',
      'unlocked': true,
    },
    {
      'iconData': Icons.forest_rounded,
      'title': 'Pejuang Jejak Karbon',
      'desc': 'Mencegah 10 kg emisi CO₂ sampah organik',
      'unlocked': true,
    },
    {
      'iconData': Icons.verified_user_rounded,
      'title': 'Duta Gizi Seimbang',
      'desc': 'Membantu mengulas 15 variasi menu MBG',
      'unlocked': true,
    },
    {
      'iconData': Icons.stars_rounded,
      'title': 'Bintang Komunitas',
      'desc': 'Konsisten memberikan evaluasi selama 1 bulan',
      'unlocked': false,
    },
    {
      'iconData': Icons.workspace_premium_rounded,
      'title': 'Pelopor MBG Indonesia',
      'desc': 'Menyelesaikan 30 hari presensi tanpa terputus',
      'unlocked': false,
    },
  ];

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.justEvaluated) {
        _triggerRankClimbAnimation();
      } else {
        _scrollToUserRank(30, animate: true, duration: const Duration(milliseconds: 1400));
      }
    });
  }

  void _triggerRankClimbAnimation() {
    setState(() {
      _isRankedUp = false;
    });

    // 1. Langsung ke posisi #30 terlebih dahulu
    _scrollToUserRank(30, animate: false);

    // 2. Tunda 400ms, lalu ubah ke state ranked up (#15) dan luncurkan animasi scroll meluncur naik dari #30 ke #15!
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          _isRankedUp = true;
        });
        _scrollToUserRank(15, animate: true, duration: const Duration(milliseconds: 1800));
      }
    });
  }

  void _scrollToUserRank(int rank, {bool animate = true, Duration duration = const Duration(milliseconds: 1200)}) {
    if (!_scrollController.hasClients) return;

    // Setiap ubin kartu siswa tingginya ~66px + 8px spacing = 74px
    const double itemHeight = 74.0;
    const double headerHeight = 70.0;
    final double targetItemTop = headerHeight + ((rank - 1) * itemHeight);

    final double viewportHeight = MediaQuery.of(context).size.height;
    double targetOffset = targetItemTop - (viewportHeight / 2) + (itemHeight / 2);

    final double maxScroll = _scrollController.position.maxScrollExtent;
    if (targetOffset < 0) targetOffset = 0;
    if (targetOffset > maxScroll) targetOffset = maxScroll;

    if (animate) {
      _scrollController.animateTo(
        targetOffset,
        duration: duration,
        curve: Curves.easeInOutCubic,
      );
    } else {
      _scrollController.jumpTo(targetOffset);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Membuat 50 Data Dummy Siswa Teratas MAN 2 Kota Padang
  List<Map<String, dynamic>> _generateLeaderboardData({required bool rankedUp}) {
    final List<String> studentNames = [
      'Rahmat Hidayat', 'Siti Nurhaliza', 'Ahmad Fauzi', 'Dewi Lestari', 'Rizky Pratama',
      'Nabila Zahra', 'Fajar Ramadhan', 'Putri Ananda', 'Bagas Aditya', 'Anisa Rahma',
      'Diki Kurniawan', 'Hani Fitriani', 'Irfan Maulana', 'Jihan Salsabila', 'Kiki Ardiansyah',
      'Larasati Indah', 'Muhammad Farhan', 'Nadia Syahira', 'Oki Setiawan', 'Pratama Putra',
      'Qori Amalia', 'Rian Hidayat', 'Siska Pertiwi', 'Taufik Ismail', 'Utami Dewi',
      'Vina Panduwinata', 'Wahyu Hidayat', 'Yudha Pratama', 'Zahra Annisa', 'Aldi Taher',
      'Bima Sakti', 'Cinta Laura', 'Dion Wiyoko', 'Eka Putra', 'Fani Rahma',
      'Gilang Dirga', 'Hesti Purwadinata', 'Indra Bekti', 'Julia Perez', 'Kaesang Pangarep',
      'Luna Maya', 'Miky Ferdiansyah', 'Novan Arisandi', 'Olivia Jensen', 'Pasha Ungu',
      'Raffi Ahmad', 'Sule Prikitiw', 'Tora Sudiro', 'Uya Kuya', 'Zulfikar Ali',
    ];

    final List<String> studentClasses = [
      'XII.IPA-1', 'XII.IPA-2', 'XII.IPS-1', 'XII.IPS-2', 'XI.IPA-1',
      'XI.IPA-2', 'XI.IPS-1', 'XI.IPS-2', 'X.1', 'X.2',
      'XII.FA-1', 'XII.FA-2', 'XII.FA-3', 'XI.FA-1', 'XI.FA-2',
    ];

    List<Map<String, dynamic>> list = [];
    int userTargetRank = rankedUp ? 15 : 30;

    for (int i = 1; i <= 50; i++) {
      int rankXp = 1850 - ((i - 1) * 32);
      double rankWaste = double.parse((6.2 - ((i - 1) * 0.1)).toStringAsFixed(1));
      if (rankWaste < 0.5) rankWaste = 0.5;

      if (i == userTargetRank) {
        list.add({
          'rank': i,
          'name': 'Faizullatif Fajran',
          'class': 'Kelas XII.FA-3',
          'xp': rankXp,
          'wasteSavedKg': rankWaste,
          'isUser': true,
        });
      } else {
        int nameIndex = (i - 1) % studentNames.length;
        if (studentNames[nameIndex] == 'Faizullatif Fajran') {
          nameIndex = (nameIndex + 1) % studentNames.length;
        }
        String classIndex = studentClasses[(i - 1) % studentClasses.length];

        list.add({
          'rank': i,
          'name': studentNames[nameIndex],
          'class': 'Kelas $classIndex',
          'xp': rankXp,
          'wasteSavedKg': rankWaste,
          'isUser': false,
        });
      }
    }

    return list;
  }

  void _showShareAchievementModal(BuildContext context, String badgeTitle) {
    final user = ref.read(authProvider).user;
    final studentName = user?.namaLengkap ?? 'Faizullatif Fajran';
    final schoolName = user?.namaSekolah ?? 'MAN 2 Kota Padang';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Bagikan Lencana Prestasi Gizi 🏆',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Pilih media sosial untuk membagikan pencapaian piring bersihmu:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),

              // Preview Card Sertifikat Prestasi
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF065F46), Color(0xFF047857)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF047857).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.workspace_premium_rounded, color: Color(0xFFFDE68A), size: 24),
                            SizedBox(width: 8),
                            Text(
                              'MBGTrust Certified',
                              style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _isRankedUp ? '1.402 XP' : '922 XP',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      studentName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      schoolName,
                      style: const TextStyle(fontSize: 11, color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDE68A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '🥇 Lencana: $badgeTitle',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Tombol Pilihan Media Sosial
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSocialShareItem(
                    name: 'WA Story',
                    icon: Icons.chat_bubble_rounded,
                    color: const Color(0xFF25D366),
                    onTap: () => _handleShareToSocial(bottomSheetContext, 'WhatsApp', badgeTitle),
                  ),
                  _buildSocialShareItem(
                    name: 'IG Story',
                    icon: Icons.camera_alt_rounded,
                    color: const Color(0xFFE4405F),
                    onTap: () => _handleShareToSocial(bottomSheetContext, 'Instagram Story', badgeTitle),
                  ),
                  _buildSocialShareItem(
                    name: 'Facebook',
                    icon: Icons.facebook_rounded,
                    color: const Color(0xFF1877F2),
                    onTap: () => _handleShareToSocial(bottomSheetContext, 'Facebook', badgeTitle),
                  ),
                  _buildSocialShareItem(
                    name: 'Threads',
                    icon: Icons.alternate_email_rounded,
                    color: Colors.black87,
                    onTap: () => _handleShareToSocial(bottomSheetContext, 'Threads', badgeTitle),
                  ),
                  _buildSocialShareItem(
                    name: 'Twitter (X)',
                    icon: Icons.flutter_dash_rounded,
                    color: const Color(0xFF1DA1F2),
                    onTap: () => _handleShareToSocial(bottomSheetContext, 'Twitter (X)', badgeTitle),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _handleShareToSocial(BuildContext context, String platform, String badgeTitle) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tautan lencana "$badgeTitle" telah disiapkan untuk $platform! 🎉'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildSocialShareItem({
    required String name,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Papan Peringkat & Dampak Gizi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(icon: Icon(Icons.emoji_events_rounded, size: 18), text: 'Peringkat'),
            Tab(icon: Icon(Icons.workspace_premium_rounded, size: 18), text: 'Lencana'),
            Tab(icon: Icon(Icons.eco_rounded, size: 18), text: 'Dampak'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildLeaderboardTab(),
            _buildBadgesTab(),
            _buildImpactTab(),
          ],
        ),
      ),
      bottomNavigationBar: const StudentBottomNavBar(currentIndex: 0),
    );
  }

  /// Tab 1: Papan Peringkat (50 Siswa Teratas)
  Widget _buildLeaderboardTab() {
    final currentList = _generateLeaderboardData(rankedUp: _isRankedUp);

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Judul Papan Peringkat Tanpa Dev Terms / Banner
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Siswa Teladan Gizi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: const Text(
                  '50 Siswa Teratas',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Peringkat diperbarui secara otomatis berdasarkan konsistensi presensi & piring bersih harian.',
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),

          // Daftar 50 Siswa dengan Animasi Perpindahan Posisi
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
                final bool isUser = item['isUser'] as bool;
                final int rank = item['rank'] as int;

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
                              color: AppColors.primary.withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      // Rank Badge
                      SizedBox(
                        width: 32,
                        child: Text(
                          '#$rank',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: rank <= 3
                                ? const Color(0xFFD97706)
                                : isUser
                                    ? AppColors.primaryDark
                                    : AppColors.textSecondary,
                          ),
                        ),
                      ),
                      // Rank Trophy Icon for Top 3
                      if (rank == 1)
                        const Icon(Icons.workspace_premium_rounded, color: Color(0xFFD97706), size: 22)
                      else if (rank == 2)
                        const Icon(Icons.military_tech_rounded, color: Color(0xFF64748B), size: 22)
                      else if (rank == 3)
                        const Icon(Icons.stars_rounded, color: Color(0xFFB45309), size: 22)
                      else
                        Icon(Icons.person_outline_rounded,
                            color: isUser ? AppColors.primary : AppColors.textLight, size: 20),
                      const SizedBox(width: 12),

                      // Student Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isUser ? AppColors.primaryDark : AppColors.textPrimary,
                              ),
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

                      // XP Score & Waste Saved Stat
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
                            '${item['wasteSavedKg']} kg diselamatkan',
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// Tab 2: Lencana Prestasi MBG (10 Badges + Bagikan Medsos)
  Widget _buildBadgesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Lencana Prestasi Gizi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Tekan untuk Bagikan',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Kumpulkan lencana prestasi dengan aktif mengonfirmasi presensi & menjaga piring bersih.',
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.18,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _badges.length,
            itemBuilder: (context, index) {
              final badge = _badges[index];
              final isUnlocked = badge['unlocked'] as bool;

              return InkWell(
                onTap: isUnlocked
                    ? () => _showShareAchievementModal(context, badge['title'] as String)
                    : null,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUnlocked ? AppColors.surface : AppColors.border.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isUnlocked ? AppColors.primary.withValues(alpha: 0.4) : AppColors.border,
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
                        badge['title'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isUnlocked ? AppColors.textPrimary : AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        badge['desc'] as String,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 9,
                          color: isUnlocked ? AppColors.textSecondary : AppColors.textLight,
                        ),
                      ),
                      if (isUnlocked) ...[
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.share_rounded, size: 10, color: AppColors.primary),
                            SizedBox(width: 3),
                            Text(
                              'Bagikan',
                              style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// Tab 3: Dampak Lingkungan (Scientific Facts & Educational Cards)
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
            'Berdasarkan studi Organisasi Pangan Dunia (FAO) & Kementan RI, menghabiskan porsi makanan secara bijak berdampak langsung pada kelestarian bumi.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
          ),
          const SizedBox(height: 16),

          // 3 Metric Cards Berbasis Data Ilmiah
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  iconData: Icons.restaurant_rounded,
                  title: '2.3 kg',
                  subtitle: 'Food Waste Diselamatkan',
                  color: AppColors.primaryLight,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricCard(
                  iconData: Icons.eco_rounded,
                  title: '5.75 kg',
                  subtitle: 'Emisi CO₂ Tercegah',
                  color: const Color(0xFFDCFCE7),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricCard(
                  iconData: Icons.water_drop_rounded,
                  title: '690 Liter',
                  subtitle: 'Air Bersih Dihemat',
                  color: const Color(0xFFE0F2FE),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Kartu Penjelasan Edukatif Berbasis Fakta Lingkungan
          const Text(
            'Konversi Dampak Lingkungan:',
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
            title: '8 Porsi Makanan Seimbang',
            description: 'Total 2.3 kg sisa makanan yang kamu hindari setara dengan menyelamatkan 8 porsi nutrisi seimbang bagi yang membutuhkan.',
          ),
          const SizedBox(height: 10),
          _buildImpactEquivalencyCard(
            icon: Icons.park_rounded,
            color: AppColors.primary,
            title: 'Pencegahan 5.75 kg CO₂e',
            description: 'Mengurangi sampah organik dari TPA mencegah emisi gas metana yang setara dengan daya serap karbon 1 pohon rindang.',
          ),
          const SizedBox(height: 10),
          _buildImpactEquivalencyCard(
            icon: Icons.shower_rounded,
            color: const Color(0xFF0284C7),
            title: '690 Liter Air Virtual Pertanian',
            description: 'Menjaga air yang digunakan untuk irigasi bahan pangan lokal setara dengan 34 kali alokasi kebutuhan air mandi harian.',
          ),

          const SizedBox(height: 28),

          // Banner Komitmen Kebangsaan MBG
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
                        'Pahlawan Piring Bersih MAN 2',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Setiap suapan yang dihabiskan adalah wujud apresiasi atas kerja keras petani lokal & koki dapur SPPG Indonesia.',
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
