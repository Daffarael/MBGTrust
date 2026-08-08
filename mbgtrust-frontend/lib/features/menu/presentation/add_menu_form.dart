import 'package:flutter/material.dart';
import '../../../core/constants/mock_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

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
  late TextEditingController _costController;
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
    _costController = TextEditingController(
        text: (data?['estimasi_biaya_per_porsi'] ?? 15000).toString());
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
    _costController.dispose();
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
    if (_ingredientFields.length > 1) {
      setState(() {
        _ingredientFields[index].dispose();
        _ingredientFields.removeAt(index);
      });
    }
  }

  void _showMasterPresetsModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxHeight: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '🍱 Pilih dari Bank Master Bahan Sehat',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView.separated(
                  itemCount: MockData.masterHealthyIngredients.length,
                  separatorBuilder: (ctx, i) => const Divider(height: 1, color: AppColors.border),
                  itemBuilder: (ctx, i) {
                    final item = MockData.masterHealthyIngredients[i];
                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.check_circle_outline_rounded,
                          color: AppColors.primary, size: 20),
                      title: Text(
                        item['nama']!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      subtitle: Text(
                        '${item['sub']} • ${item['berat']}',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                      trailing: const Icon(Icons.add_rounded, color: AppColors.primary),
                      onTap: () {
                        Navigator.pop(ctx);
                        _addIngredientField(
                          name: item['nama'],
                          sub: item['sub'],
                          portion: item['berat'],
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Bahan "${item['nama']}" ditambahkan!'),
                            duration: const Duration(seconds: 1),
                            backgroundColor: AppColors.primary,
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
        'estimasi_biaya_per_porsi':
            double.tryParse(_costController.text.trim()) ?? 15000.0,
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

              // 7. Estimasi Biaya Per Porsi (Rp)
              CustomTextField(
                label: '7. Estimasi Biaya Per Porsi (Rp)',
                hint: 'Contoh: 15000',
                controller: _costController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.attach_money_rounded),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Biaya porsi wajib' : null,
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
                  IconButton(
                    icon: const Icon(Icons.playlist_add_rounded,
                        color: AppColors.primaryDark, size: 22),
                    onPressed: _showMasterPresetsModal,
                    tooltip: 'Pilih dari Bank Master Bahan',
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_rounded,
                        color: AppColors.primary, size: 22),
                    onPressed: () => _addIngredientField(),
                    tooltip: 'Tambah Baris Bahan Kosong',
                  ),
                ],
              ),
              const SizedBox(height: 6),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < _ingredientFields.length; i++) ...[
                      if (i > 0) const Divider(height: 16, color: AppColors.border),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: CircleAvatar(
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
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              children: [
                                CustomTextField(
                                  label: 'Nama Bahan Baku',
                                  hint: 'Dada Ayam Bakar Kecap',
                                  controller: _ingredientFields[i].name,
                                  validator: (v) => v == null || v.trim().isEmpty
                                      ? 'Nama bahan wajib'
                                      : null,
                                ),
                                const SizedBox(height: 8),
                                CustomTextField(
                                  label: 'Subjudul Nutrisi / Manfaat',
                                  hint: 'Sumber Utama Protein & Zat Besi',
                                  controller: _ingredientFields[i].sub,
                                ),
                                const SizedBox(height: 8),
                                CustomTextField(
                                  label: 'Berat Gramasi Porsi',
                                  hint: '80 gram',
                                  controller: _ingredientFields[i].portion,
                                ),
                              ],
                            ),
                          ),
                          if (_ingredientFields.length > 1)
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded,
                                  color: AppColors.error, size: 20),
                              onPressed: () => _removeIngredientField(i),
                            ),
                        ],
                      ),
                    ]
                  ],
                ),
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
                text: isEditing ? 'Simpan Perubahan Menu' : 'Tambah Menu ke Master API',
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
