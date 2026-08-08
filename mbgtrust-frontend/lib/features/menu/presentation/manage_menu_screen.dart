import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/mock_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';
import '../../production/presentation/widgets/sppg_admin_layout.dart';
import 'add_menu_form.dart';

class ManageMenuScreen extends StatefulWidget {
  const ManageMenuScreen({super.key});

  @override
  State<ManageMenuScreen> createState() => _ManageMenuScreenState();
}

class _ManageMenuScreenState extends State<ManageMenuScreen> {
  late List<Map<String, dynamic>> _menuList;

  @override
  void initState() {
    super.initState();
    _menuList = List<Map<String, dynamic>>.from(MockData.foodMenuList);
  }

  void _handleAddMenu() {
    AddMenuForm.show(
      context,
      onSave: (newMenu) {
        setState(() {
          _menuList.insert(0, newMenu);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Menu "${newMenu['name']}" berhasil ditambahkan!'),
            backgroundColor: AppColors.success,
          ),
        );
      },
    );
  }

  void _handleEditMenu(int index) {
    final itemToEdit = _menuList[index];
    AddMenuForm.show(
      context,
      initialData: itemToEdit,
      onSave: (updatedMenu) {
        setState(() {
          _menuList[index] = updatedMenu;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Menu "${updatedMenu['name']}" berhasil diperbarui!'),
            backgroundColor: AppColors.success,
          ),
        );
      },
    );
  }

  void _handleDeleteMenu(int index) {
    final itemToDelete = _menuList[index];
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Hapus Menu'),
          content: Text(
              'Apakah Anda yakin ingin menghapus menu "${itemToDelete['name']}"?'),
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
              onPressed: () {
                Navigator.pop(dialogContext);
                setState(() {
                  _menuList.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Menu "${itemToDelete['name']}" telah dihapus.'),
                    backgroundColor: AppColors.secondaryDark,
                  ),
                );
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SppgAdminLayout(
      currentRoute: '/manage-menu',
      title: 'Kelola Master Menu',
      subtitle: 'Katalog Menu Seimbang SPPG',
      actions: [
        IconButton(
          icon: const Icon(Icons.calendar_month_rounded,
              color: AppColors.primary),
          tooltip: 'Buat Jadwal Menu',
          onPressed: () {
            context.push('/create-schedule', extra: _menuList);
          },
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleAddMenu,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Tambah Menu',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: _menuList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.restaurant_menu_rounded,
                    size: 64,
                    color: AppColors.textLight,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Belum ada menu makanan.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Tambah Menu Sekarang',
                    width: 200,
                    onPressed: _handleAddMenu,
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 800
                      ? 3
                      : (constraints.maxWidth > 500 ? 2 : 1);
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      mainAxisExtent: 310,
                    ),
                    itemCount: _menuList.length,
                    itemBuilder: (context, index) {
                      final menu = _menuList[index];
                      final title = menu['name'] ?? '';
                      final calories = menu['calories']?.toString() ?? '500';
                      final protein = menu['protein'] ?? '25g';
                      final photoUrl = menu['photoUrl'] ?? '';
                      final category = menu['category'] ?? 'Makan Siang';

                      return Container(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Card Image & Category Badge
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                  child: Image.network(
                                    photoUrl,
                                    height: 130,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      height: 130,
                                      color: AppColors.primaryLight,
                                      child: const Icon(
                                        Icons.restaurant_menu_rounded,
                                        color: AppColors.primary,
                                        size: 36,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      category,
                                      softWrap: true,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Card Content (TEKS DIBACA UTUH 100%)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      softWrap: true,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                        height: 1.2,
                                      ),
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.local_fire_department_rounded,
                                          size: 14,
                                          color: AppColors.secondary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '$calories kcal',
                                          softWrap: true,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          'Protein: $protein',
                                          softWrap: true,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                        height: 12, color: AppColors.border),

                                    // Action Buttons (Edit & Delete)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                          onTap: () => _handleEditMenu(index),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Row(
                                              children: const [
                                                Icon(Icons.edit_outlined,
                                                    size: 16,
                                                    color: AppColors.primary),
                                                SizedBox(width: 4),
                                                Text(
                                                  'Edit',
                                                  softWrap: true,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 14,
                                          width: 1,
                                          color: AppColors.border,
                                        ),
                                        InkWell(
                                          onTap: () => _handleDeleteMenu(index),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Row(
                                              children: const [
                                                Icon(
                                                    Icons
                                                        .delete_outline_rounded,
                                                    size: 16,
                                                    color: AppColors.error),
                                                SizedBox(width: 4),
                                                Text(
                                                  'Hapus',
                                                  softWrap: true,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.error,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
