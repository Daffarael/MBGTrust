import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class StudentBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const StudentBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    // 3 Slot Navigasi Tetap Siswa
    final List<Map<String, dynamic>> allItems = [
      {
        'id': 0,
        'route': '/home',
        'icon': Icons.home_rounded,
        'label': 'Beranda',
      },
      {
        'id': 1,
        'route': '/profil/gamifikasi',
        'icon': Icons.emoji_events_rounded,
        'label': 'Peringkat',
      },
      {
        'id': 2,
        'route': '/profile',
        'icon': Icons.person_rounded,
        'label': 'Profil',
      },
    ];

    // Hitung koordinat sumbu X untuk AnimatedAlign
    // Slot 0 (Beranda) = -1.0, Slot 1 (Peringkat) = 0.0, Slot 2 (Profil) = 1.0
    final double targetX =
        currentIndex == 0 ? -1.0 : (currentIndex == 1 ? 0.0 : 1.0);

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
        height: 72,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 24,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. Lingkaran Menonjol Aktif yang Meluncur secara Dinamis (AnimatedAlign Carousel)
            AnimatedAlign(
              duration: const Duration(milliseconds: 380),
              curve: Curves.easeOutBack,
              alignment: Alignment(targetX, -0.45),
              child: FractionallySizedBox(
                widthFactor: 1 / 3,
                child: Center(
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 14,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },
                      child: Icon(
                        allItems[currentIndex]['icon'] as IconData,
                        key: ValueKey('active_icon_$currentIndex'),
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 2. Tiga Slot Navigasi dengan Transisi Opacity & Skala
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(allItems.length, (index) {
                final item = allItems[index];
                final bool isActive = currentIndex == index;

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (!isActive) {
                        context.go(item['route'] as String);
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Ikon Non-Aktif (Menghilang halus saat lingkaran meluncur di atasnya)
                        SizedBox(
                          height: 44,
                          child: Center(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 250),
                              opacity: isActive ? 0.0 : 0.6,
                              child: AnimatedScale(
                                duration: const Duration(milliseconds: 250),
                                scale: isActive ? 0.6 : 0.9,
                                child: Icon(
                                  item['icon'] as IconData,
                                  color: AppColors.textSecondary,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Label teks menu dengan animasi perubahan warna & ketebalan font
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 250),
                            style: TextStyle(
                              color: isActive
                                  ? AppColors.primaryDark
                                  : AppColors.textLight,
                              fontSize: 11,
                              fontWeight:
                                  isActive ? FontWeight.bold : FontWeight.w500,
                              letterSpacing: isActive ? 0.3 : 0.0,
                            ),
                            child: Text(item['label'] as String),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
