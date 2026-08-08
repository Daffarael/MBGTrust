import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/menu_item_model.dart';
import '../../data/models/schedule_model.dart';
import '../../data/repositories/menu_repository.dart';

final menuRepositoryProvider = Provider<MenuRepository>((ref) {
  return MenuRepository();
});

/// FutureProvider untuk mengambil daftar menu
final menuListProvider = FutureProvider.autoDispose<List<MenuItemModel>>((ref) async {
  final repo = ref.watch(menuRepositoryProvider);
  return await repo.getMenuList();
});

/// FutureProvider untuk menu hari ini
final todayScheduleProvider = FutureProvider.autoDispose<ScheduleModel?>((ref) async {
  final repo = ref.watch(menuRepositoryProvider);
  return await repo.getTodaySchedule();
});

/// FutureProvider untuk menu besok (H+1)
final tomorrowScheduleProvider = FutureProvider.autoDispose<ScheduleModel?>((ref) async {
  final repo = ref.watch(menuRepositoryProvider);
  return await repo.getTomorrowSchedule();
});
