import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/mock_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

class CreateScheduleScreen extends StatefulWidget {
  final List<Map<String, dynamic>>? availableMenus;

  const CreateScheduleScreen({
    super.key,
    this.availableMenus,
  });

  @override
  State<CreateScheduleScreen> createState() => _CreateScheduleScreenState();
}

class _CreateScheduleScreenState extends State<CreateScheduleScreen> {
  late List<Map<String, dynamic>> _masterMenus;

  final Map<String, Map<String, dynamic>?> _weeklySchedule = {
    'Senin': null,
    'Selasa': null,
    'Rabu': null,
    'Kamis': null,
    'Jumat': null,
  };

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _masterMenus = widget.availableMenus ?? MockData.foodMenuList;
    if (_masterMenus.isNotEmpty) {
      _weeklySchedule['Senin'] = _masterMenus[0];
      if (_masterMenus.length > 1) _weeklySchedule['Selasa'] = _masterMenus[1];
      if (_masterMenus.length > 2) _weeklySchedule['Rabu'] = _masterMenus[2];
      if (_masterMenus.length > 3) _weeklySchedule['Kamis'] = _masterMenus[3];
      _weeklySchedule['Jumat'] = _masterMenus[0];
    }
  }

  void _showSelectMenuModal(String day) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return Container(
          constraints: BoxConstraints(
            maxWidth: 640,
            maxHeight: MediaQuery.of(modalContext).size.height * 0.7,
          ),
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Pilih Menu Hari $day',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(modalContext),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: _masterMenus.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 12, color: AppColors.border),
                  itemBuilder: (context, index) {
                    final item = _masterMenus[index];
                    final name = item['name'] ?? '';
                    final calories = item['calories']?.toString() ?? '500';
                    final photoUrl = item['photoUrl'] ?? '';
                    final isCurrentlySelected =
                        _weeklySchedule[day]?['id'] == item['id'];

                    return ListTile(
                      contentPadding: const EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tileColor: isCurrentlySelected
                          ? AppColors.primaryLight
                          : Colors.transparent,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          photoUrl,
                          width: 54,
                          height: 54,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: 54,
                            height: 54,
                            color: AppColors.primaryLight,
                            child: const Icon(Icons.restaurant_menu_rounded,
                                color: AppColors.primary),
                          ),
                        ),
                      ),
                      title: Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isCurrentlySelected
                              ? AppColors.primaryDark
                              : AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        '$calories kcal • ${item['category'] ?? "Makan Siang"}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      trailing: isCurrentlySelected
                          ? const Icon(Icons.check_circle_rounded,
                              color: AppColors.primary)
                          : const Icon(Icons.chevron_right_rounded,
                              color: AppColors.textLight),
                      onTap: () {
                        setState(() {
                          _weeklySchedule[day] = item;
                        });
                        Navigator.pop(modalContext);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleSaveSchedule() {
    setState(() => _isSaving = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _isSaving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jadwal menu mingguan SPPG berhasil disimpan!'),
          backgroundColor: AppColors.success,
        ),
      );

      if (context.canPop()) {
        context.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Jadwal Mingguan'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            children: [
              // Subtitle Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                color: AppColors.primaryLight,
                child: Row(
                  children: const [
                    Icon(Icons.info_outline_rounded,
                        color: AppColors.primaryDark, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Pilihlah menu terbaik untuk setiap hari kerja (Senin - Jumat) dari Master Menu SPPG.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Weekly Days List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _weeklySchedule.keys.length,
                  itemBuilder: (context, index) {
                    final day = _weeklySchedule.keys.elementAt(index);
                    final assignedMenu = _weeklySchedule[day];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: assignedMenu != null
                              ? AppColors.primary.withValues(alpha: 0.4)
                              : AppColors.border,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Day Label & Change Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Hari $day',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () => _showSelectMenuModal(day),
                                  icon: Icon(
                                    assignedMenu != null
                                        ? Icons.swap_horiz_rounded
                                        : Icons.add_rounded,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                  label: Text(
                                    assignedMenu != null
                                        ? 'Ganti Menu'
                                        : 'Pilih Menu',
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Menu Item Preview
                            if (assignedMenu != null)
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      assignedMenu['photoUrl'] ?? '',
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Container(
                                        width: 60,
                                        height: 60,
                                        color: AppColors.primaryLight,
                                        child: const Icon(
                                          Icons.restaurant_menu_rounded,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          assignedMenu['name'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${assignedMenu['calories'] ?? 500} kcal • Protein: ${assignedMenu['protein'] ?? "25g"}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.clear_rounded,
                                        color: AppColors.textLight, size: 18),
                                    tooltip: 'Kosongkan Hari Ini',
                                    onPressed: () {
                                      setState(() {
                                        _weeklySchedule[day] = null;
                                      });
                                    },
                                  ),
                                ],
                              )
                            else
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.border,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: const Text(
                                  'Belum ada menu yang dipilih untuk hari ini.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textLight,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom Bar Save Button
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
                  child: CustomButton(
                    text: 'Simpan Jadwal Mingguan',
                    prefixIcon: const Icon(Icons.save_rounded,
                        color: Colors.white, size: 20),
                    isLoading: _isSaving,
                    onPressed: _handleSaveSchedule,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
