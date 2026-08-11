import 'package:flutter/material.dart';
import 'package:mbgtrust/core/constants/mock_data.dart';
import 'package:mbgtrust/core/theme/app_colors.dart';
import 'package:mbgtrust/features/5_menu_production/production/presentation/widgets/sppg_admin_layout.dart';
import 'add_ingredient_form.dart';

class ManageIngredientsScreen extends StatefulWidget {
  const ManageIngredientsScreen({super.key});

  @override
  State<ManageIngredientsScreen> createState() =>
      _ManageIngredientsScreenState();
}

class _ManageIngredientsScreenState extends State<ManageIngredientsScreen> {
  late List<Map<String, dynamic>> _ingredientsList;
  String _selectedCategoryFilter = 'SEMUA';

  final List<Map<String, String>> _filterCategories = [
    {'key': 'SEMUA', 'label': 'Semua Bahan'},
    {'key': 'PROTEIN_HEWANI', 'label': 'Protein Hewani'},
    {'key': 'PROTEIN_NABATI', 'label': 'Protein Nabati'},
    {'key': 'KARBOHIDRAT', 'label': 'Karbohidrat'},
    {'key': 'SAYUR_DAN_BUAH', 'label': 'Sayur & Buah'},
    {'key': 'SUSU_DAN_PELENGKAP', 'label': 'Susu & Pelengkap'},
  ];

  @override
  void initState() {
    super.initState();
    _ingredientsList =
        List<Map<String, dynamic>>.from(MockData.masterHealthyIngredientsFull);
  }

  List<Map<String, dynamic>> get _filteredIngredients {
    if (_selectedCategoryFilter == 'SEMUA') return _ingredientsList;
    return _ingredientsList.where((item) {
      final cat = item['kategori_bahan'] ?? '';
      return cat == _selectedCategoryFilter;
    }).toList();
  }

  void _handleAddIngredient() {
    AddIngredientForm.show(
      context,
      onSave: (newIngredient) {
        setState(() {
          _ingredientsList.insert(0, newIngredient);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Bahan "${newIngredient['nama_bahan']}" berhasil ditambahkan!'),
            backgroundColor: AppColors.success,
          ),
        );
      },
    );
  }

  void _handleEditIngredient(int index, Map<String, dynamic> item) {
    AddIngredientForm.show(
      context,
      initialData: item,
      onSave: (updatedIngredient) {
        setState(() {
          final realIndex = _ingredientsList
              .indexWhere((e) => e['id_bahan'] == item['id_bahan']);
          if (realIndex != -1) {
            _ingredientsList[realIndex] = updatedIngredient;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Bahan "${updatedIngredient['nama_bahan']}" berhasil diperbarui!'),
            backgroundColor: AppColors.success,
          ),
        );
      },
    );
  }

  void _handleDeleteIngredient(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Hapus Bahan Makanan',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(
              'Apakah Anda yakin ingin menghapus bahan baku "${item['nama_bahan'] ?? item['nama']}" dari katalog? Tindakan ini tidak dapat dibatalkan.'),
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
                  _ingredientsList
                      .removeWhere((e) => e['id_bahan'] == item['id_bahan']);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Bahan "${item['nama_bahan'] ?? item['nama']}" telah dihapus.'),
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

  Color _getCategoryColor(String? cat) {
    switch (cat) {
      case 'PROTEIN_HEWANI':
        return Colors.orange;
      case 'PROTEIN_NABATI':
        return AppColors.primary;
      case 'KARBOHIDRAT':
        return Colors.blue;
      case 'SAYUR_DAN_BUAH':
        return Colors.green;
      case 'SUSU_DAN_PELENGKAP':
        return Colors.purple;
      default:
        return AppColors.primary;
    }
  }

  IconData _getCategoryIcon(String? cat) {
    switch (cat) {
      case 'PROTEIN_HEWANI':
        return Icons.set_meal_rounded;
      case 'PROTEIN_NABATI':
        return Icons.eco_rounded;
      case 'KARBOHIDRAT':
        return Icons.grain_rounded;
      case 'SAYUR_DAN_BUAH':
        return Icons.local_florist_rounded;
      case 'SUSU_DAN_PELENGKAP':
        return Icons.local_cafe_rounded;
      default:
        return Icons.restaurant_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredIngredients;

    return SppgAdminLayout(
      currentRoute: '/manage-ingredients',
      title: 'Bahan Baku Sehat',
      subtitle: 'Katalog Bahan Baku Sehat & Nutrisi',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleAddIngredient,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Tambah Bahan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Summary Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.flatware_rounded,
                        color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Katalog Bahan Baku Makanan Sehat',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Total ${_ingredientsList.length} Bahan Baku Terverifikasi Standar Nutrisi MBG',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Category Filter Chips Bar
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filterCategories.map((cat) {
                  final isSelected = _selectedCategoryFilter == cat['key'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(cat['label']!),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.surface,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 12,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedCategoryFilter = cat['key']!);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Ingredient Cards List / Grid
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off_rounded,
                              size: 48, color: AppColors.textLight),
                          const SizedBox(height: 12),
                          const Text(
                            'Tidak ada bahan pada kategori ini.',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final crossAxisCount = constraints.maxWidth > 800
                            ? 3
                            : (constraints.maxWidth > 500 ? 2 : 1);

                        return GridView.builder(
                          padding: const EdgeInsets.only(bottom: 85),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            mainAxisExtent: 138,
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final item = filtered[index];
                            final title =
                                item['nama_bahan'] ?? item['nama'] ?? '';
                            final sub = item['subjudul_nutrisi'] ??
                                item['sub'] ??
                                '';
                            final portion = item['takaran_default'] ??
                                item['berat'] ??
                                '80 gram';
                            final calories = item['kalori_per_100g'] ?? 150;
                            final catKey = item['kategori_bahan'] as String?;
                            final catColor = _getCategoryColor(catKey);
                            final catIcon = _getCategoryIcon(catKey);
                            final allergens =
                                (item['potensi_alergen'] as List<dynamic>?) ??
                                    [];

                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.02),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Top Row: Category Icon & Title
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                          color: catColor.withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(catIcon,
                                            color: catColor, size: 18),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              title.toString(),
                                              softWrap: true,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textPrimary,
                                                height: 1.1,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              sub.toString(),
                                              softWrap: true,
                                              style: const TextStyle(
                                                fontSize: 10.5,
                                                color: AppColors.textSecondary,
                                                height: 1.1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // Badges Row: Portion & Calories
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryLight,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          portion.toString(),
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryDark,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Colors.orange
                                              .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '$calories kkal/100g',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepOrange,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                      height: 14, color: AppColors.border),

                                  // Bottom Row: Action buttons
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (allergens.isNotEmpty)
                                        Text(
                                          '⚠️ ${allergens.join(", ")}',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.secondaryDark,
                                          ),
                                        )
                                      else
                                        const Text(
                                          '✅ Safe',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: AppColors.primaryDark,
                                          ),
                                        ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () => _handleEditIngredient(
                                                index, item),
                                            child: const Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: Icon(Icons.edit_outlined,
                                                  size: 16,
                                                  color: AppColors.primary),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          InkWell(
                                            onTap: () =>
                                                _handleDeleteIngredient(item),
                                            child: const Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: Icon(
                                                  Icons.delete_outline_rounded,
                                                  size: 16,
                                                  color: AppColors.error),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}


