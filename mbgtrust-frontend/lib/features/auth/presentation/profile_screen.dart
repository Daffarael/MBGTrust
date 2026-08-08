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
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(authProvider.notifier).checkCurrentUser();
    });
  }

  void _showEditProfileModal() {
    final user = ref.read(authProvider).user;
    final nameEditController =
        TextEditingController(text: user?.namaLengkap ?? '');
    final gradeEditController =
        TextEditingController(text: user?.tingkatKelas ?? '');
    final phoneEditController =
        TextEditingController(text: user?.nomorTelepon ?? '');
    final allergyEditController =
        TextEditingController(text: user?.riwayatAlergi.join(', ') ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return Container(
          padding: EdgeInsets.only(
            top: 24,
            left: 24,
            right: 24,
            bottom: MediaQuery.of(modalContext).viewInsets.bottom + 24,
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
                    'Edit Profil Pengguna',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(modalContext),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Nama Lengkap',
                controller: nameEditController,
                prefixIcon: const Icon(Icons.person_outline_rounded),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Tingkat Kelas',
                controller: gradeEditController,
                prefixIcon: const Icon(Icons.class_outlined),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Nomor Telepon',
                controller: phoneEditController,
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_android_outlined),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Riwayat Alergi (Pisahkan Koma)',
                controller: allergyEditController,
                prefixIcon: const Icon(Icons.warning_amber_rounded),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Simpan Perubahan',
                onPressed: () async {
                  List<String> allergies = allergyEditController.text
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList();

                  final repo = ref.read(authRepositoryProvider);
                  final nav = Navigator.of(modalContext);
                  final messenger = ScaffoldMessenger.of(context);
                  try {
                    await repo.updateMyProfile(
                      namaLengkap: nameEditController.text.trim(),
                      tingkatKelas: gradeEditController.text.trim(),
                      riwayatAlergi: allergies,
                      nomorTelepon: phoneEditController.text.trim(),
                    );
                    await ref.read(authProvider.notifier).checkCurrentUser();
                    if (mounted) {
                      nav.pop();
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text('Profil pengguna berhasil diperbarui!'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Konfirmasi Keluar'),
          content:
              const Text('Apakah Anda yakin ingin keluar dari akun MBGTrust?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                Navigator.pop(dialogContext);
                await ref.read(authProvider.notifier).logout();
                if (mounted) context.go('/login');
              },
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
      appBar: AppBar(
        title: const Text('Detail Profil'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
            tooltip: 'Edit Profil',
            onPressed: _showEditProfileModal,
          ),
        ],
      ),
      body: authState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
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
                                : 'B',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          user?.namaLengkap ?? 'Budi Santoso',
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
                  const SizedBox(height: 20),

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
                          value: user?.namaSekolah ?? 'SDN 01 Menteng',
                        ),
                        const Divider(height: 1, color: AppColors.border),
                        _buildProfileTile(
                          icon: Icons.class_outlined,
                          label: 'Tingkat Kelas',
                          value: user?.tingkatKelas ?? '5-A',
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

                  // Action Buttons
                  CustomButton(
                    text: 'Edit Profil Saya',
                    prefixIcon: const Icon(Icons.edit_outlined,
                        size: 20, color: AppColors.primary),
                    isOutlined: true,
                    borderColor: AppColors.primary,
                    onPressed: _showEditProfileModal,
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
