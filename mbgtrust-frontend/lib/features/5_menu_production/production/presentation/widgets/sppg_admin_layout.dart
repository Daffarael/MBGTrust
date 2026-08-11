import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mbgtrust/core/theme/app_colors.dart';

class SppgAdminLayout extends StatefulWidget {
  final String currentRoute;
  final String title;
  final String? subtitle;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final VoidCallback? onTopsisTap;

  const SppgAdminLayout({
    super.key,
    required this.currentRoute,
    required this.title,
    this.subtitle,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.onTopsisTap,
  });

  @override
  State<SppgAdminLayout> createState() => _SppgAdminLayoutState();
}

class _SppgAdminLayoutState extends State<SppgAdminLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDesktopSidebarExpanded = true;

  final List<Map<String, dynamic>> _menuItems = [
    {
      'title': 'Dasbor Utama',
      'icon': Icons.dashboard_rounded,
      'route': '/sppg/dashboard',
    },
    {
      'title': 'Bahan Baku',
      'icon': Icons.flatware_rounded,
      'route': '/manage-ingredients',
    },
    {
      'title': 'Katalog Menu',
      'icon': Icons.restaurant_menu_rounded,
      'route': '/manage-menu',
    },
    {
      'title': 'Jadwal Mingguan',
      'icon': Icons.edit_calendar_rounded,
      'route': '/create-schedule',
    },
    {
      'title': 'Rekomendasi AI',
      'icon': Icons.auto_awesome_rounded,
      'route': '/sppg/topsis-spk-engine',
    },
    {
      'title': 'Tracking Distribusi',
      'icon': Icons.local_shipping_rounded,
      'route': '/distribution-tracker',
    },
  ];

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.logout_rounded, color: AppColors.error, size: 24),
            SizedBox(width: 8),
            Text('Konfirmasi Keluar', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari sistem Admin SPPG?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.go('/login');
            },
            child: const Text('Ya, Keluar'),
          ),
        ],
      ),
    );
  }

  void _onSelectRoute(String route) {
    if (Scaffold.of(context).hasDrawer && Scaffold.of(context).isDrawerOpen) {
      Navigator.pop(context);
    }
    if (widget.currentRoute != route) {
      context.go(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 850;

        if (isDesktop) {
          // PC / DESKTOP RESPONSIVE LAYOUT (COLLAPSIBLE SIDEBAR)
          return Scaffold(
            key: _scaffoldKey,
            body: Row(
              children: [
                // Collapsible Left Sidebar Panel
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  width: _isDesktopSidebarExpanded ? 260 : 72,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border(
                      right: BorderSide(
                        color: AppColors.border.withValues(alpha: 0.8),
                        width: 1,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(2, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Sidebar Header & Toggle Button
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 18),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.soup_kitchen_rounded,
                                color: AppColors.primary,
                                size: 22,
                              ),
                            ),
                            if (_isDesktopSidebarExpanded) ...[
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'MBGTrust SPPG',
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      'Unit Dapur Kota Padang 01',
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(width: 4),
                            IconButton(
                              icon: Icon(
                                _isDesktopSidebarExpanded
                                    ? Icons.chevron_left_rounded
                                    : Icons.menu_rounded,
                                color: AppColors.textSecondary,
                              ),
                              tooltip: _isDesktopSidebarExpanded
                                  ? 'Ciutkan Sidebar'
                                  : 'Buka Sidebar',
                              onPressed: () {
                                setState(() {
                                  _isDesktopSidebarExpanded =
                                      !_isDesktopSidebarExpanded;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: AppColors.border),

                      // Sidebar Menu Items List
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 10),
                          itemCount: _menuItems.length,
                          itemBuilder: (context, index) {
                            final item = _menuItems[index];
                            final isSelected =
                                widget.currentRoute == item['route'];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              child: Tooltip(
                                message: !_isDesktopSidebarExpanded
                                    ? item['title'] as String
                                    : '',
                                child: ListTile(
                                  selected: isSelected,
                                  selectedTileColor: AppColors.primaryLight,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  leading: Icon(
                                    item['icon'] as IconData,
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                    size: 22,
                                  ),
                                  title: _isDesktopSidebarExpanded
                                      ? Text(
                                          item['title'] as String,
                                          softWrap: true,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.w500,
                                            color: isSelected
                                                ? AppColors.primaryDark
                                                : AppColors.textPrimary,
                                          ),
                                        )
                                      : null,
                                  onTap: () =>
                                      _onSelectRoute(item['route'] as String),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Sidebar Footer Logout Button
                      const Divider(height: 1, color: AppColors.border),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Tooltip(
                          message: !_isDesktopSidebarExpanded ? 'Keluar' : '',
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            leading: const Icon(
                              Icons.logout_rounded,
                              color: AppColors.error,
                              size: 22,
                            ),
                            title: _isDesktopSidebarExpanded
                                ? const Text(
                                    'Keluar',
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.error,
                                    ),
                                  )
                                : null,
                            onTap: () => _confirmLogout(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Page Content Area
                Expanded(
                  child: Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (widget.subtitle != null)
                            Text(
                              widget.subtitle!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                      actions: widget.actions,
                    ),
                    body: widget.body,
                    floatingActionButton: widget.floatingActionButton,
                  ),
                ),
              ],
            ),
          );
        }

        // MOBILE / TABLET RESPONSIVE LAYOUT (WITH HAMBURGER SIDEBAR DRAWER)
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            titleSpacing: 0,
            leading: Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu_rounded, color: AppColors.primary),
                tooltip: 'Buka Navigasi Sidebar',
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.subtitle != null)
                  Text(
                    widget.subtitle!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
            actions: widget.actions,
          ),
          drawer: Drawer(
            child: Column(
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.soup_kitchen_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'MBGTrust SPPG',
                              softWrap: true,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Unit Dapur Kota Padang 01',
                              softWrap: true,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _menuItems.length,
                    itemBuilder: (context, index) {
                      final item = _menuItems[index];
                      final isSelected = widget.currentRoute == item['route'];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        child: ListTile(
                          selected: isSelected,
                          selectedTileColor: AppColors.primaryLight,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          leading: Icon(
                            item['icon'] as IconData,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                          title: Text(
                            item['title'] as String,
                            softWrap: true,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppColors.primaryDark
                                  : AppColors.textPrimary,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            if (item['route'] == '/sppg/topsis-spk-engine' &&
                                widget.onTopsisTap != null) {
                              widget.onTopsisTap!();
                            } else if (widget.currentRoute != item['route']) {
                              context.go(item['route'] as String);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout_rounded,
                      color: AppColors.error),
                  title: const Text(
                    'Keluar',
                    softWrap: true,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.error,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _confirmLogout(context);
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          body: widget.body,
          floatingActionButton: widget.floatingActionButton,
        );
      },
    );
  }
}


