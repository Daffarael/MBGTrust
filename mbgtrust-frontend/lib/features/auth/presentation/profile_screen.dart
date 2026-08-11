import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';
import 'providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
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
      'title': 'Presensi Tepat Waktu',
      'desc': 'Mengonfirmasi presensi harian tepat waktu',
      'unlocked': true,
    },
    {
      'iconData': Icons.emoji_events_rounded,
      'title': 'Siswa Teladan Gizi',
      'desc': 'Peringkat #1 Pahlawan Gizi Sekolah',
      'unlocked': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(authProvider.notifier).checkCurrentUser();
    });
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Keluar', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                await ref.read(authProvider.notifier).logout();
                if (mounted) {
                  context.go('/login');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
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
                'Bagikan Pencapaian Gizi! 🏆',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Pilih media sosial untuk membagikan lencana prestasi piring bersihmu:',
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
                          child: const Text(
                            '1.300 XP',
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
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
        content: Text('Tautan pencapaian "$badgeTitle" berhasil disiapkan untuk $platform! 🎉'),
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
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Penerima Manfaat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: (authState.isLoading && user == null)
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Avatar & Name Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 46,
                          backgroundColor: AppColors.primaryLight,
                          child: Text(
                            (user?.namaLengkap.isNotEmpty ?? false)
                                ? user!.namaLengkap[0].toUpperCase()
                                : 'F',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          user?.namaLengkap ?? 'Faizullatif Fajran',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            user?.peran ?? 'PENERIMA_MANFAAT',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Lencana Penghargaan & Bagikan Medsos Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Lencana Prestasi Gizi',
                        style: TextStyle(
                          fontSize: 16,
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
                  const SizedBox(height: 12),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.25,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _badges.length,
                    itemBuilder: (context, index) {
                      final badge = _badges[index];
                      final isUnlocked = badge['unlocked'] as bool;

                      return InkWell(
                        onTap: () => _showShareAchievementModal(context, badge['title'] as String),
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
                                size: 28,
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
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Profile Information List Card
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border, width: 1),
                    ),
                    child: Column(
                      children: [
                        _buildProfileTile(
                          icon: Icons.badge_outlined,
                          label: 'NIK / NISN',
                          value: user?.nikNisn ?? '3171012345670001',
                        ),
                        const Divider(height: 1, color: AppColors.border),
                        _buildProfileTile(
                          icon: Icons.school_outlined,
                          label: 'Sekolah',
                          value: user?.namaSekolah ?? 'MAN 2 Kota Padang',
                        ),
                        const Divider(height: 1, color: AppColors.border),
                        _buildProfileTile(
                          icon: Icons.class_outlined,
                          label: 'Tingkat Kelas',
                          value: user?.tingkatKelas ?? 'XII.FA-3',
                        ),
                        const Divider(height: 1, color: AppColors.border),
                        _buildProfileTile(
                          icon: Icons.warning_amber_rounded,
                          label: 'Riwayat Alergi',
                          value: (user?.riwayatAlergi.isNotEmpty ?? false)
                              ? user!.riwayatAlergi.join(', ')
                              : 'Tidak Ada',
                          valueColor: (user?.riwayatAlergi.isNotEmpty ?? false)
                              ? AppColors.secondaryDark
                              : AppColors.textPrimary,
                        ),
                        const Divider(height: 1, color: AppColors.border),
                        _buildProfileTile(
                          icon: Icons.verified_outlined,
                          label: 'Status Akun',
                          value: 'Terverifikasi (Aktif)',
                          valueColor: AppColors.success,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Navigation Menu Card (Preferences & Allergies)
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border, width: 1),
                    ),
                    child: ListTile(
                      onTap: () => context.push('/profil/preferensi'),
                      leading: const Icon(Icons.shield_outlined, color: AppColors.primary),
                      title: const Text('Preferensi & Alergi Makanan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: const Text('Atur pantangan makanan & riwayat alergen', style: TextStyle(fontSize: 11)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Action & Policy Section
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.info_outline_rounded, color: AppColors.primaryDark, size: 22),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Identitas resmi (Nama, NIK, Sekolah, Kelas) dikelola terpusat oleh Admin. Anda hanya dapat memperbarui preferensi & alergi makanan.',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryDark,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  CustomButton(
                    text: 'Keluar dari Akun',
                    prefixIcon: const Icon(Icons.logout_rounded,
                        size: 20, color: Colors.white),
                    backgroundColor: AppColors.error,
                    onPressed: _handleLogout,
                  ),
                ],
              ),
            ),
      bottomNavigationBar: const StudentBottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: valueColor ?? AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
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
