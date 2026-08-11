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
    // 3 Master Navigasi Siswa dalam Urutan STATIS: Peringkat - Beranda - Profil
    final List<Map<String, dynamic>> navItems = [
      {
        'id': 0,
        'route': '/profil/gamifikasi',
        'icon': Icons.emoji_events_rounded,
        'label': 'Peringkat',
      },
      {
        'id': 1,
        'route': '/home',
        'icon': Icons.home_rounded,
        'label': 'Beranda',
      },
      {
        'id': 2,
        'route': '/profile',
        'icon': Icons.person_rounded,
        'label': 'Profil',
      },
    ];

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
        height: 70,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(navItems.length, (index) {
            final item = navItems[index];
            final bool isActive = currentIndex == index;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  if (!isActive) {
                    context.go(item['route'] as String);
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: isActive
                      ? _buildActiveCircularBadge(item)
                      : _buildInactiveItem(item),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  /// Tampilan Menu Aktif: Bulat Menonjol (Prominent Circular Active State)
  Widget _buildActiveCircularBadge(Map<String, dynamic> item) {
    return Column(
      key: ValueKey('active_${item['id']}'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.translate(
          offset: const Offset(0, -5),
          child: Container(
            width: 48,
            height: 48,
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
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              item['icon'] as IconData,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        Text(
          item['label'] as String,
          style: const TextStyle(
            color: AppColors.primaryDark,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  /// Tampilan Menu Non-Aktif
  Widget _buildInactiveItem(Map<String, dynamic> item) {
    return Column(
      key: ValueKey('inactive_${item['id']}'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          item['icon'] as IconData,
          color: AppColors.textLight,
          size: 22,
        ),
        const SizedBox(height: 3),
        Text(
          item['label'] as String,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
