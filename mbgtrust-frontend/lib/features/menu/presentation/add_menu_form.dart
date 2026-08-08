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
  late TextEditingController _photoUrlController;

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
    _ingredientsController = TextEditingController(
        text: (data?['komposisi_bahan'] as List<dynamic>?)?.join(', ') ??
            'Dada Ayam Bakar, Nasi Putih, Tumis Buncis, Wortel');
    _allergensController = TextEditingController(
        text: (data?['potensi_alergen'] as List<dynamic>?)?.join(', ') ?? 'Kedelai');
    _photoUrlController = TextEditingController(
        text: data?['foto_url'] ?? data?['photoUrl'] ?? 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80');

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
    _photoUrlController.dispose();
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
        'name': _nameController.text.trim(),
        'kategori': _selectedCategory,
        'category': _selectedCategory == 'MAKANAN_BERAT' ? 'Makanan Berat' : (_selectedCategory == 'SUSU_DAN_BUAH' ? 'Susu & Buah' : 'Snack Sehat'),
        'kalori_kkal': int.tryParse(_caloriesController.text.trim()) ?? 550,
        'calories': int.tryParse(_caloriesController.text.trim()) ?? 550,
        'protein_gram': double.tryParse(_proteinController.text.trim()) ?? 28.5,
        'protein': '${_proteinController.text.trim()}g',
        'karbohidrat_gram': double.tryParse(_carbsController.text.trim()) ?? 65.0,
        'lemak_gram': double.tryParse(_fatsController.text.trim()) ?? 14.2,
        'komposisi_bahan': ingredients,
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
      constraints: const BoxConstraints(maxWidth: 540, maxHeight: 680),
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

              // ==========================================
              // UX STRICT: 1 PERTANYAAN 1 BARIS INPUT FIELD (VERTIKAL FULL WIDTH)
              // ==========================================

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

              // 3. Kandungan Kalori (kkal) - 1 Baris Penuh
              CustomTextField(
                label: '3. Kandungan Kalori (kkal)',
                hint: 'Contoh: 550',
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Kalori wajib diisi' : null,
              ),
              const SizedBox(height: 14),

              // 4. Kandungan Protein (gram) - 1 Baris Penuh
              CustomTextField(
                label: '4. Kandungan Protein (gram)',
                hint: 'Contoh: 28.5',
                controller: _proteinController,
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Protein wajib diisi' : null,
              ),
              const SizedBox(height: 14),

              // 5. Kandungan Karbohidrat (gram) - 1 Baris Penuh
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

              // 6. Kandungan Lemak (gram) - 1 Baris Penuh
              CustomTextField(
                label: '6. Kandungan Lemak (gram)',
                hint: 'Contoh: 14.2',
                controller: _fatsController,
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Lemak wajib diisi' : null,
              ),
              const SizedBox(height: 14),

              // 7. Estimasi Biaya Per Porsi (Rp) - 1 Baris Penuh
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

              // 8. Komposisi Bahan Makanan Sehat - 1 Baris Penuh
              CustomTextField(
                label: '8. Komposisi Bahan Makanan Sehat (Pisahkan Koma)',
                controller: _ingredientsController,
                hint: 'Dada Ayam Bakar 80g, Nasi Putih 150g, Tumis Buncis 60g',
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Bahan makanan wajib diisi'
                    : null,
              ),
              const SizedBox(height: 14),

              // 9. Potensi Alergen - 1 Baris Penuh
              CustomTextField(
                label: '9. Potensi Alergen Siswa (Pisahkan Koma)',
                controller: _allergensController,
                hint: 'Kedelai, Udang, Kacang Tanah',
              ),
              const SizedBox(height: 14),

              // 10. URL Foto Makanan HD - 1 Baris Penuh
              CustomTextField(
                label: '10. URL Foto Makanan HD (Unsplash/Web)',
                controller: _photoUrlController,
                hint: 'https://images.unsplash.com/...',
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
