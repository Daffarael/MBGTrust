import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/responsive_layout.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final List<String> _allAllergies = [
    'Kacang Tanah',
    'Udang / Seafood',
    'Telur Ayam',
    'Susu Sapi / Lactose',
    'Ikan Laut',
    'Kedelai / Tahu Tempe',
    'Gandum / Gluten',
  ];

  final List<String> _selectedAllergies = ['Kacang Tanah', 'Udang / Seafood'];
  final TextEditingController _customNoteController =
      TextEditingController(text: 'Tidak suka sayur pahit seperti pare.');

  @override
  void dispose() {
    _customNoteController.dispose();
    super.dispose();
  }

  void _toggleAllergy(String allergy) {
    setState(() {
      if (_selectedAllergies.contains(allergy)) {
        _selectedAllergies.remove(allergy);
      } else {
        _selectedAllergies.add(allergy);
      }
    });
  }

  void _savePreferences() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preferensi alergi & pantangan berhasil disimpan.'),
        backgroundColor: AppColors.primary,
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      appBar: AppBar(
        title: const Text(
          'Preferensi & Alergi Makanan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondaryLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.secondaryDark.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.warning_amber_rounded, size: 28, color: AppColors.secondaryDark),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Pilih bahan makanan yang memicu alergi atau pantangan medis Anda agar tim dapur SPPG dapat menyesuaikan porsi aman.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.secondaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Daftar Bahan Makanan Alergen',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 10,
              children: _allAllergies.map((allergy) {
                final isSelected = _selectedAllergies.contains(allergy);
                return FilterChip(
                  label: Text(allergy),
                  selected: isSelected,
                  onSelected: (selected) => _toggleAllergy(allergy),
                  selectedColor: AppColors.primaryLight,
                  checkmarkColor: AppColors.primaryDark,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                  ),
                  backgroundColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            const Text(
              'Catatan Tambahan / Pantangan Khusus 📝',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            TextFormField(
              controller: _customNoteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Tuliskan jika ada pantangan makanan lainnya...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _savePreferences,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Simpan Preferensi Makanan',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
