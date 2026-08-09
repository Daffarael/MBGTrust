import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';
import '../../production/presentation/widgets/sppg_admin_layout.dart';

class DistributionTrackerScreen extends StatefulWidget {
  const DistributionTrackerScreen({super.key});

  @override
  State<DistributionTrackerScreen> createState() =>
      _DistributionTrackerScreenState();
}

class _DistributionTrackerScreenState
    extends State<DistributionTrackerScreen> {
  int _currentStep = 2; // Default: Sedang Dikirim

  final List<Map<String, dynamic>> _statusSteps = [
    {
      'title': 'Dalam Persiapan',
      'subtitle': 'Pemeriksaan bahan baku & kebersihan dapur SPPG',
      'time': '05:30 WIB',
      'icon': Icons.inventory_rounded,
    },
    {
      'title': 'Sedang Dimasak',
      'subtitle': 'Memasak gizi seimbang & pengemasan higienis',
      'time': '07:15 WIB',
      'icon': Icons.soup_kitchen_rounded,
    },
    {
      'title': 'Sedang Dikirim',
      'subtitle': 'Kurir Armada 01 sedang menuju lokasi sekolah',
      'time': '09:00 WIB',
      'icon': Icons.local_shipping_rounded,
    },
    {
      'title': 'Tiba di Tujuan',
      'subtitle': 'Makanan diterima oleh pihak sekolah & disajikan',
      'time': '09:35 WIB (Estimasi)',
      'icon': Icons.task_alt_rounded,
    },
  ];

  void _nextStep() {
    if (_currentStep < _statusSteps.length - 1) {
      setState(() {
        _currentStep++;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Status diperbarui: ${_statusSteps[_currentStep]['title']}'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Status dikembalikan ke: ${_statusSteps[_currentStep]['title']}'),
          backgroundColor: AppColors.secondaryDark,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStatusTitle = _statusSteps[_currentStep]['title'];
    final progressRatio = (_currentStep + 1) / _statusSteps.length;

    return SppgAdminLayout(
      currentRoute: '/distribution-tracker',
      title: 'Status Pengiriman',
      subtitle: 'Pemantauan Pengiriman Makanan ke Sekolah',
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Realtime Delivery Info Card
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Pengiriman #MBG-20260808-01',
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    currentStatusTitle as String,
                                    softWrap: true,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Target: MAN 2 Kota Padang',
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Kurir: Ahmad Supriadi (Armada Box Hino #04)',
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Progress Bar Indicator
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Progres Pengiriman:',
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      '${(progressRatio * 100).round()}%',
                                      softWrap: true,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                    value: progressRatio,
                                    minHeight: 8,
                                    backgroundColor: AppColors.border,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            AppColors.primary),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        'Timeline Status Pengiriman Dapur:',
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Stepper List View (TEKS DIBACA UTUH 100%)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _statusSteps.length,
                        itemBuilder: (context, index) {
                          final step = _statusSteps[index];
                          final isDone = index <= _currentStep;
                          final isCurrent = index == _currentStep;
                          final isLast = index == _statusSteps.length - 1;

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Timeline Node Indicator
                              Column(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: isDone
                                          ? (isCurrent
                                              ? AppColors.primary
                                              : AppColors.primaryDark)
                                          : AppColors.border,
                                      shape: BoxShape.circle,
                                      boxShadow: isCurrent
                                          ? [
                                              BoxShadow(
                                                color: AppColors.primary
                                                    .withValues(alpha: 0.35),
                                                blurRadius: 8,
                                                spreadRadius: 2,
                                              )
                                            ]
                                          : [],
                                    ),
                                    child: Icon(
                                      step['icon'] as IconData,
                                      color: isDone
                                          ? Colors.white
                                          : AppColors.textLight,
                                      size: 18,
                                    ),
                                  ),
                                  if (!isLast)
                                    Container(
                                      width: 2,
                                      height: 48,
                                      color: isDone
                                          ? AppColors.primary
                                          : AppColors.border,
                                    ),
                                ],
                              ),
                              const SizedBox(width: 14),

                              // Timeline Step Card Content
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: isCurrent
                                        ? AppColors.primaryLight
                                        : AppColors.surface,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: isCurrent
                                          ? AppColors.primary
                                          : AppColors.border,
                                      width: isCurrent ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              step['title'] as String,
                                              softWrap: true,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: isCurrent
                                                    ? AppColors.primaryDark
                                                    : (isDone
                                                        ? AppColors.textPrimary
                                                        : AppColors.textLight),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            step['time'] as String,
                                            softWrap: true,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: isCurrent
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              color: isCurrent
                                                  ? AppColors.primaryDark
                                                  : AppColors.textLight,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        step['subtitle'] as String,
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isCurrent
                                              ? AppColors.textPrimary
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Action Bar to Advance Status
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    if (_currentStep > 0) ...[
                      Expanded(
                        flex: 1,
                        child: CustomButton(
                          text: 'Mundur',
                          isOutlined: true,
                          borderColor: AppColors.textSecondary,
                          textColor: AppColors.textSecondary,
                          onPressed: _previousStep,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      flex: 2,
                      child: CustomButton(
                        text: _currentStep < _statusSteps.length - 1
                            ? 'Perbarui Status'
                            : 'Distribusi Selesai',
                        prefixIcon: Icon(
                          _currentStep < _statusSteps.length - 1
                              ? Icons.arrow_forward_rounded
                              : Icons.check_circle_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        backgroundColor: _currentStep == _statusSteps.length - 1
                            ? AppColors.success
                            : AppColors.primary,
                        onPressed: _currentStep < _statusSteps.length - 1
                            ? _nextStep
                            : () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Seluruh alur pengiriman telah selesai dikonfirmasi!'),
                                    backgroundColor: AppColors.success,
                                  ),
                                );
                              },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
