import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/mock_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/mbgtrust_logo.dart';
import '../../../core/widgets/widgets.dart';
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

  void _showNotificationModal(BuildContext context) {
    bool hasUnread = true;

    final notifications = [
      {
        'id': '1',
        'title': 'Pengingat Presensi & Makan Siang',
        'body': 'Menu makan siang hari ini telah siap diantar dari Dapur SPPG. Jangan lupa konfirmasi presensi & piring bersihmu!',
        'time': '5 mnt lalu',
        'icon': Icons.restaurant_rounded,
        'iconColor': AppColors.primary,
        'isRead': false,
        'category': 'Presensi',
      },
      {
        'id': '2',
        'title': 'Status Dapur SPPG: Siap Distribusi',
        'body': 'Tahap 3/3 Selesai: 450 Porsi Seimbang standar BGN RI siap dikirimkan ke MAN 2 Kota Padang pukul 06:30 WIB.',
        'time': '1 jam lalu',
        'icon': Icons.local_shipping_rounded,
        'iconColor': const Color(0xFF0284C7),
        'isRead': false,
        'category': 'Dapur SPPG',
      },
      {
        'id': '3',
        'title': 'Peringkat XP Kamu Naik!',
        'body': 'Selamat! Kamu berhasil meluncur ke Peringkat #15 klasemen dengan total 1.402 XP. Pertahankan konsistensi presensi!',
        'time': 'Kemarin',
        'icon': Icons.emoji_events_rounded,
        'iconColor': const Color(0xFFD97706),
        'isRead': true,
        'category': 'Pemberitahuan',
      },
      {
        'id': '4',
        'title': 'Lencana Baru Terbuka!',
        'body': 'Kamu membuka lencana "Pahlawan Piring Bersih" 🌟. Buka tab Lencana di Peringkat untuk mengklaim sertifikatmu.',
        'time': '2 hari lalu',
        'icon': Icons.workspace_premium_rounded,
        'iconColor': AppColors.primary,
        'isRead': true,
        'category': 'Prestasi',
      },
      {
        'id': '5',
        'title': 'Pratinjau Menu Esok Hari',
        'body': 'Nasi Ungu Organik, Ayam Bakar Madu & Sayur Bening Bayam siap disajikan esok hari. Cek rantai pasoknya!',
        'time': '3 hari lalu',
        'icon': Icons.lightbulb_outline_rounded,
        'iconColor': const Color(0xFF059669),
        'isRead': true,
        'category': 'Menu',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalCtx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle Bar
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.notifications_active_rounded, color: AppColors.primary, size: 22),
                          const SizedBox(width: 8),
                          const Text(
                            'Pusat Notifikasi',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (hasUnread) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                '2 Baru',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Row(
                        children: [
                          if (hasUnread)
                            TextButton(
                              onPressed: () {
                                setModalState(() {
                                  hasUnread = false;
                                  for (var n in notifications) {
                                    n['isRead'] = true;
                                  }
                                });
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Tandai Dibaca',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, size: 20),
                            onPressed: () => Navigator.pop(modalCtx),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 16),

                  // List Notifikasi
                  Expanded(
                    child: ListView.separated(
                      itemCount: notifications.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = notifications[index];
                        final bool isRead = item['isRead'] as bool;

                        return InkWell(
                          onTap: () {
                            setModalState(() {
                              item['isRead'] = true;
                            });
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isRead ? AppColors.surface : AppColors.primaryLight.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isRead ? AppColors.border : AppColors.primary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: (item['iconColor'] as Color).withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    item['icon'] as IconData,
                                    color: item['iconColor'] as Color,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item['title'] as String,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            item['time'] as String,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['body'] as String,
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
                          ),
                        );
                      },
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

    final todayMenu = MockData.todayMenu;
    final tomorrowMenu = MockData.tomorrowMenu;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 640),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Atas Bersih (Logo MBGTrust & Notifikasi)
                  // Header Atas Modern (Konsisten 100% dengan Profil & Peringkat)
                  // Header Atas Modern (Logo MBGTrust + Frosted Gold XP Badge + Bell)
                  // Header Atas Modern (Logo MBGTrust + Bell Notifikasi)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const MbgTrustLogo(size: 30),
                          const SizedBox(width: 8),
                          const Text(
                            'MBGTrust',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                      // Notification Bell Button
                      InkWell(
                        onTap: () => _showNotificationModal(context),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              const Icon(Icons.notifications_outlined, size: 18, color: AppColors.textPrimary),
                              Positioned(
                                right: -1,
                                top: -1,
                                child: Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: AppColors.error,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // ==========================================
                  // KARTU 1: BANNER SELAMAT DATANG SISWA
                  // ==========================================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.primaryDark,
                          AppColors.primary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.22),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selamat Datang,',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          studentName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ==========================================
                  // KARTU 2: DEDICATED CARD TANGGAL & WAKTU LIVE
                  // ==========================================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 9.0),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time_filled_rounded, color: AppColors.primary, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          _dateString.isNotEmpty ? '$_dateString • ${_timeString.split(' ')[0]} WIB' : 'Selasa, 11 Agustus 2026 • 16:58 WIB',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ==========================================
                  // KARTU 3: KARTU POIN XP SISWA & TOMBOL PERINGKAT
                  // ==========================================
                  GestureDetector(
                    onTap: () => context.go('/profil/gamifikasi'),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0xFFFDE68A)),
                                ),
                                child: const Icon(Icons.workspace_premium_rounded, color: Color(0xFFD97706), size: 20),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Total Poin XP',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    _hasEvaluatedToday ? '1.402 XP' : '922 XP',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Tombol Menuju Halaman Peringkat
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: const [
                                Text(
                                  'Peringkat',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                                SizedBox(width: 3),
                                Icon(Icons.chevron_right_rounded, color: AppColors.primaryDark, size: 16),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Interactive Streak Presensi Card
                  _buildInteractiveStreakCard(),
                  const SizedBox(height: 8),

                  // ==========================================
                  // KARTU 4: PRESENSI & EVALUASI MBG HARI INI
                  // ==========================================
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _hasEvaluatedToday ? AppColors.primary : AppColors.border,
                        width: _hasEvaluatedToday ? 1.5 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.restaurant_menu_rounded, color: AppColors.primary, size: 18),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Sudah Makan MBG Hari Ini?',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Hari Ini',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Mini Preview Menu Hari Ini + 4 Kotak Nutrisi Material Icons
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: MbgFoodImage(
                                      imageUrl: (todayMenu['foto_url'] as String?) ?? '',
                                      width: 44,
                                      height: 44,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      todayMenu['nama_menu'] as String? ?? 'Nasi Ayam Bakar Kecap & Tumis Buncis',
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // 4 Kotak Nutrisi Ber-ikon Material
                              Row(
                                children: [
                                  _buildNutrientMiniBox(Icons.local_fire_department_rounded, const Color(0xFFEF4444), '${todayMenu['kalori_kkal']}', 'kkal'),
                                  const SizedBox(width: 5),
                                  _buildNutrientMiniBox(Icons.fitness_center_rounded, AppColors.primary, '${todayMenu['protein_gram']}g', 'Protein'),
                                  const SizedBox(width: 5),
                                  _buildNutrientMiniBox(Icons.rice_bowl_rounded, AppColors.secondaryDark, '${todayMenu['karbohidrat_gram']}g', 'Karbo'),
                                  const SizedBox(width: 5),
                                  _buildNutrientMiniBox(Icons.eco_rounded, AppColors.primaryDark, '${todayMenu['lemak_gram'] ?? 14.2}g', 'Lemak'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        if (_hasEvaluatedToday) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.primary),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.check_circle_rounded, color: AppColors.primaryDark, size: 18),
                                SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    'Evaluasi & Presensi Hari Ini Telah Dikirim (+50 XP)',
                                    style: TextStyle(
                                      fontSize: 11.5,
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
                                    padding: const EdgeInsets.symmetric(vertical: 9),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(Icons.check_circle_outline_rounded, size: 17),
                                  label: const Text('Sudah', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    _showRejectionReasonModal(context);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.secondaryDark,
                                    padding: const EdgeInsets.symmetric(vertical: 9),
                                    side: const BorderSide(color: AppColors.secondaryDark),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(Icons.highlight_off_rounded, size: 17),
                                  label: const Text('Belum', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),

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
                      final Map<String, dynamic> extraMap = Map<String, dynamic>.from(tomorrowMenu);
                      extraMap['isPreview'] = true;
                      context.push('/menu-detail', extra: extraMap);
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
                            child: MbgFoodImage(
                              imageUrl: tomorrowMenu['foto_url'] as String,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
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
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const StudentBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildInteractiveStreakCard() {
    final List<Map<String, dynamic>> weekDays = [
      {'day': 'Sen', 'status': 'done', 'label': '0% Waste'},
      {'day': 'Sel', 'status': _hasEvaluatedToday ? 'done' : 'today', 'label': _hasEvaluatedToday ? '0% Waste' : 'Hari Ini'},
      {'day': 'Rab', 'status': 'upcoming', 'label': 'Mendatang'},
      {'day': 'Kam', 'status': 'upcoming', 'label': 'Mendatang'},
      {'day': 'Jum', 'status': 'upcoming', 'label': 'Mendatang'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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

          // Tip / Gamification Banner Compact (Text Utuh Tanpa Ellipsis)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.secondaryLight.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: const [
                Icon(Icons.lightbulb_outline_rounded, size: 16, color: AppColors.secondaryDark),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Ulas menu hari ini untuk klaim +50 XP dan jaga streak presensi!',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryDark,
                      height: 1.35,
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

  Widget _buildNutrientMiniBox(IconData iconData, Color iconColor, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.8)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(iconData, size: 12, color: iconColor),
                const SizedBox(width: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
