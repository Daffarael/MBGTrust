import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/responsive_layout.dart';

class ManageSppgAdminsScreen extends StatefulWidget {
  const ManageSppgAdminsScreen({super.key});

  @override
  State<ManageSppgAdminsScreen> createState() => _ManageSppgAdminsScreenState();
}

class _ManageSppgAdminsScreenState extends State<ManageSppgAdminsScreen> {
  final List<Map<String, dynamic>> _sppgAdmins = [
    {
      'id': 'ADM_001',
      'name': 'Pengelola SPPG Jakarta Pusat',
      'email': 'admin.sppg@mbgtrust.id',
      'region': 'DKI Jakarta Wilayah 1',
      'status': 'Aktif',
    },
    {
      'id': 'ADM_002',
      'name': 'Pengelola SPPG Kebayoran',
      'email': 'admin.kebayoran@mbgtrust.id',
      'region': 'DKI Jakarta Wilayah 2',
      'status': 'Aktif',
    },
  ];

  void _showAddAdminDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final regionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Buat Akun Admin SPPG Baru 👔', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nama Pengelola SPPG'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Surel (Email) Masuk'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: regionController,
                  decoration: const InputDecoration(labelText: 'Wilayah Operasional'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  setState(() {
                    _sppgAdmins.add({
                      'id': 'ADM_00${_sppgAdmins.length + 1}',
                      'name': nameController.text,
                      'email': emailController.text.isEmpty ? 'admin.new@mbgtrust.id' : emailController.text,
                      'region': regionController.text.isEmpty ? 'DKI Jakarta' : regionController.text,
                      'status': 'Aktif',
                    });
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Akun Admin SPPG baru berhasil dibuat!')),
                  );
                }
              },
              child: const Text('Buat Akun', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      appBar: AppBar(
        title: const Text(
          'Kelola Admin SPPG (Super Admin)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.push('/admin/sekolah'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddAdminDialog,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.person_add_rounded, color: Colors.white),
        label: const Text('Tambah Admin SPPG', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daftar Akun Admin SPPG Aktif',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _sppgAdmins.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = _sppgAdmins[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.secondaryDark),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Email: ${item['email']}',
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                            Text(
                              'Wilayah: ${item['region']}',
                              style: const TextStyle(fontSize: 11, color: AppColors.primaryDark, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.key_rounded, color: AppColors.textSecondary, size: 20),
                        onPressed: () {},
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
