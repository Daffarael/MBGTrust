import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import 'providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identityController =
      TextEditingController(text: '3171012345670001'); // NISN / Email
  final _passwordController = TextEditingController(text: 'KataSandi123!');

  bool _isObscured = true;
  String _selectedRole = 'Penerima Manfaat';

  @override
  void dispose() {
    _identityController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _switchRole(String role) {
    setState(() {
      _selectedRole = role;
      if (role == 'Penerima Manfaat') {
        _identityController.text = '3171012345670001';
        _passwordController.text = 'KataSandi123!';
      } else if (role == 'Admin SPPG') {
        _identityController.text = 'admin.sppg@mbgtrust.id';
        _passwordController.text = 'AdminSPPG2026!';
      } else {
        _identityController.text = 'superadmin@mbgtrust.id';
        _passwordController.text = 'SuperAdmin2026!';
      }
    });
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authNotifier = ref.read(authProvider.notifier);
    bool success = false;

    if (_selectedRole == 'Penerima Manfaat') {
      success = await authNotifier.loginBeneficiary(
        _identityController.text.trim(),
        _passwordController.text.trim(),
      );
    } else if (_selectedRole == 'Admin SPPG') {
      success = await authNotifier.loginSppgAdmin(
        _identityController.text.trim(),
        _passwordController.text.trim(),
      );
    } else {
      // Super Admin demo bypass/login
      success = true;
    }

    if (!mounted) return;

    if (success) {
      if (_selectedRole == 'Super Admin') {
        context.go('/admin/sekolah');
      } else if (_selectedRole == 'Admin SPPG') {
        context.go('/sppg/dashboard');
      } else {
        context.go('/home');
      }
    } else {
      final errorMessage = ref.read(authProvider).errorMessage ?? 'Gagal masuk. Periksa kembali kredensial Anda.';
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
      backgroundColor: AppColors.background,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 640),
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo Icon & Header
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.restaurant_menu_rounded,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  const Text(
                    'MBGTrust Platform',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Mitigasi Food Waste & AI Nutrisi Program Makan Bergizi Gratis',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // 3 Role Switcher
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.border.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        _buildRoleTab('Penerima Manfaat', 'Siswa'),
                        _buildRoleTab('Admin SPPG', 'Admin SPPG'),
                        _buildRoleTab('Super Admin', 'Super Admin'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Input Identity
                  TextFormField(
                    controller: _identityController,
                    keyboardType: _selectedRole == 'Penerima Manfaat'
                        ? TextInputType.number
                        : TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: _selectedRole == 'Penerima Manfaat'
                          ? 'NIK / NISN Siswa'
                          : 'Email / Username $_selectedRole',
                      prefixIcon: Icon(
                        _selectedRole == 'Penerima Manfaat'
                            ? Icons.badge_outlined
                            : Icons.email_outlined,
                        color: AppColors.textLight,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Input tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password Input
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _isObscured,
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi',
                      prefixIcon: const Icon(Icons.lock_outline_rounded,
                          color: AppColors.textLight),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscured
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textLight,
                        ),
                        onPressed: () =>
                            setState(() => _isObscured = !_isObscured),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kata sandi tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  ElevatedButton(
                    onPressed: authState.isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: authState.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Masuk sebagai $_selectedRole',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),

                  // Info Catatan Pengelolaan Akun oleh Super Admin
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.verified_user_rounded, color: AppColors.primaryDark, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Seluruh akun & kata sandi Penerima Manfaat dikelola terpusat oleh Super Admin (1 Penerima Manfaat = 1 Akun Resmi).',
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

                  // Quick Demo Accounts Selector Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.touch_app_rounded,
                                size: 16, color: AppColors.primary),
                            SizedBox(width: 6),
                            Text(
                              'Pilih Akun Demo (Klik Langsung):',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildDemoAccountTile(
                          roleKey: 'Penerima Manfaat',
                          title: 'Siswa / Penerima Manfaat',
                          subtitle: 'NISN: 3171012345670001 • KataSandi123!',
                        ),
                        const Divider(height: 12, color: AppColors.border),
                        _buildDemoAccountTile(
                          roleKey: 'Admin SPPG',
                          title: 'Pengelola / Admin SPPG',
                          subtitle: 'Email: admin.sppg@mbgtrust.id • AdminSPPG2026!',
                        ),
                        const Divider(height: 12, color: AppColors.border),
                        _buildDemoAccountTile(
                          roleKey: 'Super Admin',
                          title: 'Administrator Sistem (Super Admin)',
                          subtitle: 'Email: superadmin@mbgtrust.id • SuperAdmin2026!',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleTab(String roleKey, String label) {
    final isSelected = _selectedRole == roleKey;
    return Expanded(
      child: GestureDetector(
        onTap: () => _switchRole(roleKey),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDemoAccountTile({
    required String roleKey,
    required String title,
    required String subtitle,
  }) {
    return InkWell(
      onTap: () => _switchRole(roleKey),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }
}
