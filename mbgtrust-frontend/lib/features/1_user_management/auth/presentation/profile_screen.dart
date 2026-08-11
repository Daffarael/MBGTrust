import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mbgtrust/core/theme/app_colors.dart';
import 'package:mbgtrust/core/widgets/mbgtrust_logo.dart';
import 'package:mbgtrust/core/widgets/widgets.dart';
import 'providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
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

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: (authState.isLoading && user == null)
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Atas Modern (Pengganti AppBar Polos)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const MbgTrustLogo(size: 30),
                            const SizedBox(width: 8),
                            const Text(
                              'MBGTrust Profile',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.verified_rounded, color: AppColors.primary, size: 14),
                              SizedBox(width: 4),
                              Text(
                                'BGN Verified',
                                style: TextStyle(
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
                    const SizedBox(height: 16),
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
                          label: 'Riwayat Alergi Makanan',
                          value: (user?.riwayatAlergi.isNotEmpty ?? false)
                              ? user!.riwayatAlergi.join(', ')
                              : 'Tidak Ada Alergi Terdaftar',
                          valueColor: (user?.riwayatAlergi.isNotEmpty ?? false)
                              ? AppColors.secondaryDark
                              : AppColors.textPrimary,
                        ),
                        const Divider(height: 1, color: AppColors.border),
                        _buildProfileTile(
                          icon: Icons.verified_outlined,
                          label: 'Status Akun Presensi',
                          value: 'Terverifikasi (Aktif)',
                          valueColor: AppColors.success,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

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
                            'Data identitas siswa dikelola terpusat oleh Admin SPPG MAN 2 Kota Padang. Anda dapat memperbarui preferensi alergi secara mandiri.',
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
                  const SizedBox(height: 20),

                  CustomButton(
                    text: 'Keluar dari Akun',
                    prefixIcon: const Icon(Icons.logout_rounded,
                        size: 20, color: Colors.white),
                    backgroundColor: AppColors.error,
                    onPressed: _handleLogout,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
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


