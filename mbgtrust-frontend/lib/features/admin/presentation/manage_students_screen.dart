import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/responsive_layout.dart';

class ManageStudentsScreen extends StatefulWidget {
  const ManageStudentsScreen({super.key});

  @override
  State<ManageStudentsScreen> createState() => _ManageStudentsScreenState();
}

class _ManageStudentsScreenState extends State<ManageStudentsScreen> {
  final List<Map<String, dynamic>> _students = [
    {
      'nisn': '3171012345670001',
      'name': 'Budi Santoso',
      'school': 'SDN 01 Menteng',
      'grade': 'Kelas 5-A',
      'status': 'Aktif',
    },
    {
      'nisn': '3171012345670002',
      'name': 'Siti Nurhaliza',
      'school': 'SDN 01 Menteng',
      'grade': 'Kelas 5-B',
      'status': 'Aktif',
    },
    {
      'nisn': '3171012345670003',
      'name': 'Ahmad Fauzi',
      'school': 'SDN 05 Kebayoran',
      'grade': 'Kelas 4-A',
      'status': 'Aktif',
    },
  ];

  void _showAddStudentDialog() {
    final nameController = TextEditingController();
    final nisnController = TextEditingController();
    final gradeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Registrasi Akun Siswa Baru 🎒', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nama Lengkap Siswa'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nisnController,
                  decoration: const InputDecoration(labelText: 'NIK / NISN Siswa'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: gradeController,
                  decoration: const InputDecoration(labelText: 'Tingkat Kelas (misal: 5-A)'),
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
                    _students.add({
                      'nisn': nisnController.text.isEmpty ? '3171012345670099' : nisnController.text,
                      'name': nameController.text,
                      'school': 'SDN 01 Menteng',
                      'grade': gradeController.text.isEmpty ? 'Kelas 5-A' : gradeController.text,
                      'status': 'Aktif',
                    });
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Akun Siswa baru berhasil didaftarkan!')),
                  );
                }
              },
              child: const Text('Daftarkan', style: TextStyle(color: Colors.white)),
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
          'Kelola Akun Siswa (Super Admin)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.push('/admin/sekolah'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddStudentDialog,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white),
        label: const Text('Tambah Akun Siswa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daftar Akun Siswa / Penerima Manfaat Terdaftar',
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
              itemCount: _students.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = _students[index];
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
                        child: const Icon(Icons.person_outline_rounded, color: AppColors.primaryDark),
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
                              'NISN: ${item['nisn']} • ${item['grade']}',
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                            Text(
                              item['school'],
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
