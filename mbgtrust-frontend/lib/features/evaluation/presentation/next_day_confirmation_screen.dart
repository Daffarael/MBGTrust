import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/mock_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';
import '../data/models/evaluation_model.dart';
import '../data/models/rejection_reason_model.dart';
import '../data/repositories/evaluation_repository.dart';

class NextDayConfirmationScreen extends StatefulWidget {
  final String scheduleId;

  const NextDayConfirmationScreen({
    super.key,
    this.scheduleId = 'schd_10928375',
  });

  @override
  State<NextDayConfirmationScreen> createState() =>
      _NextDayConfirmationScreenState();
}

class _NextDayConfirmationScreenState
    extends State<NextDayConfirmationScreen> {
  bool? _isAccepted; // true = HADIR, false = MENOLAK
  String _selectedReasonCode = 'ALERGI';
  final TextEditingController _customNoteController = TextEditingController();
  bool _isFavorite = false;

  List<RejectionReasonModel> _reasons = [
    RejectionReasonModel(kode: 'ALERGI', label: 'Alergi Makanan / Pantangan Medis'),
    RejectionReasonModel(kode: 'SAKIT', label: 'Sakit / Tidak Masuk Sekolah'),
    RejectionReasonModel(kode: 'PANTANGAN_AGAMA', label: 'Pantangan Kepercayaan / Agama'),
    RejectionReasonModel(kode: 'IZIN_ABSEN', label: 'Izin / Kegiatan Luar Sekolah'),
    RejectionReasonModel(kode: 'TIDAK_SUKA_MENU', label: 'Tidak Suka Menu Besok'),
    RejectionReasonModel(kode: 'LAINNYA', label: 'Lainnya (Ketik Sendiri)'),
  ];

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchRejectionReasons();
  }

  Future<void> _fetchRejectionReasons() async {
    try {
      final repo = EvaluationRepository();
      final fetched = await repo.getRejectionReasons();
      if (fetched.isNotEmpty && mounted) {
        setState(() {
          _reasons = [
            ...fetched,
            RejectionReasonModel(kode: 'TIDAK_SUKA_MENU', label: 'Tidak Suka Menu Besok'),
            RejectionReasonModel(kode: 'LAINNYA', label: 'Lainnya (Ketik Sendiri)'),
          ];
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _customNoteController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_isAccepted == null) return;

    setState(() => _isSubmitting = true);
    final repo = EvaluationRepository();

    try {
      final req = ConfirmPresenceRequest(
        statusKehadiran: _isAccepted == true ? 'HADIR' : 'MENOLAK',
        kodeAlasanPenolakan: _isAccepted == false ? _selectedReasonCode : null,
        catatanKhusus: _selectedReasonCode == 'LAINNYA' ||
                _customNoteController.text.trim().isNotEmpty
            ? _customNoteController.text.trim()
            : null,
      );

      await repo.confirmTomorrowPresence(
        idJadwal: widget.scheduleId,
        request: req,
      );

      if (!mounted) return;
      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isAccepted == true
              ? 'Konfirmasi ketersediaan (MENERIMA PORSI) berhasil dicatat!'
              : 'Konfirmasi ketersediaan (MENOLAK PORSI) berhasil dicatat.'),
          backgroundColor:
              _isAccepted == true ? AppColors.success : AppColors.secondaryDark,
        ),
      );

      if (context.canPop()) {
        context.pop(true);
      } else {
        context.go('/home');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengirim konfirmasi: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tomorrowMenu = MockData.tomorrowMenu;
    final title = tomorrowMenu['nama_menu'] as String;
    final calories = (tomorrowMenu['kalori_kkal'] as num).toString();
    final protein = '${tomorrowMenu['protein_gram']}g';
    final carbs = '${tomorrowMenu['karbohidrat_gram']}g';
    final fats = '${tomorrowMenu['lemak_gram']}g';
    final photoUrl = tomorrowMenu['foto_url'] as String;
    final rating = (tomorrowMenu['rating_rata_rata'] as num).toDouble();
    final dateFormatted = tomorrowMenu['tanggal_jadwal'] as String;

    final studentAllergies = MockData.studentProfile['allergies'] as List<String>;
    final menuAllergens = tomorrowMenu['potensi_alergen'] as List<String>;
    final matchingAllergens = menuAllergens
        .where((a) => studentAllergies.contains(a))
        .toList();
    final hasAllergyMatch = matchingAllergens.isNotEmpty;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Large Hero Image Sliver AppBar (SAMA PERSIS DENGAN HALAMAN ULASAN)
          SliverAppBar(
            expandedHeight: 280.0,
            pinned: true,
            backgroundColor: AppColors.surface,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 18),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/home');
                  }
                },
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    _isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: _isFavorite ? AppColors.error : Colors.white,
                    size: 22,
                  ),
                  onPressed: () {
                    setState(() => _isFavorite = !_isFavorite);
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    photoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(
                      color: AppColors.primaryLight,
                      child: const Center(
                        child: Icon(
                          Icons.restaurant_menu_rounded,
                          size: 60,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Program Gizi Gratis',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: AppColors.secondary,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondaryDark,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Content Body (RESPONSIF DESKTOP & MOBILE)
          SliverToBoxAdapter(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateFormatted,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Baris Badges Kandungan Gizi (SAMA PERSIS DENGAN HALAMAN ULASAN)
                      const Text(
                        'Kandungan Gizi per Porsi:',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildNutritionBadge(
                            label: 'Energi',
                            value: '$calories kcal',
                            icon: Icons.local_fire_department_rounded,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(width: 8),
                          _buildNutritionBadge(
                            label: 'Protein',
                            value: protein,
                            icon: Icons.fitness_center_rounded,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          _buildNutritionBadge(
                            label: 'Karbo',
                            value: carbs,
                            icon: Icons.grain_rounded,
                            color: Colors.blueAccent,
                          ),
                          const SizedBox(width: 8),
                          _buildNutritionBadge(
                            label: 'Lemak',
                            value: fats,
                            icon: Icons.opacity_rounded,
                            color: Colors.orangeAccent,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Kotak Bahan Makanan Sehat (SAMA PERSIS DENGAN HALAMAN ULASAN)
                      const Text(
                        'Bahan Makanan Sehat:',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: const [
                            _IngredientTile(
                              name: 'Semur Daging Sapi Empuk',
                              portion: '90 gram',
                              note: 'Kaya Protein, Zat Besi & Seng',
                            ),
                            Divider(height: 16, color: AppColors.border),
                            _IngredientTile(
                              name: 'Sup Brokoli & Wortel',
                              portion: '70 gram',
                              note: 'Sumber Serat & Antioksidan',
                            ),
                            Divider(height: 16, color: AppColors.border),
                            _IngredientTile(
                              name: 'Nasi Putih Warm',
                              portion: '150 gram',
                              note: 'Karbohidrat Energi Harian',
                            ),
                            Divider(height: 16, color: AppColors.border),
                            _IngredientTile(
                              name: 'Telur Rebus Matang',
                              portion: '1 butir',
                              note: 'Protein Tambahan & Kolin',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // BANNER PERINGATAN ALERGI SISWA (JIKA ADA MATCHING ALERGEN)
                      if (hasAllergyMatch) ...[
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded,
                                  color: AppColors.secondaryDark, size: 26),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Peringatan Alergi Makanan!',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.secondaryDark,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Menu besok mengandung (${matchingAllergens.join(', ')}) yang tercatat dalam riwayat alergi Anda (Faizullatif Fajran)!',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textPrimary,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // FORM PILIHAN KETERSEDIAAN
                      const Text(
                        'Konfirmasi Ketersediaan Menerima Besok:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Konfirmasi Anda sangat penting agar Dapur SPPG memasak porsi presisi.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // BUTTON OPSI KETERSEDIAAN
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _isAccepted = true),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: _isAccepted == true
                                      ? AppColors.primaryLight
                                      : AppColors.surface,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: _isAccepted == true
                                        ? AppColors.primary
                                        : AppColors.border,
                                    width: _isAccepted == true ? 2 : 1,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: _isAccepted == true
                                          ? AppColors.primary
                                          : AppColors.textLight,
                                      size: 26,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Menerima Porsi',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: _isAccepted == true
                                            ? AppColors.primaryDark
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _isAccepted = false),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: _isAccepted == false
                                      ? AppColors.secondaryLight
                                      : AppColors.surface,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: _isAccepted == false
                                        ? AppColors.secondary
                                        : AppColors.border,
                                    width: _isAccepted == false ? 2 : 1,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.cancel_rounded,
                                      color: _isAccepted == false
                                          ? AppColors.secondaryDark
                                          : AppColors.textLight,
                                      size: 26,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Menolak Porsi',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: _isAccepted == false
                                            ? AppColors.secondaryDark
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // ALASAN PENOLAKAN
                      if (_isAccepted == false) ...[
                        const SizedBox(height: 20),
                        const Text(
                          'Pilih Alasan Penolakan / Lewatkan Porsi:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: _reasons.map((reason) {
                            final isSelected =
                                _selectedReasonCode == reason.kode;
                            return InkWell(
                              onTap: () {
                                setState(
                                    () => _selectedReasonCode = reason.kode);
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected
                                          ? Icons.radio_button_checked_rounded
                                          : Icons.radio_button_off_rounded,
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.textLight,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        reason.label,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: isSelected
                                              ? AppColors.textPrimary
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        if (_selectedReasonCode == 'LAINNYA') ...[
                          const SizedBox(height: 10),
                          CustomTextField(
                            hint: 'Tuliskan alasan spesifik Anda...',
                            controller: _customNoteController,
                          ),
                        ],
                      ],

                      const SizedBox(height: 28),

                      CustomButton(
                        text: 'Simpan Konfirmasi Ketersediaan',
                        isLoading: _isSubmitting,
                        onPressed: _isAccepted != null ? _handleSubmit : null,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionBadge({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 6),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IngredientTile extends StatelessWidget {
  final String name;
  final String portion;
  final String note;

  const _IngredientTile({
    required this.name,
    required this.portion,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check_circle_outline_rounded,
            size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                note,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Text(
          portion,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
