import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';
import 'providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nikNisnController = TextEditingController(text: '3171012345670001');
  final _nameController = TextEditingController(text: 'Budi Santoso');
  final _schoolIdController = TextEditingController(text: 'sch_78192a8c');
  final _gradeController = TextEditingController(text: '5-A');
  final _passwordController = TextEditingController(text: 'KataSandi123!');
  final _allergyController = TextEditingController(text: 'Kacang Tanah, Udang');

  @override
  void dispose() {
    _nikNisnController.dispose();
    _nameController.dispose();
    _schoolIdController.dispose();
    _gradeController.dispose();
    _passwordController.dispose();
    _allergyController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final authNotifier = ref.read(authProvider.notifier);

    List<String> allergies = _allergyController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    bool success = await authNotifier.registerBeneficiary(
      nikNisn: _nikNisnController.text.trim(),
      namaLengkap: _nameController.text.trim(),
      idSekolah: int.tryParse(_schoolIdController.text.trim()) ?? 0,
      tingkatKelas: _gradeController.text.trim(),
      kataSandi: _passwordController.text.trim(),
      riwayatAlergi: allergies,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pendaftaran akun penerima manfaat berhasil! Silakan masuk.'),
          backgroundColor: AppColors.success,
        ),
      );
      context.go('/login');
    } else {
      final errorMessage = ref.read(authProvider).errorMessage ?? 'Gagal melakukan pendaftaran.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/login');
            }
          },
        ),
        title: const Text('Pendaftaran Penerima Manfaat'),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1_rounded,
                      size: 44,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Registrasi Akun Siswa',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Lengkapi NIK/NISN dan data sekolah Anda untuk mendaftar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                // NIK/NISN
                CustomTextField(
                  label: 'NIK / NISN',
                  hint: 'Contoh: 3171012345670001',
                  controller: _nikNisnController,
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.badge_outlined),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'NIK / NISN wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Nama Lengkap
                CustomTextField(
                  label: 'Nama Lengkap',
                  hint: 'Contoh: Budi Santoso',
                  controller: _nameController,
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama lengkap wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // ID Sekolah & Kelas
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomTextField(
                        label: 'ID Sekolah',
                        hint: 'sch_78192a8c',
                        controller: _schoolIdController,
                        prefixIcon: const Icon(Icons.school_outlined),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'ID Sekolah wajib diisi';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: CustomTextField(
                        label: 'Kelas',
                        hint: '5-A',
                        controller: _gradeController,
                        prefixIcon: const Icon(Icons.class_outlined),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Wajib';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Riwayat Alergi
                CustomTextField(
                  label: 'Riwayat Alergi (Pisahkan Koma)',
                  hint: 'Contoh: Kacang Tanah, Udang',
                  controller: _allergyController,
                  prefixIcon: const Icon(Icons.warning_amber_rounded),
                ),
                const SizedBox(height: 16),

                // Kata Sandi
                CustomTextField(
                  label: 'Kata Sandi',
                  hint: 'Minimal 6 karakter',
                  controller: _passwordController,
                  isPassword: true,
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kata sandi wajib diisi';
                    }
                    if (value.length < 6) {
                      return 'Kata sandi minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                // Submit Button
                CustomButton(
                  text: 'Daftar Akun Siswa',
                  isLoading: authState.isLoading,
                  onPressed: _handleRegister,
                ),
                const SizedBox(height: 20),

                // Back to Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sudah punya akun? ',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/login'),
                      child: const Text(
                        'Masuk di sini',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
