import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/responsive_layout.dart';

class SppgDashboardScreen extends StatelessWidget {
  const SppgDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Dashboard Operasional SPPG',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Wilayah DKI Jakarta • SPPG Utamani',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.error),
            onPressed: () => context.go('/login'),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Welcome Admin
            Container(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Ringkasan Hari Ini 🍱',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Chip(
                        label: Text('Status: Aktif', style: TextStyle(fontSize: 11, color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
                        backgroundColor: AppColors.primaryLight,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Program Makan Bergizi Gratis (MBG) — Mitigasi Food Waste & Analisis Presisi Nutrisi berbasis AI Gemini & TOPSIS Engine.',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Metrik KPI Ringkasan
            const Text(
              'Ringkasan Metrik KPI Operasional',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildKpiCard(
                  title: 'Kepuasan Menu',
                  value: '4.52 / 5.0',
                  subtitle: '91.4% Penerimaan Siswa',
                  icon: Icons.star_rounded,
                  color: AppColors.secondary,
                ),
                _buildKpiCard(
                  title: 'Porsi Presisi H+1',
                  value: '450 Porsi',
                  subtitle: '50 Menolak (Alergi/Izin)',
                  icon: Icons.restaurant_rounded,
                  color: AppColors.primary,
                ),
                _buildKpiCard(
                  title: 'Food Waste Tercegah',
                  value: '142.5 kg',
                  subtitle: 'Penghematan Emisi CO₂',
                  icon: Icons.eco_rounded,
                  color: const Color(0xFF10B981),
                ),
                _buildKpiCard(
                  title: 'Efisiensi Anggaran',
                  value: 'Rp 2.137.500',
                  subtitle: 'Estimasi Penghematan',
                  icon: Icons.account_balance_wallet_rounded,
                  color: const Color(0xFF0284C7),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Quick Access Nav Grid
            const Text(
              'Modul Analitik & Manajemen SPPG',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildNavTile(
                  icon: Icons.chat_bubble_outline_rounded,
                  iconColor: const Color(0xFF8B5CF6),
                  title: 'Dasbor Analitik Sentimen NLP',
                  subtitle: 'Hasil analisis ulasan teks siswa & kata kunci keluhan',
                  onTap: () => context.push('/sppg/analitik/nlp'),
                ),
                _buildNavTile(
                  icon: Icons.psychology_rounded,
                  iconColor: AppColors.primary,
                  title: 'Rekomendasi AI Gemini & Porsi',
                  subtitle: 'Saran penyesuaian porsi & rekomendasi status menu',
                  onTap: () => context.push('/sppg/analitik/rekomendasi'),
                ),
                _buildNavTile(
                  icon: Icons.insights_rounded,
                  iconColor: AppColors.secondaryDark,
                  title: 'SPK TOPSIS Engine (5 Kriteria Benefit)',
                  subtitle: 'Matriks keputusan & perankingan menu MBG',
                  onTap: () => context.push('/sppg/topsis-spk-engine'),
                ),
                _buildNavTile(
                  icon: Icons.show_chart_rounded,
                  iconColor: const Color(0xFF0284C7),
                  title: 'Tren Food Waste & Akurasi Prediksi',
                  subtitle: 'Grafik historis penurunan sisa makanan',
                  onTap: () => context.push('/sppg/analitik/tren'),
                ),
                _buildNavTile(
                  icon: Icons.kitchen_rounded,
                  iconColor: const Color(0xFFD97706),
                  title: 'Master Bahan Baku & Gizi',
                  subtitle: 'Katalog bahan baku sehat & harga per gram',
                  onTap: () => context.push('/manage-ingredients'),
                ),
                _buildNavTile(
                  icon: Icons.restaurant_menu_rounded,
                  iconColor: AppColors.primaryDark,
                  title: 'Master Menu MBG',
                  subtitle: 'Daftar resep menu, nilai gizi & alergen',
                  onTap: () => context.push('/manage-menu'),
                ),
                _buildNavTile(
                  icon: Icons.calculate_rounded,
                  iconColor: const Color(0xFFEC4899),
                  title: 'Kalkulasi Estimasi Produksi H+1',
                  subtitle: 'Hitung porsi presisi masak berdasarkan presensi',
                  onTap: () => context.push('/estimation'),
                ),
                _buildNavTile(
                  icon: Icons.local_shipping_rounded,
                  iconColor: const Color(0xFF2563EB),
                  title: 'Live Tracking Logistik Distribusi',
                  subtitle: 'Pantau status armada pengiriman ke sekolah',
                  onTap: () => context.push('/distribution-tracker'),
                ),
              ],
            ),
          ],
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
      padding: const EdgeInsets.all(14),
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
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
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
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
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
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
      ),
    );
  }
}
