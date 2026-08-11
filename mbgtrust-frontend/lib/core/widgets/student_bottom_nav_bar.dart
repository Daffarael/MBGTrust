import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
    final List<Map<String, dynamic>> navItems = [
      {
        'route': '/home',
        'icon': Icons.home_rounded,
        'label': 'Beranda',
      },
      {
        'route': '/profil/gamifikasi',
        'icon': Icons.emoji_events_rounded,
        'label': 'Peringkat',
      },
      {
        'route': '/profile',
        'icon': Icons.person_rounded,
        'label': 'Profil',
      },
    ];

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.12),
              blurRadius: 24,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: CurvedNavigationBar(
            index: currentIndex,
            height: 62,
            items: List.generate(navItems.length, (index) {
              final item = navItems[index];
              final bool isActive = index == currentIndex;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item['icon'] as IconData,
                    size: isActive ? 28 : 22,
                    color: isActive ? Colors.white : AppColors.textSecondary,
                  ),
                  if (!isActive) ...[
                    const SizedBox(height: 2),
                    Text(
                      item['label'] as String,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              );
            }),
            color: Colors.white,
            buttonBackgroundColor: AppColors.primary,
            backgroundColor: Colors.transparent,
            animationCurve: Curves.easeInOutCubic,
            animationDuration: const Duration(milliseconds: 400),
            onTap: (index) {
              if (index != currentIndex) {
                final targetRoute = navItems[index]['route'] as String;
                context.go(targetRoute);
              }
            },
          ),
        ),
      ),
    );
  }
}
