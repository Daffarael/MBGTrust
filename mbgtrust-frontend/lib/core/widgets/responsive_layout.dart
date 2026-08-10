import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Standard responsive wrapper enforcing maximum width 640px for clean mobile & web displays
class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Color? backgroundColor;

  const ResponsiveLayout({
    super.key,
    required this.child,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.background,
      appBar: appBar,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 640),
            child: child,
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar != null
          ? Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 640),
                child: bottomNavigationBar,
              ),
            )
          : null,
      floatingActionButton: floatingActionButton,
    );
  }
}
