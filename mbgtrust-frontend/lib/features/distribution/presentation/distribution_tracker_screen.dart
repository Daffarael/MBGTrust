import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pelacak Distribusi SPPG'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Realtime Delivery Info Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
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
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Armada 01 • SPPG Jakpus',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _currentStep == 3
                                    ? AppColors.primary
                                    : AppColors.secondary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                currentStatusTitle,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'SDN 01 Merdeka Jakarta',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Total Porsi: 350 Paket Makanan Gizi Gratis',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Progress Indicator Bar
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: progressRatio,
                                  minHeight: 8,
                                  backgroundColor: AppColors.background,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          AppColors.primary),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${(progressRatio * 100).toInt()}%',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1, color: AppColors.border),
                        const SizedBox(height: 14),

                        // Driver Details
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.primaryLight,
                              child: Icon(Icons.person_rounded,
                                  size: 20, color: AppColors.primary),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pak Hartono (Pengemudi)',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    'Mobil Box Thermo - B 1234 SPG',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.phone_in_talk_rounded,
                                  color: AppColors.primary),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Menghubungi Pak Hartono...'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Linear Flow Stepper
                  const Text(
                    'Alur Status Operasional:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

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
                          // Left Icon & Vertical Connector Line
                          Column(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isDone
                                      ? AppColors.primary
                                      : AppColors.background,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isDone
                                        ? AppColors.primary
                                        : AppColors.border,
                                    width: 2,
                                  ),
                                  boxShadow: isCurrent
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primary
                                                .withValues(alpha: 0.4),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Icon(
                                  step['icon'] as IconData,
                                  size: 20,
                                  color: isDone
                                      ? Colors.white
                                      : AppColors.textLight,
                                ),
                              ),
                              if (!isLast)
                                Container(
                                  width: 3,
                                  height: 50,
                                  color: index < _currentStep
                                      ? AppColors.primary
                                      : AppColors.border,
                                ),
                            ],
                          ),
                          const SizedBox(width: 16),

                          // Right Detail Content
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        step['title'] as String,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: isCurrent
                                              ? FontWeight.bold
                                              : (isDone
                                                  ? FontWeight.w600
                                                  : FontWeight.normal),
                                          color: isDone
                                              ? AppColors.textPrimary
                                              : AppColors.textLight,
                                        ),
                                      ),
                                      Text(
                                        step['time'] as String,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: isCurrent
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: isCurrent
                                              ? AppColors.primary
                                              : AppColors.textLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    step['subtitle'] as String,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDone
                                          ? AppColors.textSecondary
                                          : AppColors.textLight,
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

          // Bottom Bar Status Changer Controls for SPPG Admin
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
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
                          ? 'Perbarui Status Selanjutnya'
                          : 'Distribusi Selesai (Tiba)',
                      prefixIcon: Icon(
                        _currentStep < _statusSteps.length - 1
                            ? Icons.arrow_forward_rounded
                            : Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 20,
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
          ),
        ],
      ),
    );
  }
}
