import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mbgtrust/core/theme/app_colors.dart';
import 'package:mbgtrust/features/5_menu_production/production/presentation/widgets/sppg_admin_layout.dart';

class SppgDashboardScreen extends StatefulWidget {
  const SppgDashboardScreen({super.key});

  @override
  State<SppgDashboardScreen> createState() => _SppgDashboardScreenState();
}

class _SppgDashboardScreenState extends State<SppgDashboardScreen> {
  Timer? _clockTimer;
  String _timeString = '';
  String _dateString = '';

  @override
  void initState() {
    super.initState();
    _updateClock();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _updateClock();
      }
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  void _updateClock() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');

    const days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];

    final dayName = days[now.weekday - 1];
    final monthName = months[now.month - 1];

    setState(() {
      _timeString = '$hour:$minute:$second WIB';
      _dateString = '$dayName, ${now.day} $monthName ${now.year}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SppgAdminLayout(
      currentRoute: '/sppg/dashboard',
      title: 'Dasbor Utama',
      subtitle: 'Ringkasan Real-Time Food Waste & Status Operasional',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =========================================================
                // 1. TOP HEADER BANNER (MIRIP STYLE BERANDA ROLE SISWA)
                // =========================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryDark, AppColors.primary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Info Row (Avatar + Nama + Unit Dapur)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const CircleAvatar(
                              radius: 22,
                              backgroundColor: AppColors.primaryLight,
                              child: Icon(Icons.soup_kitchen_rounded, color: AppColors.primaryDark, size: 26),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Pengelola SPPG',
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Unit Dapur 01 • SPPG BGN RI',
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Jam, Hari, Tanggal Live WIB Pill (Mirip Student Header)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.access_time_filled_rounded, color: AppColors.secondaryLight, size: 16),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                '$_dateString • $_timeString',
                                softWrap: true,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      const Text(
                        'Platform Digital MBGTrust — Fokus 100% Mitigasi Food Waste pada Program Makan Bergizi Gratis melalui Integrasi ML NLP Sentiment Analysis & Engine SPK TOPSIS.',
                        softWrap: true,
                        style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // =========================================================
                // 2. METRIK KPI RINGKASAN MITIGASI FOOD WASTE (LANGSUNG INDIKATOR)
                // =========================================================
                Row(
                  children: const [
                    Icon(Icons.analytics_rounded, color: AppColors.primary, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Indikator Utama Mitigasi Food Waste',
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 600;
                    return GridView.count(
                      crossAxisCount: isMobile ? 2 : 4,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: isMobile ? 1.25 : 1.4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: [
                        _buildKpiCard(
                          title: 'Kepuasan Ulasan',
                          value: '4.82 / 5.0',
                          subtitle: '92.4% Sentimen Positif',
                          icon: Icons.star_rounded,
                          color: AppColors.secondary,
                        ),
                        _buildKpiCard(
                          title: 'Target Porsi Mingguan',
                          value: '450 Porsi / Hari',
                          subtitle: 'Statis Rencana Mingguan',
                          icon: Icons.restaurant_rounded,
                          color: AppColors.primary,
                        ),
                        _buildKpiCard(
                          title: 'Food Waste Tercegah',
                          value: '142.5 kg',
                          subtitle: 'Mitigasi Sisa Makanan',
                          icon: Icons.eco_rounded,
                          color: const Color(0xFF10B981),
                        ),
                        _buildKpiCard(
                          title: 'Akurasi Model SPK',
                          value: '96.8%',
                          subtitle: 'Optimalisasi TOPSIS',
                          icon: Icons.insights_rounded,
                          color: const Color(0xFF0284C7),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 28),

                // =========================================================
                // 3. PINTASAN MODUL OPERASIONAL (1:1 DENGAN NAVIGASI SIDEBAR)
                // =========================================================
                Row(
                  children: const [
                    Icon(Icons.grid_view_rounded, color: AppColors.primary, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Modul Operasional Admin SPPG',
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildNavTile(
                      icon: Icons.auto_awesome_rounded,
                      iconColor: AppColors.secondaryDark,
                      title: 'Rekomendasi AI',
                      subtitle: 'Perankingan 5 kriteria benefit, analisis sentimen NLP ulasan siswa, & saran AI',
                      onTap: () => context.push('/sppg/topsis-spk-engine'),
                    ),
                    _buildNavTile(
                      icon: Icons.edit_calendar_rounded,
                      iconColor: AppColors.primary,
                      title: 'Jadwal Mingguan',
                      subtitle: 'Perencanaan menu Senin–Jumat (diisi hari Jumat untuk pengadaan bahan baku)',
                      onTap: () => context.push('/create-schedule'),
                    ),
                    _buildNavTile(
                      icon: Icons.flatware_rounded,
                      iconColor: const Color(0xFFD97706),
                      title: 'Bahan Baku',
                      subtitle: 'Master data bahan baku makanan segar, status ketersediaan stok, & nutrisi',
                      onTap: () => context.push('/manage-ingredients'),
                    ),
                    _buildNavTile(
                      icon: Icons.restaurant_menu_rounded,
                      iconColor: const Color(0xFF059669),
                      title: 'Katalog Menu',
                      subtitle: 'Master racikan resep menu MBG, komposisi makronutrisi, & identifikasi alergen',
                      onTap: () => context.push('/manage-menu'),
                    ),
                    _buildNavTile(
                      icon: Icons.local_shipping_rounded,
                      iconColor: const Color(0xFF2563EB),
                      title: 'Tracking Distribusi',
                      subtitle: 'Pelacakan armada kurir pengiriman makanan ke sekolah mitra secara real-time',
                      onTap: () => context.push('/distribution-tracker'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            softWrap: true,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            softWrap: true,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          softWrap: true,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          softWrap: true,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
      ),
    );
  }
}
