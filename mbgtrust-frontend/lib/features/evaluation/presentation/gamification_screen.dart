import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/mbgtrust_logo.dart';
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
  int _selectedScopeIndex = 0; // 0: Kelas, 1: Sekolah, 2: Kota, 3: Provinsi, 4: Nasional
  int _currentPage = 1;
  int _rowsPerPage = 10; // 10, 25, 50, 0 (Semua)

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
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
    // 1. Otomatis beralih ke halaman paginasi tempat posisi peringkat siswa berada
    if (_rowsPerPage > 0) {
      final int targetPage = (rank / _rowsPerPage).ceil();
      if (_currentPage != targetPage) {
        setState(() {
          _currentPage = targetPage;
        });
      }
    }

    // 2. Setelah halaman di-render, luncurkan scroll ke ubin kartu siswa pada halaman tersebut
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      final int startIndex = _rowsPerPage == 0 ? 0 : (_currentPage - 1) * _rowsPerPage;
      final int itemIndexInPage = (rank - 1 - startIndex).clamp(0, _rowsPerPage > 0 ? _rowsPerPage - 1 : 49);

      const double itemHeight = 74.0;
      final double targetItemTop = itemIndexInPage * itemHeight;

      final double maxScroll = _scrollController.position.maxScrollExtent;
      double targetOffset = targetItemTop;
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
    });
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
    final int currentRankNumber = _isRankedUp ? 15 : 30;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Sticky Container (Brand Logo + Live User Rank + Dynamic Segmented Bar + Title & Locator + Scope Filter Pills)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: const Border(bottom: BorderSide(color: AppColors.border, width: 1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: Logo MBGTrust & User Rank Badge (Konsisten 100% dengan Profile & Home)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: const [
                            MbgTrustLogo(size: 30),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'MBGTrust',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDark,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.emoji_events_rounded, color: AppColors.primaryDark, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '#$currentRankNumber (${_isRankedUp ? '1.402' : '922'} XP)',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Row 2: Dynamic Segmented Bar
                  Container(
                    height: 44,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        _buildDynamicTabItem(
                          index: 0,
                          icon: Icons.emoji_events_rounded,
                          label: 'Peringkat',
                        ),
                        const SizedBox(width: 4),
                        _buildDynamicTabItem(
                          index: 1,
                          icon: Icons.workspace_premium_rounded,
                          label: 'Lencana',
                        ),
                        const SizedBox(width: 4),
                        _buildDynamicTabItem(
                          index: 2,
                          icon: Icons.eco_rounded,
                          label: 'Dampak & FAQ',
                        ),
                      ],
                    ),
                  ),

                  // Fixed Title, Description & Scope Filter Chips (Hanya saat Tab Peringkat Aktif)
                  if (_tabController.index == 0) ...[
                    const SizedBox(height: 8),
                    // Row 3: Title & Locator Button 'Posisi Saya'
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Leaderboard Gizi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _scrollToUserRank(currentRankNumber, animate: true, duration: const Duration(milliseconds: 1400));
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(Icons.my_location_rounded, color: Colors.white, size: 18),
                                    const SizedBox(width: 8),
                                    Text('Posisi Anda berada di peringkat #$currentRankNumber!'),
                                  ],
                                ),
                                backgroundColor: AppColors.primaryDark,
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.my_location_rounded, color: AppColors.primaryDark, size: 13),
                                const SizedBox(width: 4),
                                Text(
                                  'Posisi Saya (#$currentRankNumber)',
                                  style: const TextStyle(
                                    fontSize: 10.5,
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
                    const SizedBox(height: 8),

                    // Row 4: Scope Filter Pills (Urutan: Kelas -> Sekolah -> Kota -> Provinsi -> Nasional)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildScopeFilterChip(
                            icon: Icons.class_rounded,
                            label: 'Kelas XI IPA 1',
                            isSelected: _selectedScopeIndex == 0,
                            onTap: () => setState(() {
                              _selectedScopeIndex = 0;
                              _currentPage = 1;
                            }),
                          ),
                          const SizedBox(width: 6),
                          _buildScopeFilterChip(
                            icon: Icons.school_rounded,
                            label: 'MAN 2 Kota Padang',
                            isSelected: _selectedScopeIndex == 1,
                            onTap: () => setState(() {
                              _selectedScopeIndex = 1;
                              _currentPage = 1;
                            }),
                          ),
                          const SizedBox(width: 6),
                          _buildScopeFilterChip(
                            icon: Icons.location_city_rounded,
                            label: 'Kota Padang',
                            isSelected: _selectedScopeIndex == 2,
                            onTap: () => setState(() {
                              _selectedScopeIndex = 2;
                              _currentPage = 1;
                            }),
                          ),
                          const SizedBox(width: 6),
                          _buildScopeFilterChip(
                            icon: Icons.account_balance_rounded,
                            label: 'Sumatera Barat',
                            isSelected: _selectedScopeIndex == 3,
                            onTap: () => setState(() {
                              _selectedScopeIndex = 3;
                              _currentPage = 1;
                            }),
                          ),
                          const SizedBox(width: 6),
                          _buildScopeFilterChip(
                            icon: Icons.public_rounded,
                            label: 'Nasional (SPPG BGN)',
                            isSelected: _selectedScopeIndex == 4,
                            onTap: () => setState(() {
                              _selectedScopeIndex = 4;
                              _currentPage = 1;
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Tab Content View Scrollable (Langsung Murni Leaderboard di Bawah Filter)
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildLeaderboardTab(),
                  _buildBadgesTab(),
                  _buildImpactTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const StudentBottomNavBar(currentIndex: 0),
    );
  }

  /// Tab 1: Papan Peringkat Siswa (Paginasi + Seluruh Siswa)
  Widget _buildLeaderboardTab() {
    final fullList = _generateLeaderboardData(rankedUp: _isRankedUp);
    final int totalItems = fullList.length;
    final int totalPages = _rowsPerPage == 0 ? 1 : (totalItems / _rowsPerPage).ceil();

    final int startIndex = _rowsPerPage == 0 ? 0 : (_currentPage - 1) * _rowsPerPage;
    final int endIndex = _rowsPerPage == 0 ? totalItems : (startIndex + _rowsPerPage).clamp(0, totalItems);
    final currentList = fullList.sublist(startIndex, endIndex);

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Daftar Siswa dengan Animasi Perpindahan Posisi & Paginasi (Langsung Murni Leaderboard)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            switchInCurve: Curves.easeOutBack,
            switchOutCurve: Curves.easeIn,
            child: ListView.separated(
              key: ValueKey('${_isRankedUp}_${_selectedScopeIndex}_${_currentPage}_$_rowsPerPage'),
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
          const SizedBox(height: 16),

          // Kontrol Baris per Halaman & Pagination Navigation (Next / Prev)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tampilkan per Halaman:',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Row(
                      children: [10, 25, 50, 0].map((size) {
                        final bool isSelected = _rowsPerPage == size;
                        final String label = size == 0 ? 'Semua' : '$size';
                        return Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _rowsPerPage = size;
                                _currentPage = 1;
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : AppColors.background,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.border,
                                ),
                              ),
                              child: Text(
                                label,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                if (_rowsPerPage != 0 && totalPages > 1) ...[
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _currentPage > 1
                            ? () {
                                setState(() {
                                  _currentPage--;
                                });
                                _scrollController.animateTo(
                                  0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              }
                            : null,
                        icon: const Icon(Icons.chevron_left_rounded),
                        color: AppColors.primary,
                      ),
                      Text(
                        'Halaman $_currentPage dari $totalPages ($totalItems Siswa)',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        onPressed: _currentPage < totalPages
                            ? () {
                                setState(() {
                                  _currentPage++;
                                });
                                _scrollController.animateTo(
                                  0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              }
                            : null,
                        icon: const Icon(Icons.chevron_right_rounded),
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 80),
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
    final double userWasteSaved = _isRankedUp ? 2.3 : 1.8;
    final double userCo2Saved = double.parse((userWasteSaved * 2.5).toStringAsFixed(2));
    final int userWaterSaved = (userWasteSaved * 300).round();
    final int userPortionsSaved = (userWasteSaved * 3.5).round();
    final int userShowersSaved = (userWaterSaved / 20).round();

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

          // 3 Metric Cards Berbasis Data Ilmiah Dinamis
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  iconData: Icons.restaurant_rounded,
                  title: '${userWasteSaved.toStringAsFixed(1)} kg',
                  subtitle: 'Food Waste Diselamatkan',
                  color: AppColors.primaryLight,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricCard(
                  iconData: Icons.eco_rounded,
                  title: '${userCo2Saved.toStringAsFixed(2)} kg',
                  subtitle: 'Emisi CO₂ Tercegah',
                  color: const Color(0xFFDCFCE7),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricCard(
                  iconData: Icons.water_drop_rounded,
                  title: '$userWaterSaved Liter',
                  subtitle: 'Air Bersih Dihemat',
                  color: const Color(0xFFE0F2FE),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Kartu Penjelasan Edukatif Berbasis Fakta Lingkungan Dinamis
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
            title: '$userPortionsSaved Porsi Makanan Seimbang',
            description: 'Total ${userWasteSaved.toStringAsFixed(1)} kg sisa makanan yang kamu hindari setara dengan menyelamatkan $userPortionsSaved porsi nutrisi seimbang bagi yang membutuhkan.',
          ),
          const SizedBox(height: 10),
          _buildImpactEquivalencyCard(
            icon: Icons.park_rounded,
            color: AppColors.primary,
            title: 'Pencegahan ${userCo2Saved.toStringAsFixed(2)} kg CO₂e',
            description: 'Mengurangi sampah organik dari TPA mencegah emisi gas metana yang setara dengan daya serap karbon 1 pohon rindang.',
          ),
          const SizedBox(height: 10),
          _buildImpactEquivalencyCard(
            icon: Icons.shower_rounded,
            color: const Color(0xFF0284C7),
            title: '$userWaterSaved Liter Air Virtual Pertanian',
            description: 'Menjaga air yang digunakan untuk irigasi bahan pangan lokal setara dengan $userShowersSaved kali alokasi kebutuhan air mandi harian.',
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
                        'Pahlawan Piring Bersih MBG Indonesia',
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
          const SizedBox(height: 24),

          // Seksi FAQ & Edukasi MBG
          const Text(
            'Pertanyaan Sering Diajukan (FAQ)',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          _buildFaqItem(
            question: 'Bagaimana cara mengumpulkan XP dan naik peringkat?',
            answer: 'XP didapatkan secara otomatis setiap kali kamu mengonfirmasi presensi makan siang (+50 XP), menghabiskan porsi tanpa sisa (+50 XP), dan mengirim ulasan evaluasi harian.',
          ),
          const SizedBox(height: 8),
          _buildFaqItem(
            question: 'Bagaimana cara membuka Lencana Prestasi Gizi?',
            answer: 'Lencana prestasi seperti "Penyelamat Pangan" atau "Presensi Disiplin" otomatis terbuka ketika kamu mencapai milestone presensi harian secara konsisten.',
          ),
          const SizedBox(height: 8),
          _buildFaqItem(
            question: 'Mengapa piring bersih bermanfaat bagi lingkungan?',
            answer: 'Menghabiskan makanan mencegah terbentuknya gas metana (CO₂e) di TPA dan menghemat ratusan liter air virtual yang digunakan petani dalam proses budidaya pangan.',
          ),
          const SizedBox(height: 8),
          _buildFaqItem(
            question: 'Bagaimana jika saya memiliki alergi terhadap menu hari ini?',
            answer: 'Kamu dapat memperbarui preferensi alergen di menu Profil > Preferensi Alergen. Dapur SPPG akan menyesuaikan variasi menu aman khusus untuk kebutuhan medismu.',
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        iconColor: AppColors.primary,
        collapsedIconColor: AppColors.textSecondary,
        leading: const Icon(Icons.help_outline_rounded, color: AppColors.primary, size: 20),
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        children: [
          Text(
            answer,
            style: const TextStyle(
              fontSize: 11.5,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
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

  Widget _buildScopeFilterChip({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicTabItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected = _tabController.index == index;

    return Expanded(
      flex: isSelected ? 2 : 1,
      child: GestureDetector(
        onTap: () {
          _tabController.animateTo(index);
          setState(() {});
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              if (isSelected) ...[
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
