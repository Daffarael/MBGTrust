import 'package:flutter/material.dart';
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

class _AddMenuFormState extends State<AddMenuForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _caloriesController;
  late TextEditingController _proteinController;
  late TextEditingController _carbsController;
  late TextEditingController _fatsController;
  late TextEditingController _costController;
  late TextEditingController _ingredientsController;
  late TextEditingController _allergensController;

  String _selectedCategory = 'MAKANAN_BERAT';
  final List<String> _categories = ['MAKANAN_BERAT', 'CAMILAN', 'SUPLEMEN'];

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
    _ingredientsController = TextEditingController(
        text: (data?['komposisi_bahan'] as List<dynamic>?)?.join(', ') ??
            'Dada Ayam, Nasi Putih, Buncis, Wortel');
    _allergensController = TextEditingController(
        text: (data?['potensi_alergen'] as List<dynamic>?)?.join(', ') ?? 'Kedelai');

    if (data?['kategori'] != null && _categories.contains(data!['kategori'])) {
      _selectedCategory = data['kategori'];
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
    _ingredientsController.dispose();
    _allergensController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      List<String> ingredients = _ingredientsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      List<String> allergens = _allergensController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final newMenuData = {
        'id_menu': widget.initialData?['id_menu'] ??
            'mnu_${DateTime.now().millisecondsSinceEpoch}',
        'nama_menu': _nameController.text.trim(),
        'kategori': _selectedCategory,
        'kalori_kkal': int.tryParse(_caloriesController.text.trim()) ?? 550,
        'protein_gram': double.tryParse(_proteinController.text.trim()) ?? 28.5,
        'karbohidrat_gram': double.tryParse(_carbsController.text.trim()) ?? 65.0,
        'lemak_gram': double.tryParse(_fatsController.text.trim()) ?? 14.2,
        'komposisi_bahan': ingredients,
        'potensi_alergen': allergens,
        'estimasi_biaya_per_porsi':
            double.tryParse(_costController.text.trim()) ?? 15000.0,
      };

      widget.onSave(newMenuData);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialData != null;

    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? 'Edit Master Menu' : 'Tambah Master Menu',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Menu Name Input
              CustomTextField(
                label: 'Nama Menu',
                hint: 'Nasi Ayam Bakar Kecap & Tumis Buncis',
                controller: _nameController,
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Nama menu wajib diisi'
                    : null,
              ),
              const SizedBox(height: 12),

              // Category Dropdown
              const Text(
                'Kategori Menu',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
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
                    child: Text(cat),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedCategory = val);
                  }
                },
              ),
              const SizedBox(height: 12),

              // Nutrition Row 1
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Kalori (kkal)',
                      controller: _caloriesController,
                      keyboardType: TextInputType.number,
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Wajib' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(
                      label: 'Protein (gram)',
                      controller: _proteinController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Nutrition Row 2
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Karbohidrat (gram)',
                      controller: _carbsController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(
                      label: 'Lemak (gram)',
                      controller: _fatsController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Estimasi Biaya & Komposisi Bahan
              CustomTextField(
                label: 'Estimasi Biaya Per Porsi (Rp)',
                controller: _costController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.attach_money_rounded),
              ),
              const SizedBox(height: 12),

              CustomTextField(
                label: 'Komposisi Bahan (Pisahkan Koma)',
                controller: _ingredientsController,
                hint: 'Dada Ayam, Nasi Putih, Buncis, Wortel',
              ),
              const SizedBox(height: 12),

              CustomTextField(
                label: 'Potensi Alergen (Pisahkan Koma)',
                controller: _allergensController,
                hint: 'Kedelai, Udang',
              ),
              const SizedBox(height: 24),

              CustomButton(
                text: isEditing ? 'Simpan Perubahan' : 'Tambah Menu ke Master API',
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
