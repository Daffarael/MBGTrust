import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MbgTrustLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool isDark;

  const MbgTrustLogo({
    super.key,
    this.size = 72,
    this.showText = false,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          padding: EdgeInsets.all(size * 0.08),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: size * 0.2,
                offset: Offset(0, size * 0.08),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/logo_mbgtrust.png',
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) => Icon(
                Icons.restaurant_menu_rounded,
                size: size * 0.5,
                color: Colors.white,
              ),
            ),
          ),
        ),
        if (showText) ...[
          SizedBox(height: size * 0.18),
          Text(
            'MBGTrust',
            style: TextStyle(
              fontSize: size * 0.3,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          SizedBox(height: size * 0.04),
          Text(
            'Mitigasi Food Waste & AI Nutrisi MBG',
            style: TextStyle(
              fontSize: size * 0.15,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
