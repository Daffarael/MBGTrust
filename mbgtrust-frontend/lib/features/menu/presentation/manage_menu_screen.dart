import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/mock_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/image_utils.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _menuList = List<Map<String, dynamic>>.from(MockData.foodMenuList);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredMenuList {
    if (_searchQuery.trim().isEmpty) return _menuList;
    final query = _searchQuery.trim().toLowerCase();
    return _menuList.where((menu) {
      final name = (menu['nama_menu'] ?? menu['name'] ?? '').toString().toLowerCase();
      final category = (menu['kategori'] ?? menu['category'] ?? '').toString().toLowerCase();
      final ingredients = (menu['komposisi_bahan'] ?? '').toString().toLowerCase();
      return name.contains(query) || category.contains(query) || ingredients.contains(query);
    }).toList();
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
            content: Text('Menu "${newMenu['nama_menu']}" berhasil ditambahkan!'),
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
            content: Text('Menu "${updatedMenu['nama_menu']}" berhasil diperbarui!'),
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
              'Apakah Anda yakin ingin menghapus menu "${itemToDelete['nama_menu'] ?? itemToDelete['name']}"?'),
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
                    content: Text(
                        'Menu "${itemToDelete['nama_menu'] ?? itemToDelete['name']}" telah dihapus.'),
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

  void _showMenuDetailModal(BuildContext context, int index) {
    final menu = _menuList[index];
    final title = menu['nama_menu'] ?? menu['name'] ?? '';
    final calories = menu['kalori_kkal'] ?? menu['calories'] ?? 550;
    final protein = menu['protein_gram'] ?? 28.5;
    final carbs = menu['karbohidrat_gram'] ?? 65.0;
    final fats = menu['lemak_gram'] ?? 14.2;
    final photoUrl = menu['foto_url'] ?? menu['photoUrl'] ?? '';
    final category = menu['kategori'] ?? menu['category'] ?? 'MAKANAN_BERAT';
    final cost = menu['estimasi_biaya_per_porsi'] ?? 15000;
    final rating = menu['rating_rata_rata'] ?? 4.9;
    final ingredientsDetail = (menu['komposisi_bahan_detail'] as List<dynamic>?) ?? [];
    final ingredients = (menu['komposisi_bahan'] as List<dynamic>?) ??
        ['Dada Ayam Bakar 80g', 'Nasi Putih Warm 150g', 'Tumis Buncis 60g'];
    final allergens = (menu['potensi_alergen'] as List<dynamic>?) ?? ['Kedelai'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        constraints: const BoxConstraints(maxWidth: 640),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Modal Drag Handle & Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Rincian Detail Master Menu MBG',
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 10),

              // Hero Image Card
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      ImageUtils.getDirectImageUrl(photoUrl),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        height: 200,
                        color: AppColors.primaryLight,
                        child: const Icon(Icons.restaurant_menu_rounded,
                            size: 48, color: AppColors.primary),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        category.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '$rating',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Menu Title
              Text(
                title.toString(),
                softWrap: true,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // 4 Stat Cards Kandungan Gizi (Sesuai Tampilan Penerima Manfaat)
              const Text(
                'Kandungan Gizi per Porsi:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: _buildNutritionCard(
                      label: 'Energi',
                      value: '$calories kcal',
                      icon: Icons.local_fire_department_rounded,
                      color: Colors.orange,
                      bgColor: Colors.orange.withValues(alpha: 0.1),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildNutritionCard(
                      label: 'Protein',
                      value: '${protein}g',
                      icon: Icons.fitness_center_rounded,
                      color: AppColors.primary,
                      bgColor: AppColors.primaryLight,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildNutritionCard(
                      label: 'Karbo',
                      value: '${carbs}g',
                      icon: Icons.grain_rounded,
                      color: Colors.blue,
                      bgColor: Colors.blue.withValues(alpha: 0.1),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildNutritionCard(
                      label: 'Lemak',
                      value: '${fats}g',
                      icon: Icons.water_drop_rounded,
                      color: Colors.deepOrange,
                      bgColor: Colors.deepOrange.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Bahan Makanan Sehat List
              const Text(
                'Bahan Makanan Sehat:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    if (ingredientsDetail.isNotEmpty)
                      for (int i = 0; i < ingredientsDetail.length; i++) ...[
                        if (i > 0) const Divider(height: 14, color: AppColors.border),
                        Row(
                          children: [
                            const Icon(Icons.check_circle_rounded,
                                size: 18, color: AppColors.primary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ingredientsDetail[i]['nama']?.toString() ?? '',
                                    softWrap: true,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  if (ingredientsDetail[i]['sub'] != null &&
                                      ingredientsDetail[i]['sub'].toString().isNotEmpty)
                                    Text(
                                      ingredientsDetail[i]['sub'].toString(),
                                      softWrap: true,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              ingredientsDetail[i]['berat']?.toString() ?? '',
                              softWrap: true,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ]
                    else
                      for (int i = 0; i < ingredients.length; i++) ...[
                        if (i > 0) const Divider(height: 14, color: AppColors.border),
                        Row(
                          children: [
                            const Icon(Icons.check_circle_rounded,
                                size: 18, color: AppColors.primary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                ingredients[i].toString(),
                                softWrap: true,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Potensi Alergen & Biaya
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: allergens.isNotEmpty
                      ? AppColors.secondaryLight
                      : AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: allergens.isNotEmpty
                        ? AppColors.secondary
                        : AppColors.primary,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      allergens.isNotEmpty
                          ? Icons.warning_amber_rounded
                          : Icons.verified_rounded,
                      color: allergens.isNotEmpty
                          ? AppColors.secondaryDark
                          : AppColors.primaryDark,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            allergens.isNotEmpty
                                ? 'Potensi Alergen: ${allergens.join(", ")}'
                                : 'Aman Dari Potensi Alergen Utama',
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: allergens.isNotEmpty
                                  ? AppColors.secondaryDark
                                  : AppColors.primaryDark,
                            ),
                          ),
                          Text(
                            'Estimasi Biaya Porsi: Rp $cost (APBN SPPG)',
                            softWrap: true,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Modal Action Buttons
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: '✏️ Edit Menu',
                      onPressed: () {
                        Navigator.pop(ctx);
                        _handleEditMenu(index);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: '🗑️ Hapus Menu',
                      isOutlined: true,
                      borderColor: AppColors.error,
                      textColor: AppColors.error,
                      onPressed: () {
                        Navigator.pop(ctx);
                        _handleDeleteMenu(index);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SppgAdminLayout(
      currentRoute: '/manage-menu',
      title: 'Katalog Menu Makanan',
      subtitle: 'Daftar Resep & Kandungan Nutrisi Menu Seimbang',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar for Menu Search
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Cari nama menu, bahan, atau kategori...',
                  hintStyle: const TextStyle(fontSize: 13, color: AppColors.textLight),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18, color: AppColors.textSecondary),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
            ),

            // Menu List / Grid View
            Expanded(
              child: _filteredMenuList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: AppColors.textLight,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'Menu "$_searchQuery" tidak ditemukan.'
                                : 'Belum ada menu makanan.',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (_searchQuery.isEmpty) ...[
                            const SizedBox(height: 16),
                            CustomButton(
                              text: 'Tambah Menu Sekarang',
                              width: 200,
                              onPressed: _handleAddMenu,
                            ),
                          ],
                        ],
                      ),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final crossAxisCount = constraints.maxWidth > 800
                            ? 3
                            : (constraints.maxWidth > 500 ? 2 : 1);
                        final filtered = _filteredMenuList;

                        return GridView.builder(
                          padding: const EdgeInsets.only(bottom: 85),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            mainAxisExtent: 242,
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final menu = filtered[index];
                            final title = menu['nama_menu'] ?? menu['name'] ?? '';
                            final calories = menu['kalori_kkal']?.toString() ?? menu['calories']?.toString() ?? '500';
                            final protein = menu['protein_gram'] != null ? '${menu['protein_gram']}g' : (menu['protein'] ?? '25g');
                            final photoUrl = menu['foto_url'] ?? menu['photoUrl'] ?? '';
                            final category = menu['kategori'] ?? menu['category'] ?? 'MAKANAN_BERAT';

                            return InkWell(
                              onTap: () => _showMenuDetailModal(context, index),
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
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
                                            ImageUtils.getDirectImageUrl(photoUrl),
                                            height: 110,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Container(
                                              height: 110,
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

                                    // Card Content (Rapat & Tanpa Space Kosong)
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            title,
                                            softWrap: true,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                              height: 1.1,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
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
                                              height: 10, color: AppColors.border),

                                          // Action Buttons (Edit & Delete)
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWell(
                                                onTap: () => _handleEditMenu(index),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: Row(
                                                    children: const [
                                                      Icon(Icons.edit_outlined,
                                                          size: 15,
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
                                                height: 12,
                                                width: 1,
                                                color: AppColors.border,
                                              ),
                                              InkWell(
                                                onTap: () => _handleDeleteMenu(index),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: Row(
                                                    children: const [
                                                      Icon(
                                                          Icons
                                                              .delete_outline_rounded,
                                                          size: 15,
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
                                  ],
                                ),
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
