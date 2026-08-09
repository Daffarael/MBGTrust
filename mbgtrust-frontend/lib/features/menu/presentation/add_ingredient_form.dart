import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

class AddIngredientForm extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final Function(Map<String, dynamic> ingredientData) onSave;

  const AddIngredientForm({
    super.key,
    this.initialData,
    required this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    Map<String, dynamic>? initialData,
    required Function(Map<String, dynamic> ingredientData) onSave,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        insetPadding: const EdgeInsets.all(16),
        child: AddIngredientForm(
          initialData: initialData,
          onSave: onSave,
        ),
      ),
    );
  }

  @override
  State<AddIngredientForm> createState() => _AddIngredientFormState();
}

class _AddIngredientFormState extends State<AddIngredientForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _subController;
  late TextEditingController _portionController;
  late TextEditingController _caloriesController;
  late TextEditingController _allergensController;

  String _selectedCategory = 'PROTEIN_HEWANI';
  final List<String> _categories = [
    'PROTEIN_HEWANI',
    'PROTEIN_NABATI',
    'KARBOHIDRAT',
    'SAYUR_DAN_BUAH',
    'SUSU_DAN_PELENGKAP',
  ];

  @override
  void initState() {
    super.initState();
    final data = widget.initialData;
    _nameController = TextEditingController(
        text: data?['nama_bahan'] ?? data?['nama'] ?? '');
    _subController = TextEditingController(
        text: data?['subjudul_nutrisi'] ?? data?['sub'] ?? '');
    _portionController = TextEditingController(
        text: data?['takaran_default'] ?? data?['berat'] ?? '80 gram');
    _caloriesController = TextEditingController(
        text: (data?['kalori_per_100g'] ?? 150).toString());
    _allergensController = TextEditingController(
        text: (data?['potensi_alergen'] as List<dynamic>?)?.join(', ') ?? '');

    if (data?['kategori_bahan'] != null &&
        _categories.contains(data!['kategori_bahan'])) {
      _selectedCategory = data['kategori_bahan'];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _subController.dispose();
    _portionController.dispose();
    _caloriesController.dispose();
    _allergensController.dispose();
    super.dispose();
  }

  String _getCategoryLabel(String cat) {
    switch (cat) {
      case 'PROTEIN_HEWANI':
        return 'Protein Hewani';
      case 'PROTEIN_NABATI':
        return 'Protein Nabati';
      case 'KARBOHIDRAT':
        return 'Karbohidrat';
      case 'SAYUR_DAN_BUAH':
        return 'Sayur & Buah';
      case 'SUSU_DAN_PELENGKAP':
        return 'Susu & Pelengkap';
      default:
        return 'Bahan Sehat';
    }
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      List<String> allergens = _allergensController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final newIngredientData = {
        'id_bahan': widget.initialData?['id_bahan'] ??
            'bhn_${DateTime.now().millisecondsSinceEpoch}',
        'nama_bahan': _nameController.text.trim(),
        'nama': _nameController.text.trim(),
        'kategori_bahan': _selectedCategory,
        'kategori': _getCategoryLabel(_selectedCategory),
        'subjudul_nutrisi': _subController.text.trim(),
        'sub': _subController.text.trim(),
        'takaran_default': _portionController.text.trim(),
        'berat': _portionController.text.trim(),
        'kalori_per_100g':
            int.tryParse(_caloriesController.text.trim()) ?? 150,
        'potensi_alergen': allergens,
      };

      widget.onSave(newIngredientData);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialData != null;

    return Container(
      constraints: const BoxConstraints(maxWidth: 540, maxHeight: 680),
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header & Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      isEditing
                          ? 'Edit Master Bahan Makanan'
                          : 'Tambah Master Bahan Makanan',
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

              // 1. Nama Bahan Baku
              CustomTextField(
                label: '1. Nama Bahan Makanan Sehat',
                hint: 'Contoh: Dada Ayam Bakar Kecap',
                controller: _nameController,
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Nama bahan wajib diisi'
                    : null,
              ),
              const SizedBox(height: 14),

              // 2. Kategori Bahan Baku
              const Text(
                '2. Kategori Bahan Makanan',
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
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(_getCategoryLabel(cat)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedCategory = val);
                  }
                },
              ),
              const SizedBox(height: 14),

              // 3. Subjudul Nutrisi / Manfaat Utama
              CustomTextField(
                label: '3. Subjudul Nutrisi / Manfaat Utama',
                hint: 'Contoh: Sumber Utama Protein & Zat Besi',
                controller: _subController,
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Subjudul nutrisi wajib diisi'
                    : null,
              ),
              const SizedBox(height: 14),

              // 4. Takaran Porsi Default
              CustomTextField(
                label: '4. Takaran Porsi Default',
                hint: 'Contoh: 80 gram atau 200 ml',
                controller: _portionController,
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Takaran default wajib'
                    : null,
              ),
              const SizedBox(height: 14),

              // 5. Estimasi Kalori per 100g
              CustomTextField(
                label: '5. Estimasi Kalori per 100g (kkal)',
                hint: 'Contoh: 165',
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Kalori wajib diisi' : null,
              ),
              const SizedBox(height: 14),

              // 6. Potensi Alergen Siswa
              CustomTextField(
                label: '6. Potensi Alergen Siswa (Pisahkan Koma)',
                hint: 'Contoh: Kedelai, Udang (Kosongkan jika aman)',
                controller: _allergensController,
              ),
              const SizedBox(height: 24),

              CustomButton(
                text: isEditing
                    ? 'Simpan Perubahan Bahan'
                    : 'Simpan Bahan Makanan Baru',
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
