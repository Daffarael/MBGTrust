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
    // 3 Master Navigasi Siswa
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

    // Susun item agar menu aktif SELALU berada di posisi TENGAH (index 1)
    final Map<String, dynamic> activeItem = allItems[currentIndex];
    final List<Map<String, dynamic>> otherItems =
        allItems.where((item) => item['id'] != currentIndex).toList();

    // Pastikan susunan 3 slot: [Left Item, Active Center Item, Right Item]
    final List<Map<String, dynamic>> displaySlots = [
      otherItems[0],
      activeItem,
      otherItems[1],
    ];

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: displaySlots.map((item) {
            final bool isActive = item['id'] == currentIndex;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  if (!isActive) {
                    context.go(item['route'] as String);
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  switchInCurve: Curves.easeOutBack,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                  child: isActive
                      ? _buildActiveCenterCircularBadge(item)
                      : _buildInactiveSideItem(item),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Tampilan Menu Aktif: Bulat Menonjol (Prominent Circular Active State) di Posisi Tengah
  Widget _buildActiveCenterCircularBadge(Map<String, dynamic> item) {
    return Column(
      key: ValueKey('active_${item['id']}'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.translate(
          offset: const Offset(0, -6),
          child: Container(
            width: 50,
            height: 50,
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
                  blurRadius: 12,
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

  /// Tampilan Menu Non-Aktif di Samping (Kiri & Kanan)
  Widget _buildInactiveSideItem(Map<String, dynamic> item) {
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
