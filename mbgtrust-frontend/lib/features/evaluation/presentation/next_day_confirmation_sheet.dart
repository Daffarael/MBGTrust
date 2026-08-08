import 'package:flutter/material.dart';
import '../../../core/constants/mock_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';
import '../data/models/evaluation_model.dart';
import '../data/models/rejection_reason_model.dart';
import '../data/repositories/evaluation_repository.dart';

class NextDayConfirmationSheet extends StatefulWidget {
  final String scheduleId;
  final Function(bool isAccepted, String? reason)? onConfirm;

  const NextDayConfirmationSheet({
    super.key,
    this.scheduleId = 'schd_10928375',
    this.onConfirm,
  });

  static Future<void> show(
    BuildContext context, {
    String scheduleId = 'schd_10928375',
    Function(bool isAccepted, String? reason)? onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NextDayConfirmationSheet(
        scheduleId: scheduleId,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<NextDayConfirmationSheet> createState() =>
      _NextDayConfirmationSheetState();
}

class _NextDayConfirmationSheetState extends State<NextDayConfirmationSheet> {
  bool? _isAccepted; // true = HADIR, false = MENOLAK
  String _selectedReasonCode = 'ALERGI';
  final TextEditingController _customNoteController = TextEditingController();

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

      if (widget.onConfirm != null) {
        widget.onConfirm!(_isAccepted!, _selectedReasonCode);
      }
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isAccepted == true
              ? 'Konfirmasi presensi esok hari (BERSERDA HADIR) berhasil dicatat!'
              : 'Konfirmasi presensi esok hari (MENOLAK PORSI) berhasil dicatat.'),
          backgroundColor:
              _isAccepted == true ? AppColors.success : AppColors.secondaryDark,
        ),
      );
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
    final studentAllergies = MockData.studentProfile['allergies'] as List<String>;
    final menuAllergens = tomorrowMenu['potensi_alergen'] as List<String>;

    // Cek apakah ada alergen yang cocok dengan riwayat alergi siswa
    final matchingAllergens = menuAllergens
        .where((a) => studentAllergies.contains(a))
        .toList();
    final hasAllergyMatch = matchingAllergens.isNotEmpty;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.event_available_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Konfirmasi Presensi Menu Besok',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Jadwal: ${tomorrowMenu['tanggal_jadwal']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // KARTU DETAIL RENCANA MENU BESOK (H+1)
            Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      tomorrowMenu['foto_url'] as String,
                      height: 130,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        height: 130,
                        color: AppColors.primaryLight,
                        child: const Center(
                          child: Icon(Icons.restaurant_menu_rounded,
                              size: 40, color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${tomorrowMenu['kalori_kkal']} kkal • Protein ${tomorrowMenu['protein_gram']}g',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${tomorrowMenu['tanggal_jadwal']}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondaryDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tomorrowMenu['nama_menu'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Bahan: ${(tomorrowMenu['komposisi_bahan'] as List<dynamic>).join(', ')}',
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
            const SizedBox(height: 14),

            // BANNER PERINGATAN ALERGI SISWA (JIKA ADA MATCHING ALERGEN)
            if (hasAllergyMatch) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: AppColors.secondaryDark, size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Peringatan Alergi Makanan!',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondaryDark,
                            ),
                          ),
                          Text(
                            'Menu besok mengandung (${matchingAllergens.join(', ')}) yang ada pada riwayat alergi Anda!',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            const Text(
              'Apakah Anda bersedia menerima porsi makanan esok hari?',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            // Pilihan Status (Ya, Hadir vs Tidak, Menolak)
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isAccepted = true),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: _isAccepted == true
                            ? AppColors.primaryLight
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isAccepted == true
                              ? AppColors.primary
                              : AppColors.border,
                          width: _isAccepted == true ? 2 : 1,
                        ),
                      ),
                      child: Column(
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
                            'Ya, Bersedia Hadir',
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
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: _isAccepted == false
                            ? AppColors.secondaryLight
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isAccepted == false
                              ? AppColors.secondary
                              : AppColors.border,
                          width: _isAccepted == false ? 2 : 1,
                        ),
                      ),
                      child: Column(
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
                            'Tidak Bersedia (Menolak)',
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
              const SizedBox(height: 16),
              const Text(
                'Pilih Alasan Penolakan / Lewatkan Porsi:',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Column(
                children: _reasons.map((reason) {
                  final isSelected = _selectedReasonCode == reason.kode;
                  return InkWell(
                    onTap: () {
                      setState(() => _selectedReasonCode = reason.kode);
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 4),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked_rounded
                                : Icons.radio_button_off_rounded,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textLight,
                            size: 18,
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
                const SizedBox(height: 8),
                CustomTextField(
                  hint: 'Tuliskan alasan spesifik Anda...',
                  controller: _customNoteController,
                ),
              ],
            ],

            const SizedBox(height: 20),

            CustomButton(
              text: 'Simpan Konfirmasi Presensi',
              isLoading: _isSubmitting,
              onPressed: _isAccepted != null ? _handleSubmit : null,
            ),
          ],
        ),
      ),
    );
  }
}
