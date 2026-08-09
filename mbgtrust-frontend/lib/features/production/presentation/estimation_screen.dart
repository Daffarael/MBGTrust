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

  @override
  void initState() {
    super.initState();
    _fetchEstimate();
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
          totalSiswaKonfirmasiHadir: 450,
          totalSiswaMenolak: 50,
          totalPorsiPresisiWajibDimasak: 450,
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

  List<PieChartSectionData> _showingSections(int confirmed, int rejected) {
    return List.generate(2, (i) {
      final isTouched = i == _touchedIndex;
      final fontSize = isTouched ? 16.0 : 13.0;
      final radius = isTouched ? 55.0 : 45.0;

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
        default:
          throw Error();
      }
    });
  }

  String _formatTodayDate() {
    final date = DateTime.now();
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
    return '${days[date.weekday % 7]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final plan = _plan ??
        ProductionPlanModel(
          tanggalTarget: '2026-08-08',
          totalPorsiDasar: 500,
          totalSiswaKonfirmasiHadir: 450,
          totalSiswaMenolak: 50,
          totalPorsiPresisiWajibDimasak: 450,
        );

    final confirmed = plan.totalSiswaKonfirmasiHadir;
    final rejected = plan.totalSiswaMenolak;
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
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // =======================================================
                      // 1. BANNER UTAMA OPERASIONAL DAPUR HARI INI
                      // =======================================================
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
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
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.restaurant_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Menu Makanan Hari Ini (${_formatTodayDate()})',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        'Nasi Daging Sapi Lada Hitam & Capcay',
                                        softWrap: true,
                                        maxLines: 2,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          height: 1.25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            const Divider(color: Colors.white24, height: 1),
                            const SizedBox(height: 12),

                            // Target Memasak Presisi Dapur
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Target Memasak Presisi Dapur:',
                                  style: TextStyle(
                                      fontSize: 11.5, color: Colors.white70),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$precisionPortions Porsi Wajib Dimasak',
                                  softWrap: true,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // =======================================================
                      // 2. 4 STAT CARDS ANALITIK UTAMA
                      // =======================================================
                      const Text(
                        'Ringkasan Kinerja Dapur Hari Ini',
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              title: 'Kepuasan Siswa',
                              valueText: '4.8 ⭐',
                              subtitle: '1.240 Ulasan',
                              icon: Icons.star_rounded,
                              color: AppColors.secondaryDark,
                              bgColor: AppColors.secondaryLight,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              title: 'Penerimaan Presisi',
                              valueText: '95.2%',
                              subtitle: '$confirmed Konfirmasi Hadir',
                              icon: Icons.check_circle_rounded,
                              color: AppColors.success,
                              bgColor: AppColors.primaryLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
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
                          const SizedBox(width: 12),
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
                      const SizedBox(height: 24),

                      // =======================================================
                      // 3. DIAGRAM PRESISI PORSI & ALASAN PENOLAKAN SISWA
                      // =======================================================
                      const Text(
                        'Diagram Konfirmasi Presensi Siswa',
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 180,
                              child: PieChart(
                                PieChartData(
                                  pieTouchData: PieTouchData(
                                    touchCallback: (FlTouchEvent event,
                                        pieTouchResponse) {
                                      setState(() {
                                        if (!event.isInterestedForInteractions ||
                                            pieTouchResponse == null ||
                                            pieTouchResponse.touchedSection ==
                                                null) {
                                          _touchedIndex = -1;
                                          return;
                                        }
                                        _touchedIndex = pieTouchResponse
                                            .touchedSection!.touchedSectionIndex;
                                      });
                                    },
                                  ),
                                  borderData: FlBorderData(show: false),
                                  sectionsSpace: 4,
                                  centerSpaceRadius: 45,
                                  sections:
                                      _showingSections(confirmed, rejected),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _ChartLegendTile(
                                  color: AppColors.primary,
                                  label: 'Dimasak ($confirmed Porsi)',
                                ),
                                _ChartLegendTile(
                                  color: AppColors.error,
                                  label: 'Dibatalkan ($rejected Porsi)',
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Rincian Alasan Penolakan Siswa
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Rincian Alasan Penolakan Siswa (50 Porsi):',
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text('• 30 Siswa: Sakit / Tidak Masuk Sekolah',
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.secondaryDark)),
                                  Text('• 10 Siswa: Alergi Makanan (Kacang / Udang)',
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textSecondary)),
                                  Text('• 10 Siswa: Izin / Kegiatan Luar Sekolah',
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // =======================================================
                      // 4. AKSI PINTAS NAVIGASI OPERASIONAL SPPG
                      // =======================================================
                      const Text(
                        'Aksi Pintas Pengelola SPPG',
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      CustomButton(
                        text: '📅 Jadwal Menu Harian',
                        prefixIcon: const Icon(Icons.edit_calendar_rounded,
                            color: Colors.white, size: 20),
                        onPressed: () => context.push('/create-schedule'),
                      ),
                      const SizedBox(height: 10),

                      CustomButton(
                        text: '⭐ Rekomendasi Menu Terfavorit',
                        isOutlined: true,
                        borderColor: AppColors.primary,
                        prefixIcon: const Icon(Icons.auto_awesome_rounded,
                            color: AppColors.primary, size: 20),
                        onPressed: () => context.push('/sppg/topsis-spk-engine'),
                      ),
                      const SizedBox(height: 10),

                      CustomButton(
                        text: '🍱 Katalog Menu Makanan',
                        isOutlined: true,
                        borderColor: AppColors.secondaryDark,
                        prefixIcon: const Icon(Icons.restaurant_menu_rounded,
                            color: AppColors.secondaryDark, size: 20),
                        onPressed: () => context.push('/manage-menu'),
                      ),
                      const SizedBox(height: 10),

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

  Widget _buildStatCard({
    required String title,
    required String valueText,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Flexible(
                child: Text(
                  valueText,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            softWrap: true,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            softWrap: true,
            style: const TextStyle(
              fontSize: 10.5,
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
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            softWrap: true,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
