import 'package:go_router/go_router.dart';
import '../../features/admin/presentation/manage_schools_screen.dart';
import '../../features/admin/presentation/manage_sppg_admins_screen.dart';
import '../../features/admin/presentation/manage_students_screen.dart';
import '../../features/admin/presentation/super_admin_profile_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/preferences_screen.dart';
import '../../features/auth/presentation/profile_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/distribution/presentation/distribution_tracker_screen.dart';
import '../../features/evaluation/presentation/gamification_screen.dart';
import '../../features/evaluation/presentation/menu_detail_screen.dart';
import '../../features/evaluation/presentation/next_day_confirmation_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/menu/presentation/create_schedule_screen.dart';
import '../../features/menu/presentation/manage_ingredients_screen.dart';
import '../../features/menu/presentation/manage_menu_screen.dart';
import '../../features/menu/presentation/sppg_topsis_spk_screen.dart';
import '../../features/production/presentation/estimation_screen.dart';
import '../../features/sppg/presentation/ai_recommendations_screen.dart';
import '../../features/sppg/presentation/food_waste_trend_screen.dart';
import '../../features/sppg/presentation/nlp_sentiment_screen.dart';
import '../../features/sppg/presentation/sppg_dashboard_screen.dart';
import '../../features/sppg/presentation/sppg_profile_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // === SPLASH & INTRO ===
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),

    // === AUTHENTICATION ===
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    // === SISWA / PENERIMA MANFAAT ROUTES ===
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/profil/gamifikasi',
      builder: (context, state) => const GamificationScreen(),
    ),
    GoRoute(
      path: '/profil/preferensi',
      builder: (context, state) => const PreferencesScreen(),
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

    // === ADMIN SPPG ROUTES ===
    GoRoute(
      path: '/sppg/dashboard',
      builder: (context, state) => const SppgDashboardScreen(),
    ),
    GoRoute(
      path: '/sppg/profil-saya',
      builder: (context, state) => const SppgProfileScreen(),
    ),
    GoRoute(
      path: '/sppg/analitik/nlp',
      builder: (context, state) => const NlpSentimentScreen(),
    ),
    GoRoute(
      path: '/sppg/analitik/rekomendasi',
      builder: (context, state) => const AiRecommendationsScreen(),
    ),
    GoRoute(
      path: '/sppg/analitik/tren',
      builder: (context, state) => const FoodWasteTrendScreen(),
    ),
    GoRoute(
      path: '/sppg/topsis-spk-engine',
      builder: (context, state) => const SppgTopsisSpkScreen(),
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
        List<Map<String, dynamic>>? menus;
        Map<String, dynamic>? initialSelectedMenu;

        if (state.extra is List<Map<String, dynamic>>) {
          menus = state.extra as List<Map<String, dynamic>>?;
        } else if (state.extra is Map<String, dynamic>) {
          final extraMap = state.extra as Map<String, dynamic>;
          if (extraMap.containsKey('availableMenus')) {
            menus = extraMap['availableMenus'] as List<Map<String, dynamic>>?;
          }
          if (extraMap.containsKey('selectedMenu')) {
            initialSelectedMenu = extraMap['selectedMenu'] as Map<String, dynamic>?;
          } else {
            initialSelectedMenu = extraMap;
          }
        }

        return CreateScheduleScreen(
          availableMenus: menus,
          initialSelectedMenu: initialSelectedMenu,
        );
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

    // === SUPER ADMIN ROUTES ===
    GoRoute(
      path: '/admin/sekolah',
      builder: (context, state) => const ManageSchoolsScreen(),
    ),
    GoRoute(
      path: '/admin/sppg-admin',
      builder: (context, state) => const ManageSppgAdminsScreen(),
    ),
    GoRoute(
      path: '/admin/penerima-manfaat',
      builder: (context, state) => const ManageStudentsScreen(),
    ),
    GoRoute(
      path: '/admin/profil-saya',
      builder: (context, state) => const SuperAdminProfileScreen(),
    ),
  ],
);
