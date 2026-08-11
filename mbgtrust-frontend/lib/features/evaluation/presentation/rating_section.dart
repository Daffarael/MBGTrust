import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';
import '../data/models/evaluation_model.dart';
import '../data/repositories/evaluation_repository.dart';

class RatingSection extends ConsumerStatefulWidget {
  final String scheduleId;
  final VoidCallback? onSubmitted;
  final VoidCallback? onOpenNextDayConfirmation;

  const RatingSection({
    super.key,
    this.scheduleId = 'schd_10928374',
    this.onSubmitted,
    this.onOpenNextDayConfirmation,
  });

  @override
  ConsumerState<RatingSection> createState() => _RatingSectionState();
}

class _RatingSectionState extends ConsumerState<RatingSection> {
  bool _menerimaPorsi = true;
  String _selectedReason = 'Sakit';
  int _penilaianRasa = 5;
  int _penilaianKesukaan = 4;
  int _penilaianPorsi = 4;
  double _sisaMakananPercentage = 0.0; // 0.0 - 100.0
  final TextEditingController _commentController =
      TextEditingController(text: 'Daging ayamnya empuk dan bumbunya pas.');
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _showPreSubmitConfirmationDialog() {
    if (_menerimaPorsi) {
      final words = _commentController.text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
      if (words.length < 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mohon isi ulasan teks minimal 3 kata agar membantu tim dapur.'),
            backgroundColor: AppColors.secondaryDark,
          ),
        );
        return;
      }
    }

    showDialog(
      context: context,
      builder: (confirmCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.lock_clock_rounded, color: AppColors.primary, size: 24),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'Konfirmasi Pengiriman',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: const Text(
          'Apakah Anda yakin ingin mengirim evaluasi menu hari ini?\n\nUlasan yang telah dikirim bersifat permanen dan tidak dapat diubah kembali.',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(confirmCtx),
            child: const Text(
              'Batal',
              style: TextStyle(color: AppColors.textLight),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(confirmCtx);
              _executeSubmit();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Ya, Kirim Ulasan'),
          ),
        ],
      ),
    );
  }

  Future<void> _executeSubmit() async {
    setState(() => _isSubmitting = true);
    final repo = EvaluationRepository();

    try {
      final req = SubmitEvaluationRequest(
        menerimaPorsi: _menerimaPorsi,
        penilaianRasa: _menerimaPorsi ? _penilaianRasa : 1,
        penilaianKesukaan: _menerimaPorsi ? _penilaianKesukaan : 1,
        penilaianPorsi: _menerimaPorsi ? _penilaianPorsi : 1,
        persentaseSisaMakanan: _menerimaPorsi ? _sisaMakananPercentage : 100.0,
        masukanKualitatif: _menerimaPorsi ? _commentController.text.trim() : 'Tidak menerima porsi.',
      );

      await repo.submitEvaluation(
        idJadwal: widget.scheduleId,
        request: req,
      );

      if (!mounted) return;
      setState(() => _isSubmitting = false);

      if (widget.onSubmitted != null) widget.onSubmitted!();

      // MUNCULKAN DIALOG SUKSES BERSIH TANPA XP GAMIFIKASI
      _showCleanSuccessDialog(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengirim evaluasi: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _showCleanSuccessDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (dialogCtx) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 380),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Trophy / Pahlawan Makanan
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.emoji_events_rounded, color: AppColors.primary, size: 44),
                ),
                const SizedBox(height: 14),

                const Text(
                  'Kamu Pahlawan Makanan Hari Ini!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),

                const Text(
                  'Terima kasih telah menghabiskan makanan dan memberikan masukan jujur untuk Tim Dapur SPPG.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),

                // Banner Feedback Gamifikasi & Impact CO2
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.stars_rounded, color: AppColors.primary, size: 20),
                          SizedBox(width: 6),
                          Text(
                            '+50 Poin XP Diberikan!',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(height: 1),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Row(
                            children: [
                              Icon(Icons.eco_rounded, size: 14, color: AppColors.primary),
                              SizedBox(width: 4),
                              Text('4.2 kg CO₂ Tercegah', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.water_drop_rounded, size: 14, color: Color(0xFF0284C7)),
                              SizedBox(width: 4),
                              Text('120 Liter Air Dihemat', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Tombol 1: Lihat Papan Peringkat & Dampak
                CustomButton(
                  text: 'Lihat Papan Peringkat & Dampak',
                  prefixIcon: const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 18),
                  onPressed: () {
                    Navigator.pop(dialogCtx);
                    if (Navigator.canPop(parentContext)) {
                      Navigator.pop(parentContext, true);
                    }
                    parentContext.go('/profil/gamifikasi', extra: {'justEvaluated': true});
                  },
                ),
                const SizedBox(height: 8),

                // Tombol 2: Kembali ke Beranda
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogCtx);
                    if (Navigator.canPop(parentContext)) {
                      Navigator.pop(parentContext, true);
                    } else {
                      parentContext.go('/home');
                    }
                  },
                  child: const Text(
                    'Kembali ke Beranda',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStarRatingRow({
    required String title,
    required String subtitle,
    required int currentValue,
    required ValueChanged<int> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '$currentValue / 5',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starVal = index + 1;
              final isFilled = starVal <= currentValue;
              return GestureDetector(
                onTap: () => onChanged(starVal),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Icon(
                    isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: isFilled ? AppColors.secondary : AppColors.textLight,
                    size: 32,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Color _getWasteColor(double pct) {
    if (pct == 0.0) return AppColors.primary;
    if (pct < 50.0) return AppColors.secondaryDark;
    return AppColors.error;
  }

  String _getWasteLabel(double pct) {
    if (pct == 0.0) return 'Habis Dimakan (0%)';
    if (pct < 50.0) return 'Tersisa Sedikit (${pct.round()}%)';
    if (pct < 100.0) return 'Tersisa Sebagian Besar (${pct.round()}%)';
    return 'Tersisa Utuh (100%)';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Evaluasi Menu Hari Ini',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Berikan masukan jujur untuk membantu SPPG menjaga kualitas gizi',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),

          // Switch Status Menerima Porsi
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _menerimaPorsi ? AppColors.primaryLight : AppColors.secondaryLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _menerimaPorsi ? AppColors.primary : AppColors.secondary,
              ),
            ),
            child: SwitchListTile(
              title: const Text(
                'Apakah Anda Menerima Makanan Hari Ini?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              subtitle: Text(
                _menerimaPorsi
                    ? 'Ya, Menerima dan Mengonsumsi Paket Makanan'
                    : 'Tidak Menerima (Tidak Hadir / Izin / Sakit)',
                style: TextStyle(
                  fontSize: 12,
                  color: _menerimaPorsi ? AppColors.primaryDark : AppColors.secondaryDark,
                ),
              ),
              value: _menerimaPorsi,
              activeThumbColor: AppColors.primary,
              onChanged: (val) => setState(() => _menerimaPorsi = val),
            ),
          ),
          const SizedBox(height: 20),

          if (!_menerimaPorsi) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.assignment_turned_in_rounded, size: 24, color: AppColors.secondaryDark),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Pilih Alasan Tidak Mengonsumsi MBG',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Sakit',
                      'Tidak Hadir / Izin',
                      'Alergi Makanan',
                      'Pantangan Agama / Lainnya'
                    ].map((reason) {
                      final isSelected = _selectedReason == reason;
                      return ChoiceChip(
                        label: Text(reason),
                        selected: isSelected,
                        selectedColor: AppColors.secondaryDark,
                        backgroundColor: AppColors.surface,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 12,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedReason = reason);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    label: 'Catatan Khusus (Opsional)',
                    hint: 'Tuliskan keterangan tambahan...',
                    controller: _commentController,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Kirim Alasan Penolakan',
                    prefixIcon: const Icon(Icons.send_rounded, size: 18, color: Colors.white),
                    isLoading: _isSubmitting,
                    onPressed: _showPreSubmitConfirmationDialog,
                  ),
                ],
              ),
            ),
          ] else ...[
            // Pertanyaan 1: Rasa Makanan
            _buildStarRatingRow(
              title: '1. Penilaian Rasa Makanan',
              subtitle: 'Bagaimana kelezatan dan bumbu masakan hari ini?',
              currentValue: _penilaianRasa,
              onChanged: (val) => setState(() => _penilaianRasa = val),
            ),

            // Pertanyaan 2: Kesukaan Menu
            _buildStarRatingRow(
              title: '2. Tingkat Kesukaan Menu',
              subtitle: 'Seberapa suka Anda dengan variasi menu hari ini?',
              currentValue: _penilaianKesukaan,
              onChanged: (val) => setState(() => _penilaianKesukaan = val),
            ),

            // Pertanyaan 3: Ukuran Porsi
            _buildStarRatingRow(
              title: '3. Kecukupan Ukuran Porsi',
              subtitle: 'Apakah porsi makanan cukup membuat Anda kenyang?',
              currentValue: _penilaianPorsi,
              onChanged: (val) => setState(() => _penilaianPorsi = val),
            ),

            // Pertanyaan 4: Sisa Makanan SLIDER (0% - 100%)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '4. Estimasi Sisa Makanan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Geser garis slider dari 0% (habis) hingga 100% (sisa semua)',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Slider Theme & Component
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: _getWasteColor(_sisaMakananPercentage),
                      inactiveTrackColor: AppColors.border,
                      thumbColor: _getWasteColor(_sisaMakananPercentage),
                      overlayColor: _getWasteColor(_sisaMakananPercentage).withValues(alpha: 0.2),
                      valueIndicatorColor: _getWasteColor(_sisaMakananPercentage),
                      valueIndicatorTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Slider(
                      value: _sisaMakananPercentage,
                      min: 0.0,
                      max: 100.0,
                      divisions: 100,
                      label: '${_sisaMakananPercentage.round()}%',
                      onChanged: (val) {
                        setState(() => _sisaMakananPercentage = val);
                      },
                    ),
                  ),

                  // Legend Range 0% - 50% - 100%
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('0% (Habis)',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary)),
                      Text('50%',
                          style: TextStyle(
                              fontSize: 10, color: AppColors.textLight)),
                      Text('100% (Sisa Utuh)',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.error)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // DEDICATED STATUS CARD DI BAWAH GARIS SLIDER
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: _getWasteColor(_sisaMakananPercentage).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _getWasteColor(_sisaMakananPercentage).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _sisaMakananPercentage == 0.0
                              ? Icons.check_circle_rounded
                              : (_sisaMakananPercentage < 50.0
                                  ? Icons.info_rounded
                                  : Icons.warning_rounded),
                          size: 18,
                          color: _getWasteColor(_sisaMakananPercentage),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Status: ${_getWasteLabel(_sisaMakananPercentage)}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: _getWasteColor(_sisaMakananPercentage),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Pertanyaan 5: Masukan Kualitatif
            CustomTextField(
              label: '5. Saran & Catatan Kualitatif',
              hint: 'Tuliskan masukan untuk perbaikan menu...',
              controller: _commentController,
              maxLines: 2,
            ),
            const SizedBox(height: 20),

            CustomButton(
              text: 'Kirim Evaluasi Menu Hari Ini',
              prefixIcon:
                  const Icon(Icons.send_rounded, size: 18, color: Colors.white),
              isLoading: _isSubmitting,
              onPressed: _showPreSubmitConfirmationDialog,
            ),
          ],
        ],
      ),
    );
  }
}
