import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/profile_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/distribution/presentation/distribution_tracker_screen.dart';
import '../../features/evaluation/presentation/menu_detail_screen.dart';
import '../../features/evaluation/presentation/next_day_confirmation_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/menu/presentation/create_schedule_screen.dart';
import '../../features/menu/presentation/manage_ingredients_screen.dart';
import '../../features/menu/presentation/manage_menu_screen.dart';
import '../../features/production/presentation/estimation_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/menu-detail',
      builder: (context, state) {
        final extraMap = state.extra as Map<String, dynamic>?;
        return MenuDetailScreen(menuData: extraMap);
      },
    ),
    GoRoute(
      path: '/next-day-confirmation',
      builder: (context, state) => const NextDayConfirmationScreen(),
    ),
    GoRoute(
      path: '/manage-menu',
      builder: (context, state) => const ManageMenuScreen(),
    ),
    GoRoute(
      path: '/manage-ingredients',
      builder: (context, state) => const ManageIngredientsScreen(),
    ),
    GoRoute(
      path: '/create-schedule',
      builder: (context, state) {
        final menus = state.extra as List<Map<String, dynamic>>?;
        return CreateScheduleScreen(availableMenus: menus);
      },
    ),
    GoRoute(
      path: '/estimation',
      builder: (context, state) => const EstimationScreen(),
    ),
    GoRoute(
      path: '/distribution-tracker',
      builder: (context, state) => const DistributionTrackerScreen(),
    ),
  ],
);
