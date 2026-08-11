import 'package:flutter/material.dart';
import 'package:mbgtrust/core/constants/mock_data.dart';
import 'package:mbgtrust/core/theme/app_colors.dart';
import 'package:mbgtrust/core/widgets/widgets.dart';
import 'add_ingredient_form.dart';

class AddMenuForm extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final Function(Map<String, dynamic> menuData) onSave;

  const AddMenuForm({
    super.key,
    this.initialData,
    required this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    Map<String, dynamic>? initialData,
    required Function(Map<String, dynamic> menuData) onSave,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        insetPadding: const EdgeInsets.all(16),
        child: AddMenuForm(
          initialData: initialData,
          onSave: onSave,
        ),
      ),
    );
  }

  @override
  State<AddMenuForm> createState() => _AddMenuFormState();
}

class _IngredientFieldControllers {
  final TextEditingController name;
  final TextEditingController sub;
  final TextEditingController portion;

  _IngredientFieldControllers({
    required String nameText,
    required String subText,
    required String portionText,
  })  : name = TextEditingController(text: nameText),
        sub = TextEditingController(text: subText),
        portion = TextEditingController(text: portionText);

  void dispose() {
    name.dispose();
    sub.dispose();
    portion.dispose();
  }
}

class _AddMenuFormState extends State<AddMenuForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _caloriesController;
  late TextEditingController _proteinController;
  late TextEditingController _carbsController;
  late TextEditingController _fatsController;
  late TextEditingController _allergensController;
  late TextEditingController _photoUrlController;

  final List<_IngredientFieldControllers> _ingredientFields = [];

  String _selectedCategory = 'MAKANAN_BERAT';
  final List<String> _categories = ['MAKANAN_BERAT', 'SUSU_DAN_BUAH', 'SNACK_SEHAT'];

  @override
  void initState() {
    super.initState();
    final data = widget.initialData;
    _nameController = TextEditingController(text: data?['nama_menu'] ?? data?['name'] ?? '');
    _caloriesController = TextEditingController(
        text: (data?['kalori_kkal'] ?? data?['calories'] ?? 550).toString());
    _proteinController = TextEditingController(
        text: (data?['protein_gram'] ?? 28.5).toString());
    _carbsController = TextEditingController(
        text: (data?['karbohidrat_gram'] ?? 65.0).toString());
    _fatsController = TextEditingController(
        text: (data?['lemak_gram'] ?? 14.2).toString());
    _allergensController = TextEditingController(
        text: (data?['potensi_alergen'] as List<dynamic>?)?.join(', ') ?? 'Kedelai');
    _photoUrlController = TextEditingController(
        text: data?['foto_url'] ?? data?['photoUrl'] ?? 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80');

    if (data?['kategori'] != null && _categories.contains(data!['kategori'])) {
      _selectedCategory = data['kategori'];
    }

    // Inisialisasi daftar rincian bahan makanan
    final richList = (data?['komposisi_bahan_detail'] as List<dynamic>?);
    if (richList != null && richList.isNotEmpty) {
      for (var item in richList) {
        _ingredientFields.add(_IngredientFieldControllers(
          nameText: item['nama']?.toString() ?? '',
          subText: item['sub']?.toString() ?? '',
          portionText: item['berat']?.toString() ?? '',
        ));
      }
    } else {
      final simpleList = (data?['komposisi_bahan'] as List<dynamic>?);
      if (simpleList != null && simpleList.isNotEmpty) {
        for (var item in simpleList) {
          _ingredientFields.add(_IngredientFieldControllers(
            nameText: item.toString(),
            subText: 'Sumber Gizi Pilihan SPPG',
            portionText: '80 gram',
          ));
        }
      } else {
        // Default 3 item jika baru
        _ingredientFields.add(_IngredientFieldControllers(
          nameText: 'Dada Ayam Bakar Kecap',
          subText: 'Sumber Utama Protein & Zat Besi',
          portionText: '80 gram',
        ));
        _ingredientFields.add(_IngredientFieldControllers(
          nameText: 'Tumis Buncis & Wortel',
          subText: 'Kaya Serat & Vitamin A',
          portionText: '60 gram',
        ));
        _ingredientFields.add(_IngredientFieldControllers(
          nameText: 'Nasi Putih Warm',
          subText: 'Karbohidrat Kompleks',
          portionText: '150 gram',
        ));
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    _allergensController.dispose();
    _photoUrlController.dispose();
    for (var field in _ingredientFields) {
      field.dispose();
    }
    super.dispose();
  }

  void _addIngredientField({String? name, String? sub, String? portion}) {
    setState(() {
      _ingredientFields.add(_IngredientFieldControllers(
        nameText: name ?? '',
        subText: sub ?? 'Kaya Nutrisi Sehat',
        portionText: portion ?? '50 gram',
      ));
    });
  }

  void _removeIngredientField(int index) {
    if (index >= 0 && index < _ingredientFields.length) {
      final fieldName = _ingredientFields[index].name.text.trim();
      if (fieldName.isNotEmpty) {
        showDialog(
          context: context,
          builder: (dialogCtx) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: const Text('Hapus Rincian Bahan',
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: Text(
                'Apakah Anda yakin ingin menghapus rincian bahan "$fieldName" dari resep menu ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: const Text('Batal',
                    style: TextStyle(color: AppColors.textSecondary)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Navigator.pop(dialogCtx);
                  setState(() {
                    _ingredientFields[index].dispose();
                    _ingredientFields.removeAt(index);
                  });
                },
                child: const Text('Hapus'),
              ),
            ],
          ),
        );
      } else {
        setState(() {
          _ingredientFields[index].dispose();
          _ingredientFields.removeAt(index);
        });
      }
    }
  }

  void _showMasterPresetsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            final allIngredients = MockData.masterHealthyIngredients;
            final filtered = searchQuery.isEmpty
                ? allIngredients
                : allIngredients.where((item) {
                    final name = item['nama']!.toLowerCase();
                    final sub = item['sub']!.toLowerCase();
                    final q = searchQuery.toLowerCase();
                    return name.contains(q) || sub.contains(q);
                  }).toList();

            return Container(
              padding: const EdgeInsets.all(18),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.75,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Close Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          '🥗 Pilih Bahan Baku dari Katalog',
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
                  const SizedBox(height: 8),

                  // Realtime Search Bar Input Field
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TextField(
                      onChanged: (val) {
                        setModalState(() {
                          searchQuery = val.trim();
                        });
                      },
                      decoration: InputDecoration(
                        hintText:
                            'Cari bahan baku (misal: Ayam, Sayur Buncis)...',
                        hintStyle: const TextStyle(
                            fontSize: 12.5, color: AppColors.textLight),
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: AppColors.primary, size: 20),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1),

                  // List of Ingredients
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      children: [
                        // Option A: Manual Blank Row Add
                        ListTile(
                          dense: true,
                          leading: const CircleAvatar(
                            radius: 14,
                            backgroundColor: AppColors.primaryLight,
                            child: Icon(Icons.edit_note_rounded,
                                color: AppColors.primary, size: 18),
                          ),
                          title: const Text(
                            'Ketik Bahan Manual',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: AppColors.primaryDark),
                          ),
                          subtitle: const Text(
                            'Tambah baris kosong untuk diketik sendiri',
                            style: TextStyle(
                                fontSize: 11, color: AppColors.textSecondary),
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded,
                              color: AppColors.primary),
                          onTap: () {
                            Navigator.pop(ctx);
                            _addIngredientField();
                          },
                        ),
                        const Divider(height: 12, color: AppColors.border),

                        if (filtered.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Center(
                              child: Column(
                                children: [
                                  const Icon(Icons.search_off_rounded,
                                      size: 40, color: AppColors.textLight),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Bahan "$searchQuery" belum ada di katalog.',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ...filtered.map((item) {
                            return ListTile(
                              dense: true,
                              leading: const Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: AppColors.primary,
                                  size: 20),
                              title: Text(
                                item['nama']!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              subtitle: Text(
                                '${item['sub']} • ${item['berat']}',
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary),
                              ),
                              trailing: const Icon(
                                  Icons.add_circle_outline_rounded,
                                  color: AppColors.primary,
                                  size: 20),
                              onTap: () {
                                Navigator.pop(ctx);
                                _addIngredientField(
                                  name: item['nama'],
                                  sub: item['sub'],
                                  portion: item['berat'],
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Bahan "${item['nama']}" berhasil ditambahkan!'),
                                    duration: const Duration(seconds: 1),
                                    backgroundColor: AppColors.primary,
                                  ),
                                );
                              },
                            );
                          }),
                      ],
                    ),
                  ),

                  // Option B: Shortcut Button to Add New Ingredient to Catalog
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.add_rounded,
                          color: AppColors.primary, size: 18),
                      label: const Text(
                        'Tambah Bahan Baru',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        AddIngredientForm.show(
                          context,
                          onSave: (newIngredient) {
                            _addIngredientField(
                              name: newIngredient['nama_bahan'],
                              sub: newIngredient['subjudul_nutrisi'],
                              portion: newIngredient['takaran_default'],
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Bahan "${newIngredient['nama_bahan']}" ditambahkan ke katalog & resep menu!'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      List<Map<String, String>> ingredientsDetail = [];
      List<String> ingredientsSimple = [];

      for (var field in _ingredientFields) {
        final name = field.name.text.trim();
        final sub = field.sub.text.trim();
        final portion = field.portion.text.trim();
        if (name.isNotEmpty) {
          ingredientsDetail.add({
            'nama': name,
            'sub': sub.isNotEmpty ? sub : 'Sumber Gizi Sehat',
            'berat': portion.isNotEmpty ? portion : '50 gram',
          });
          ingredientsSimple.add(name);
        }
      }

      List<String> allergens = _allergensController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final newMenuData = {
        'id_menu': widget.initialData?['id_menu'] ??
            'mnu_${DateTime.now().millisecondsSinceEpoch}',
        'nama_menu': _nameController.text.trim(),
        'name': _nameController.text.trim(),
        'kategori': _selectedCategory,
        'category': _selectedCategory == 'MAKANAN_BERAT'
            ? 'Makanan Berat'
            : (_selectedCategory == 'SUSU_DAN_BUAH' ? 'Susu & Buah' : 'Snack Sehat'),
        'kalori_kkal': int.tryParse(_caloriesController.text.trim()) ?? 550,
        'calories': int.tryParse(_caloriesController.text.trim()) ?? 550,
        'protein_gram': double.tryParse(_proteinController.text.trim()) ?? 28.5,
        'protein': '${_proteinController.text.trim()}g',
        'karbohidrat_gram': double.tryParse(_carbsController.text.trim()) ?? 65.0,
        'lemak_gram': double.tryParse(_fatsController.text.trim()) ?? 14.2,
        'komposisi_bahan': ingredientsSimple,
        'komposisi_bahan_detail': ingredientsDetail,
        'potensi_alergen': allergens,
        'foto_url': _photoUrlController.text.trim(),
        'photoUrl': _photoUrlController.text.trim(),
        'rating_rata_rata': widget.initialData?['rating_rata_rata'] ?? 4.9,
      };

      widget.onSave(newMenuData);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialData != null;

    return Container(
      constraints: const BoxConstraints(maxWidth: 580, maxHeight: 720),
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Form Title & Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      isEditing ? 'Edit Master Menu MBG' : 'Tambah Master Menu MBG',
                      softWrap: true,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 12),

              // 1. Nama Menu MBG
              CustomTextField(
                label: '1. Nama Menu MBG',
                hint: 'Contoh: Nasi Ayam Bakar Kecap & Tumis Buncis',
                controller: _nameController,
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Nama menu wajib diisi'
                    : null,
              ),
              const SizedBox(height: 14),

              // 2. Kategori Menu
              const Text(
                '2. Kategori Menu MBG',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  filled: true,
                  fillColor: AppColors.surface,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
                items: _categories.map((cat) {
                  final label = cat == 'MAKANAN_BERAT'
                      ? 'Makanan Berat'
                      : (cat == 'SUSU_DAN_BUAH' ? 'Susu & Buah' : 'Snack Sehat');
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(label),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedCategory = val);
                  }
                },
              ),
              const SizedBox(height: 14),

              // 3. Kandungan Kalori (kkal)
              CustomTextField(
                label: '3. Kandungan Kalori (kkal)',
                hint: 'Contoh: 550',
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Kalori wajib diisi' : null,
              ),
              const SizedBox(height: 14),

              // 4. Kandungan Protein (gram)
              CustomTextField(
                label: '4. Kandungan Protein (gram)',
                hint: 'Contoh: 28.5',
                controller: _proteinController,
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Protein wajib diisi' : null,
              ),
              const SizedBox(height: 14),

              // 5. Kandungan Karbohidrat (gram)
              CustomTextField(
                label: '5. Kandungan Karbohidrat (gram)',
                hint: 'Contoh: 65.0',
                controller: _carbsController,
                keyboardType: TextInputType.number,
                validator: (val) => val == null || val.isEmpty
                    ? 'Karbohidrat wajib diisi'
                    : null,
              ),
              const SizedBox(height: 14),

              // 6. Kandungan Lemak (gram)
              CustomTextField(
                label: '6. Kandungan Lemak (gram)',
                hint: 'Contoh: 14.2',
                controller: _fatsController,
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Lemak wajib diisi' : null,
              ),
              const SizedBox(height: 14),

              // =========================================================
              // 8. RINCIAN BAHAN MAKANAN SEHAT (BEBAS OVERFLOW & QUICK PRESETS)
              // =========================================================
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      '8. Rincian Bahan Makanan Sehat',
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: _showMasterPresetsModal,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.playlist_add_rounded,
                              color: AppColors.primaryDark, size: 18),
                          SizedBox(width: 4),
                          Text(
                            'Tambah Bahan',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              _ingredientFields.isEmpty
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Center(
                        child: Text(
                          'Belum ada bahan baku dipilih. Tekan "Tambah Bahan" di atas.',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        for (int i = 0; i < _ingredientFields.length; i++) ...[
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: AppColors.primary.withValues(alpha: 0.2)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: AppColors.primaryLight,
                                  child: Text(
                                    '${i + 1}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _ingredientFields[i].name.text.isNotEmpty
                                            ? _ingredientFields[i].name.text
                                            : 'Bahan Makanan Sehat',
                                        softWrap: true,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${_ingredientFields[i].sub.text.isNotEmpty ? _ingredientFields[i].sub.text : 'Manfaat Nutrisi'} • ${_ingredientFields[i].portion.text.isNotEmpty ? _ingredientFields[i].portion.text : '50 gram'}',
                                        softWrap: true,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded,
                                      color: AppColors.error, size: 20),
                                  onPressed: () => _removeIngredientField(i),
                                  tooltip: 'Hapus dari Resep Menu',
                                ),
                              ],
                            ),
                          ),
                        ]
                      ],
                    ),
              const SizedBox(height: 14),

              // 9. Potensi Alergen
              CustomTextField(
                label: '9. Potensi Alergen Siswa (Pisahkan Koma)',
                controller: _allergensController,
                hint: 'Kedelai, Udang, Kacang Tanah',
              ),
              const SizedBox(height: 14),

              // 10. URL Foto Makanan HD
              CustomTextField(
                label: '10. URL Foto Makanan (Unsplash / Google Drive Link)',
                controller: _photoUrlController,
                hint: 'https://images.unsplash.com/... atau Drive Link',
              ),
              const SizedBox(height: 24),

              CustomButton(
                text: isEditing ? 'Simpan Perubahan Menu' : 'Simpan Menu Makanan Baru',
                prefixIcon: Icon(
                  isEditing ? Icons.save_rounded : Icons.add_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: _handleSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


