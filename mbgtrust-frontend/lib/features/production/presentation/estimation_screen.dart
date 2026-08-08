import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';
import '../data/models/production_plan_model.dart';
import '../data/repositories/production_repository.dart';
import 'widgets/sppg_admin_layout.dart';

class EstimationScreen extends StatefulWidget {
  const EstimationScreen({super.key});

  @override
  State<EstimationScreen> createState() => _EstimationScreenState();
}

class _EstimationScreenState extends State<EstimationScreen> {
  late ProductionRepository _repository;
  bool _isLoading = true;
  ProductionPlanModel? _plan;
  int _touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _repository = ProductionRepository();
    _fetchProductionPlan();
  }

  Future<void> _fetchProductionPlan() async {
    setState(() => _isLoading = true);
    try {
      final plan = await _repository.getDailyProductionPlan('2026-08-08');
      if (mounted) {
        setState(() {
          _plan = plan;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
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
  }

  Future<void> _recalculateEstimate() async {
    setState(() => _isLoading = true);
    try {
      final newEstimate =
          await _repository.recalculateProductionEstimate('2026-08-08');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Hitung ulang estimasi presisi selesai! Porsi presisi: $newEstimate'),
            backgroundColor: AppColors.success,
          ),
        );
        _fetchProductionPlan();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hitung ulang gagal: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _showTopsisDetailModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        constraints: const BoxConstraints(maxWidth: 640),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      '🧮 Detail Matriks SPK TOPSIS',
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 10),
              const Text(
                'Bobot Kriteria Penilaian (Wj):',
                softWrap: true,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 6),
              const Text(
                '• C1 Rasa (30%) • C2 Kesukaan (25%) • C3 Porsi (20%) • C4 Sisa Makanan (25%)',
                softWrap: true,
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              const Text(
                'Matriks Terbobot & Jarak Solusi Ideal (D+, D-):',
                softWrap: true,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),
              _buildTopsisRow('1. Nasi Ayam Bakar Kecap', 'V = 0.892', 'D+ = 0.012', 'D- = 0.098', AppColors.primary),
              _buildTopsisRow('2. Nasi Semur Daging Sapi', 'V = 0.765', 'D+ = 0.024', 'D- = 0.078', AppColors.primary),
              _buildTopsisRow('3. Nasi Ikan Goreng Tepung', 'V = 0.312', 'D+ = 0.088', 'D- = 0.021', AppColors.error),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Tutup Detail TOPSIS',
                onPressed: () => Navigator.pop(ctx),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildTopsisRow(String menuName, String vScore, String dPlus, String dMinus, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(menuName, softWrap: true, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                Text('$dPlus | $dMinus', softWrap: true, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(vScore, softWrap: true, style: TextStyle(fontWeight: FontWeight.bold, color: statusColor, fontSize: 13)),
        ],
      ),
    );
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
      title: 'Dasbor & Presisi H+1',
      subtitle: 'SPPG Unit Dapur Kota Padang 01',
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
                      // Header Banner
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
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.soup_kitchen_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Dapur SPPG Unit Kota Padang 01',
                                    softWrap: true,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Target Wajib Dimasak: $precisionPortions Porsi Presisi H+1',
                                    softWrap: true,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 4 Stat Cards Analitik Utama
                      const Text(
                        'Ringkasan Analitik Eksekutif',
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
                              value: '4.8 ⭐',
                              subtitle: '1.240 Ulasan',
                              icon: Icons.star_rounded,
                              color: AppColors.secondaryDark,
                              bgColor: AppColors.secondaryLight,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              title: 'Penerimaan Porsi',
                              value: '95.2%',
                              subtitle: 'Presisi Tinggi',
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
                              title: 'Food Waste H+1',
                              value: '0%',
                              subtitle: '50 Porsi Tercegah',
                              icon: Icons.cleaning_services_rounded,
                              color: AppColors.primary,
                              bgColor: AppColors.primaryLight,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              title: 'Hemat Anggaran',
                              value: 'Rp 750k',
                              subtitle: 'Efisiensi / Hari',
                              icon: Icons.savings_rounded,
                              color: Colors.blue,
                              bgColor: Colors.blueAccent.withValues(alpha: 0.1),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Section Presisi Porsi
                      Row(
                        children: const [
                          Expanded(
                            child: Text(
                              'Presisi Porsi Memasak H+1',
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
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

                            // Rincian Alasan Penolakan (TEKS DIBACA UTUH 100%)
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
                                  Text('• 30 Siswa: Alergi Makanan (Kacang / Udang)',
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.secondaryDark)),
                                  Text('• 10 Siswa: Sakit / Tidak Masuk Sekolah',
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
                      const SizedBox(height: 28),

                      // ==========================================
                      // ENGINE SPK TOPSIS EVALUASI MENU
                      // ==========================================
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              '🧮 Engine SPK TOPSIS Evaluasi Menu',
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _showTopsisDetailModal(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.primary),
                              ),
                              child: const Text(
                                'Detail Matriks',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hasil Ranking Preferensi Menu (Vi):',
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildTopsisRankCard(
                              rank: '🥇 Rank 1',
                              menuName: 'Nasi Ayam Bakar Kecap & Tumis Buncis',
                              score: 'V = 0.892',
                              badgeText: 'SANGAT DIREKOMENDASIKAN',
                              badgeColor: AppColors.primary,
                            ),
                            const SizedBox(height: 8),
                            _buildTopsisRankCard(
                              rank: '🥈 Rank 2',
                              menuName: 'Nasi Semur Daging Sapi & Sup Sayur',
                              score: 'V = 0.765',
                              badgeText: 'DIREKOMENDASIKAN',
                              badgeColor: AppColors.primaryDark,
                            ),
                            const SizedBox(height: 8),
                            _buildTopsisRankCard(
                              rank: '🥉 Rank 3',
                              menuName: 'Nasi Ikan Goreng Tepung & Sayur Lodeh',
                              score: 'V = 0.312',
                              badgeText: 'PERLU REVISI / GANTI MENU',
                              badgeColor: AppColors.error,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // NAVIGASI AKSI UTAMA SPPG
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
                        text: '🍱 Kelola Master Menu MBG',
                        prefixIcon: const Icon(Icons.restaurant_menu_rounded,
                            color: Colors.white, size: 20),
                        onPressed: () => context.push('/manage-menu'),
                      ),
                      const SizedBox(height: 10),

                      CustomButton(
                        text: '📅 Plotting Jadwal Menu Harian',
                        isOutlined: true,
                        borderColor: AppColors.secondaryDark,
                        prefixIcon: const Icon(Icons.edit_calendar_rounded,
                            color: AppColors.secondaryDark, size: 20),
                        onPressed: () => context.push('/create-schedule'),
                      ),
                      const SizedBox(height: 10),

                      CustomButton(
                        text: '🚚 Pelacak Logistik Distribusi',
                        isOutlined: true,
                        borderColor: AppColors.primary,
                        prefixIcon: const Icon(Icons.local_shipping_rounded,
                            color: AppColors.primary, size: 20),
                        onPressed: () => context.push('/distribution-tracker'),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildTopsisRankCard({
    required String rank,
    required String menuName,
    required String score,
    required String badgeText,
    required Color badgeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                rank,
                softWrap: true,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  badgeText,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  menuName,
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                score,
                softWrap: true,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: badgeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _showingSections(int confirmed, int rejected) {
    return List.generate(2, (i) {
      final isTouched = i == _touchedIndex;
      final fontSize = isTouched ? 16.0 : 12.0;
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

  Widget _buildStatCard({
    required String title,
    required String value,
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
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  value,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 17,
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
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            subtitle,
            softWrap: true,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textLight,
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
        Text(
          label,
          softWrap: true,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
