import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/mock_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/image_utils.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../auth/presentation/profile_screen.dart';
import '../../evaluation/presentation/gamification_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // Status alur evaluasi harian siswa
  bool _hasEvaluatedToday = false;

  // Real-time Live Clock Timer
  Timer? _clockTimer;
  String _timeString = '';
  String _dateString = '';

  @override
  void initState() {
    super.initState();
    _updateClock();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _updateClock();
      }
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  void _updateClock() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');

    const days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];

    final dayName = days[now.weekday - 1];
    final monthName = months[now.month - 1];

    setState(() {
      _timeString = '$hour:$minute:$second WIB';
      _dateString = '$dayName, ${now.day} $monthName ${now.year}';
    });
  }

  void _showRejectionReasonModal(BuildContext context) {
    String selectedReason = 'Sakit / Kurang Sehat';
    final customNoteController = TextEditingController();

    final List<String> reasonOptions = [
      'Sakit / Kurang Sehat',
      'Tidak Hadir / Izin Sekolah',
      'Alergi Makanan / Pantangan Medis',
      'Pantangan Agama',
      'Lainnya',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalCtx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                top: 24,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(modalCtx).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Alasan Tidak Mengonsumsi MBG',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () => Navigator.pop(modalCtx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Pilih alasan utama mengapa kamu tidak mengonsumsi porsi MBG hari ini:',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: reasonOptions.map((reason) {
                      final isSelected = selectedReason == reason;
                      return ChoiceChip(
                        label: Text(reason),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() {
                              selectedReason = reason;
                            });
                          }
                        },
                        selectedColor: AppColors.secondaryLight,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppColors.secondaryDark : AppColors.textPrimary,
                        ),
                        side: BorderSide(
                          color: isSelected ? AppColors.secondaryDark : AppColors.border,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: customNoteController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: selectedReason == 'Lainnya'
                          ? 'Tuliskan Alasan Spesifik (Wajib)'
                          : 'Catatan Tambahan / Alasan Lainnya (Opsional)',
                      hintText: 'Misal: Membawa bekal sendiri dari rumah',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(modalCtx);
                      setState(() {
                        _hasEvaluatedToday = true;
                      });
                      _showRejectionSuccessDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Kirim Laporan Alasan',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showRejectionSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.secondaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: AppColors.secondaryDark, size: 44),
              ),
              const SizedBox(height: 14),
              const Text(
                'Laporan Alasan Diterima',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Terima kasih telah memberitahukan tim dapur SPPG. Data presensi dan evaluasimu telah diperbarui.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogCtx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _selectedTab = 0;

  Widget _buildAnimatedBottomNavBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            index: 0,
            label: 'Beranda',
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
          ),
          _buildNavItem(
            index: 1,
            label: 'Peringkat',
            icon: Icons.emoji_events_outlined,
            activeIcon: Icons.emoji_events_rounded,
          ),
          _buildNavItem(
            index: 2,
            label: 'Profil',
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
    required IconData activeIcon,
  }) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedTab == 1) {
      return Scaffold(
        body: const GamificationScreen(),
        bottomNavigationBar: _buildAnimatedBottomNavBar(),
      );
    }

    if (_selectedTab == 2) {
      return Scaffold(
        body: const ProfileScreen(),
        bottomNavigationBar: _buildAnimatedBottomNavBar(),
      );
    }

    final authState = ref.watch(authProvider);
    final user = authState.user;

    final studentName = user?.namaLengkap ?? MockData.studentProfile['name'];
    final schoolName = user?.namaSekolah ?? MockData.studentProfile['school'];
    final classGrade = user?.tingkatKelas ?? MockData.studentProfile['classGrade'];

    final todayMenu = MockData.todayMenu;
    final tomorrowMenu = MockData.tomorrowMenu;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Beranda Penerima Manfaat',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 640),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner Selamat Datang Siswa (Glassmorphic Blur Image Overlay)
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        // Background Image
                        Positioned.fill(
                          child: Image.network(
                            'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&q=80',
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => Container(
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                        // Dark Emerald Gradient Glassmorphism Overlay
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primaryDark.withValues(alpha: 0.92),
                                  AppColors.primary.withValues(alpha: 0.85),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                        ),
                        // Content Padding & Layout
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.school_rounded,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          schoolName,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.verified_rounded,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Selamat Datang,',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    studentName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    classGrade,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.25),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.access_time_filled_rounded, color: AppColors.secondary, size: 14),
                                        const SizedBox(width: 6),
                                        Text(
                                          '$_dateString • $_timeString',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Interactive Streak Presensi & Piring Bersih Card
                _buildInteractiveStreakCard(),
                const SizedBox(height: 24),

                // ==========================================
                // PRESENSI & EVALUASI MBG HARI INI
                // ==========================================
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _hasEvaluatedToday ? AppColors.primary : AppColors.border,
                      width: _hasEvaluatedToday ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.help_outline_rounded, color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Sudah Makan MBG Hari Ini?',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      if (_hasEvaluatedToday) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primary),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.check_circle_rounded, color: AppColors.primaryDark, size: 20),
                              SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'Evaluasi & Presensi Hari Ini Telah Dikirim',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  final result = await context.push<bool>(
                                    '/menu-detail',
                                    extra: todayMenu,
                                  );
                                  if (result == true) {
                                    setState(() => _hasEvaluatedToday = true);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                                label: const Text('Sudah', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  _showRejectionReasonModal(context);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.secondaryDark,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  side: const BorderSide(color: AppColors.secondaryDark),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: const Icon(Icons.highlight_off_rounded, size: 18),
                                label: const Text('Belum', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ==========================================
                // PRATINJAU MENU ESOK HARI (GAMIFIED MYSTERY CARD)
                // ==========================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pratinjau Menu Esok Hari',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _hasEvaluatedToday ? AppColors.primaryLight : const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _hasEvaluatedToday ? AppColors.primary : const Color(0xFFF59E0B),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _hasEvaluatedToday ? Icons.lock_open_rounded : Icons.lock_rounded,
                            size: 12,
                            color: _hasEvaluatedToday ? AppColors.primaryDark : const Color(0xFFB45309),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _hasEvaluatedToday ? 'Terbuka' : 'Terkunci',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _hasEvaluatedToday ? AppColors.primaryDark : const Color(0xFFB45309),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (!_hasEvaluatedToday)
                  // Locked Teaser Card ("Bikin Kepo!")
                  GestureDetector(
                    onTap: () async {
                      final result = await context.push<bool>(
                        '/menu-detail',
                        extra: todayMenu,
                      );
                      if (result == true) {
                        setState(() => _hasEvaluatedToday = true);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFFBEB), Color(0xFFFEF3C7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFFDE68A), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.lock_person_rounded,
                              size: 32,
                              color: Color(0xFFD97706),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Penasaran Menu Lezat Esok Hari?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF92400E),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Isi konfirmasi konsumsi & ulasan MBG hari ini untuk membuka rahasia paket menu esok hari!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFB45309),
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () async {
                              final result = await context.push<bool>(
                                '/menu-detail',
                                extra: todayMenu,
                              );
                              if (result == true) {
                                setState(() => _hasEvaluatedToday = true);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD97706),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.key_rounded, size: 16),
                            label: const Text(
                              'Buka Rahasia Menu (Beri Ulasan)',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  // Unlocked Menu Preview Card
                  GestureDetector(
                    onTap: () {
                      context.push('/menu-detail', extra: tomorrowMenu);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                            child: Image.network(
                              ImageUtils.getDirectImageUrl(tomorrowMenu['foto_url'] as String),
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => Container(
                                height: 150,
                                color: AppColors.primaryLight,
                                child: const Center(
                                  child: Icon(Icons.restaurant_menu_rounded, size: 44, color: AppColors.primary),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      tomorrowMenu['tanggal_jadwal'] as String,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.primary),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  tomorrowMenu['nama_menu'] as String,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Nutrisi: ${tomorrowMenu['kalori_kkal']} kkal • Protein ${tomorrowMenu['protein_gram']}g • Karbo ${tomorrowMenu['karbohidrat_gram']}g',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildAnimatedBottomNavBar(),
    );
  }

  Widget _buildInteractiveStreakCard() {
    final List<Map<String, dynamic>> weekDays = [
      {'day': 'Sen', 'status': 'done', 'label': '0% Waste'},
      {'day': 'Sel', 'status': 'done', 'label': '0% Waste'},
      {'day': 'Rab', 'status': 'done', 'label': '0% Waste'},
      {'day': 'Kam', 'status': 'done', 'label': '0% Waste'},
      {'day': 'Jum', 'status': 'today', 'label': 'Hari Ini'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
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
            children: [
              const Icon(Icons.local_fire_department_rounded, color: Color(0xFFEF4444), size: 22),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Konsistensi Presensi',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFCA5A5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.local_fire_department_rounded, size: 14, color: Color(0xFFDC2626)),
                    SizedBox(width: 4),
                    Text(
                      '7 Hari',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Weekly Streak Chips
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekDays.map((item) {
              final isDone = item['status'] == 'done';
              final isToday = item['status'] == 'today';
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isToday
                        ? AppColors.primaryLight
                        : isDone
                            ? AppColors.primary.withValues(alpha: 0.08)
                            : AppColors.border.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isToday
                          ? AppColors.primary
                          : isDone
                              ? AppColors.primary.withValues(alpha: 0.4)
                              : AppColors.border,
                      width: isToday ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        item['day'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isToday
                              ? AppColors.primaryDark
                              : isDone
                                  ? AppColors.primary
                                  : AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Icon(
                        isToday
                            ? Icons.local_fire_department_rounded
                            : isDone
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked_rounded,
                        size: 18,
                        color: isToday
                            ? const Color(0xFFEF4444)
                            : isDone
                                ? AppColors.primary
                                : AppColors.textLight,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          // Tip / Gamification Banner
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.secondaryLight.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: const [
                Icon(Icons.lightbulb_outline_rounded, size: 18, color: AppColors.secondaryDark),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Isi konfirmasi konsumsi & ulasan hari ini untuk menjaga konsistensi presensi dan klaim +50 XP!',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
