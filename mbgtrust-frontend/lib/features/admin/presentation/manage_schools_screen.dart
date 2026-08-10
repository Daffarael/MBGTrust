import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/responsive_layout.dart';

class ManageSchoolsScreen extends StatefulWidget {
  const ManageSchoolsScreen({super.key});

  @override
  State<ManageSchoolsScreen> createState() => _ManageSchoolsScreenState();
}

class _ManageSchoolsScreenState extends State<ManageSchoolsScreen> {
  final List<Map<String, dynamic>> _schools = [
    {
      'id': 'SCH_001',
      'name': 'MAN 2 Kota Padang',
      'npsn': '10309988',
      'region': 'Kota Padang',
      'studentsCount': 450,
      'status': 'Aktif',
    },
    {
      'id': 'SCH_002',
      'name': 'SDN 05 Kebayoran',
      'npsn': '20105678',
      'region': 'Jakarta Selatan',
      'studentsCount': 380,
      'status': 'Aktif',
    },
    {
      'id': 'SCH_003',
      'name': 'SMPN 12 Jakarta',
      'npsn': '20109999',
      'region': 'Jakarta Selatan',
      'studentsCount': 620,
      'status': 'Aktif',
    },
  ];

  void _showAddSchoolDialog() {
    final nameController = TextEditingController();
    final npsnController = TextEditingController();
    final regionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Sekolah Baru 🏫', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nama Sekolah'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: npsnController,
                  decoration: const InputDecoration(labelText: 'NPSN Sekolah'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: regionController,
                  decoration: const InputDecoration(labelText: 'Wilayah / Kota'),
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
                    _schools.add({
                      'id': 'SCH_00${_schools.length + 1}',
                      'name': nameController.text,
                      'npsn': npsnController.text.isEmpty ? '20108888' : npsnController.text,
                      'region': regionController.text.isEmpty ? 'Jakarta' : regionController.text,
                      'studentsCount': 300,
                      'status': 'Aktif',
                    });
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sekolah baru berhasil ditambahkan!')),
                  );
                }
              },
              child: const Text('Simpan', style: TextStyle(color: Colors.white)),
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
          'Manajemen Sekolah (Super Admin)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.error),
            onPressed: () => context.go('/login'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddSchoolDialog,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Tambah Sekolah', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Admin Navigation Switcher Header
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.border.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Sekolah',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.push('/admin/sppg-admin'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: const Text(
                          'Admin SPPG',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.push('/admin/penerima-manfaat'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: const Text(
                          'Siswa',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Daftar Sekolah Terdaftar MBG',
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
              itemCount: _schools.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = _schools[index];
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
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.school_rounded, color: AppColors.primaryDark),
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
                              'NPSN: ${item['npsn']} • ${item['region']}',
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                            Text(
                              'Kuota: ${item['studentsCount']} Siswa Beneficiary',
                              style: const TextStyle(fontSize: 11, color: AppColors.primaryDark, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: AppColors.textSecondary, size: 20),
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
