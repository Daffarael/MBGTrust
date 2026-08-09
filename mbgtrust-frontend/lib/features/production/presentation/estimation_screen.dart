import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../data/models/production_plan_model.dart';
import '../data/repositories/production_repository.dart';
import 'widgets/sppg_admin_layout.dart';

class EstimationScreen extends StatefulWidget {
  const EstimationScreen({super.key});

  @override
  State<EstimationScreen> createState() => _EstimationScreenState();
}

class _EstimationScreenState extends State<EstimationScreen> {
  final ProductionRepository _productionRepository = ProductionRepository();
  ProductionPlanModel? _plan;
  bool _isLoading = true;
  int _touchedIndex = -1;

  // Active Tab: 'KONFIRMASI' (Pra-Distribusi Pagi) or 'ULASAN' (Pasca-Distribusi Siang)
  String _activeDashboardTab = 'KONFIRMASI';

  Timer? _clockTimer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchEstimate();
    _startClockTimer();
  }

  void _startClockTimer() {
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchEstimate() async {
    setState(() => _isLoading = true);
    try {
      final plan = await _productionRepository.getDailyProductionPlan(
          '2026-08-08');
      setState(() {
        _plan = plan;
        _isLoading = false;
      });
    } catch (_) {
      // Fallback mock model if API error
      setState(() {
        _plan = ProductionPlanModel(
          tanggalTarget: '2026-08-08',
          totalPorsiDasar: 500,
          totalSiswaKonfirmasiHadir: 420,
          totalSiswaMenolak: 50,
          totalPorsiPresisiWajibDimasak: 420,
        );
        _isLoading = false;
      });
    }
  }

  void _recalculateEstimate() {
    _fetchEstimate();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Presisi porsi harian berhasil diperbarui!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  List<PieChartSectionData> _showingConfirmationSections(
      int confirmed, int rejected, int pending) {
    return List.generate(3, (i) {
      final isTouched = i == _touchedIndex;
      final fontSize = isTouched ? 15.0 : 12.0;
      final radius = isTouched ? 54.0 : 46.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: AppColors.primary,
            value: confirmed.toDouble(),
            title: '$confirmed',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: AppColors.error,
            value: rejected.toDouble(),
            title: '$rejected',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.amber.shade800,
            value: pending.toDouble(),
            title: '$pending',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        default:
          throw Error();
      }
    });
  }

  List<PieChartSectionData> _showingSatisfactionSections() {
    return List.generate(2, (i) {
      final isTouched = i == _touchedIndex;
      final fontSize = isTouched ? 15.0 : 12.0;
      final radius = isTouched ? 54.0 : 46.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: AppColors.primary,
            value: 96.5,
            title: '96.5%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.amber.shade700,
            value: 3.5,
            title: '3.5%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        default:
          throw Error();
      }
    });
  }

  String _formatLiveDateTime() {
    const days = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu'
    ];
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    final dayName = days[_now.weekday % 7];
    final dayNum = _now.day;
    final monthName = months[_now.month - 1];
    final year = _now.year;
    final hour = _now.hour.toString().padLeft(2, '0');
    final minute = _now.minute.toString().padLeft(2, '0');
    final second = _now.second.toString().padLeft(2, '0');

    return '$dayName, $dayNum $monthName $year • $hour:$minute:$second WIB';
  }

  @override
  Widget build(BuildContext context) {
    final plan = _plan ??
        ProductionPlanModel(
          tanggalTarget: '2026-08-08',
          totalPorsiDasar: 500,
          totalSiswaKonfirmasiHadir: 420,
          totalSiswaMenolak: 50,
          totalPorsiPresisiWajibDimasak: 420,
        );

    final confirmed = plan.totalSiswaKonfirmasiHadir; // 420 Mau/Hadir
    final rejected = plan.totalSiswaMenolak; // 50 Membatalkan
    const pending = 30; // 30 Belum Konfirmasi (Total 500 Sasaran)
    final precisionPortions = plan.totalPorsiPresisiWajibDimasak;

    return SppgAdminLayout(
      currentRoute: '/estimation',
      title: 'Dasbor Utama',
      subtitle: 'Ringkasan Target Porsi & Dapur',
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
          tooltip: 'Hitung Ulang Presisi Porsi',
          onPressed: _recalculateEstimate,
        ),
      ],
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 720),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // =======================================================
                      // 1. BANNER UTAMA OPERASIONAL DAPUR HARI INI (LIVE CLOCK)
                      // =======================================================
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryDark],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // LIVE REAL-TIME CLOCK (HARI, TANGGAL, & JAM BERGERAK)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.access_time_filled_rounded,
                                      color: Colors.white, size: 13),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      _formatLiveDateTime(),
                                      softWrap: true,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),

                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.restaurant_rounded,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Menu Makanan Hari Ini',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Nasi Daging Sapi Lada Hitam & Capcay',
                                        softWrap: true,
                                        maxLines: 2,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          height: 1.25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Divider(color: Colors.white24, height: 1),
                            const SizedBox(height: 10),

                            // Target Memasak Presisi Dapur
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Target Memasak Presisi Dapur:',
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.white70),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$precisionPortions Porsi Wajib Dimasak',
                                  softWrap: true,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // =======================================================
                      // 2. DUA TOMBOL SAKELAR SEGMENTED (STATUS VS ULASAN)
                      // =======================================================
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            // Tombol Kiri: Status Konfirmasi
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _activeDashboardTab = 'KONFIRMASI';
                                  });
                                },
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 9),
                                  decoration: BoxDecoration(
                                    color: _activeDashboardTab == 'KONFIRMASI'
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.how_to_reg_rounded,
                                        size: 15,
                                        color:
                                            _activeDashboardTab == 'KONFIRMASI'
                                                ? Colors.white
                                                : AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 5),
                                      Flexible(
                                        child: Text(
                                          'Konfirmasi',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.bold,
                                            color: _activeDashboardTab ==
                                                    'KONFIRMASI'
                                                ? Colors.white
                                                : AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),

                            // Tombol Kanan: Ulasan & Kepuasan
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _activeDashboardTab = 'ULASAN';
                                  });
                                },
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 9),
                                  decoration: BoxDecoration(
                                    color: _activeDashboardTab == 'ULASAN'
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.star_rounded,
                                        size: 15,
                                        color: _activeDashboardTab == 'ULASAN'
                                            ? Colors.white
                                            : AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 5),
                                      Flexible(
                                        child: Text(
                                          'Ulasan',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.bold,
                                            color: _activeDashboardTab == 'ULASAN'
                                                ? Colors.white
                                                : AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // =======================================================
                      // 3. KARTU DIAGRAM DINAMIS BERBASIS TAB SAKELAR
                      // =======================================================
                      _activeDashboardTab == 'KONFIRMASI'
                          ? _buildConfirmationDiagramCard(
                              confirmed, rejected, pending)
                          : _buildSatisfactionDiagramCard(),

                      const SizedBox(height: 18),

                      // =======================================================
                      // 4. 4 STAT CARDS ANALITIK UTAMA
                      // =======================================================
                      const Text(
                        'Ringkasan Kinerja Dapur Hari Ini',
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              title: 'Kepuasan Siswa',
                              valueText: '4.9 ⭐',
                              subtitle: '410 Ulasan Siswa',
                              icon: Icons.star_rounded,
                              color: AppColors.secondaryDark,
                              bgColor: AppColors.secondaryLight,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildStatCard(
                              title: 'Penerimaan Presisi',
                              valueText: '84.0%',
                              subtitle: '$confirmed Konfirmasi Hadir',
                              icon: Icons.check_circle_rounded,
                              color: AppColors.success,
                              bgColor: AppColors.primaryLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              title: 'Sisa Makanan',
                              valueText: '0%',
                              subtitle: '$rejected Porsi Tercegah',
                              icon: Icons.cleaning_services_rounded,
                              color: AppColors.primary,
                              bgColor: AppColors.primaryLight,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildStatCard(
                              title: 'Efisiensi Anggaran',
                              valueText: 'Rp 750k',
                              subtitle: 'Penghematan Harian',
                              icon: Icons.savings_rounded,
                              color: Colors.blue,
                              bgColor: Colors.blueAccent.withValues(alpha: 0.1),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // =======================================================
                      // 5. AKSI PINTAS NAVIGASI OPERASIONAL SPPG
                      // =======================================================
                      const Text(
                        'Aksi Pintas Pengelola SPPG',
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),

                      CustomButton(
                        text: '📅 Jadwal Menu Harian',
                        prefixIcon: const Icon(Icons.edit_calendar_rounded,
                            color: Colors.white, size: 20),
                        onPressed: () => context.push('/create-schedule'),
                      ),
                      const SizedBox(height: 8),

                      CustomButton(
                        text: '⭐ Rekomendasi Menu Terfavorit',
                        isOutlined: true,
                        borderColor: AppColors.primary,
                        prefixIcon: const Icon(Icons.auto_awesome_rounded,
                            color: AppColors.primary, size: 20),
                        onPressed: () => context.push('/sppg/topsis-spk-engine'),
                      ),
                      const SizedBox(height: 8),

                      CustomButton(
                        text: '🍱 Katalog Menu Makanan',
                        isOutlined: true,
                        borderColor: AppColors.secondaryDark,
                        prefixIcon: const Icon(Icons.restaurant_menu_rounded,
                            color: AppColors.secondaryDark, size: 20),
                        onPressed: () => context.push('/manage-menu'),
                      ),
                      const SizedBox(height: 8),

                      CustomButton(
                        text: '🚚 Status Pengiriman Makanan',
                        isOutlined: true,
                        borderColor: AppColors.primaryDark,
                        prefixIcon: const Icon(Icons.local_shipping_rounded,
                            color: AppColors.primaryDark, size: 20),
                        onPressed: () => context.push('/distribution-tracker'),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  /// Widget Tampilan Card Mode 1: Status Konfirmasi Presensi Siswa
  Widget _buildConfirmationDiagramCard(
      int confirmed, int rejected, int pending) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
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
          Row(
            children: const [
              Icon(Icons.pie_chart_rounded,
                  color: AppColors.primary, size: 18),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Konfirmasi Presensi Siswa',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // PIE CHART RINGKAS (HEIGHT 160px)
          SizedBox(
            height: 160,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        _touchedIndex = -1;
                        return;
                      }
                      _touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 4,
                centerSpaceRadius: 40,
                sections: _showingConfirmationSections(
                    confirmed, rejected, pending),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // 3 LEGENDA KATEGORI (WRAP BEBAS OVERFLOW)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              _ChartLegendTile(
                color: AppColors.primary,
                label: 'Konfirmasi Hadir ($confirmed)',
              ),
              _ChartLegendTile(
                color: AppColors.error,
                label: 'Membatalkan ($rejected)',
              ),
              _ChartLegendTile(
                color: Colors.amber.shade800,
                label: 'Belum Konfirmasi ($pending)',
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Rincian Alasan Membatalkan Porsi
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Rincian Alasan Membatalkan Porsi (50 Siswa):',
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text('• 30 Siswa: Sakit / Tidak Masuk Sekolah',
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 10.5, color: AppColors.secondaryDark)),
                Text('• 10 Siswa: Alergi Makanan (Kacang / Udang)',
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 10.5, color: AppColors.textSecondary)),
                Text('• 10 Siswa: Izin / Kegiatan Luar Sekolah',
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 10.5, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Widget Tampilan Card Mode 2: Ulasan & Kepuasan Siswa (Pasca Pengiriman)
  Widget _buildSatisfactionDiagramCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
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
          Row(
            children: [
              const Icon(Icons.stars_rounded,
                  color: AppColors.secondaryDark, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: const Text(
                  'Kepuasan Siswa',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'TERDISTRIBUSI',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // PIE CHART ULASAN (HEIGHT 160px)
          SizedBox(
            height: 160,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        _touchedIndex = -1;
                        return;
                      }
                      _touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 4,
                centerSpaceRadius: 40,
                sections: _showingSatisfactionSections(),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // LEGENDA ULASAN
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            children: const [
              _ChartLegendTile(
                color: AppColors.primary,
                label: 'Suka (96.5%)',
              ),
              _ChartLegendTile(
                color: Colors.amber,
                label: 'Evaluasi (3.5%)',
              ),
            ],
          ),
          const SizedBox(height: 14),

          // DETIL STATISTIK SURVEI PASCA DISTRIBUSI (FLEXIBLE BEBAS OVERFLOW)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSubMetric('Rasa', '4.9 ⭐'),
                    _buildSubMetric('Porsi', '4.8 ⭐'),
                    _buildSubMetric('Kepuasan', '96.5%'),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(height: 1),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.assignment_turned_in_rounded,
                        size: 14, color: AppColors.primary),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '410 / 420 siswa sudah mengulas',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
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
    );
  }

  Widget _buildSubMetric(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String valueText,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              Flexible(
                child: Text(
                  valueText,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            softWrap: true,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            softWrap: true,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartLegendTile extends StatelessWidget {
  final Color color;
  final String label;

  const _ChartLegendTile({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            label,
            softWrap: true,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
