import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/auth/auth_provider.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'shared/widgets/modern_main_layout.dart';
import 'features/misc/landing_screen.dart';
import 'features/misc/demo_screen.dart';
import 'features/dashboard/modern_dashboard_screen.dart';
<<<<<<< HEAD
import 'features/profile/modern_profile_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/diet/diet_screen.dart';
import 'features/progress/progress_screen.dart';
import 'features/admin/admin_panel_screen.dart';
import 'features/admin/admin_users_screen.dart';
import 'features/doctor/doctor_patients_screen.dart';
import 'features/doctor/doctor_patient_detail_screen.dart';
import 'features/activity/activity_screen.dart';
import 'features/workouts/workouts_screen.dart';
import 'features/profile/profile_medical_screen.dart';
import 'features/profile/profile_edit_screen.dart';
import 'features/diet/food_check_screen.dart';
import 'features/support/user_support_screen.dart';
import 'features/notifications/notifications_screen.dart';
=======
import 'features/profile/profile_screen.dart';
import 'features/diet/diet_screen.dart';
import 'features/progress/progress_screen.dart';
import 'features/recipes/recipes_screen.dart';
import 'features/admin/admin_panel_screen.dart';
import 'features/admin/admin_users_screen.dart';
import 'features/admin/admin_recipes_screen.dart';
import 'features/doctor/doctor_patients_screen.dart';
import 'features/doctor/doctor_patient_detail_screen.dart';
import 'features/activity/activity_screen.dart';

>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
final _rootKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootKey,
    routes: [
      GoRoute(path: '/', builder: (ctx, st) => const LandingScreen()),
      GoRoute(path: '/demo', builder: (ctx, st) => const DemoDietScreen()),
      GoRoute(path: '/login', builder: (ctx, st) => const LoginScreen()),
      GoRoute(path: '/register', builder: (ctx, st) => const RegisterScreen()),
      ShellRoute(
        navigatorKey: _shellKey,
        builder: (ctx, st, child) => ModernMainLayout(child: child),
        routes: [
          GoRoute(path: '/dashboard', builder: (ctx, st) => const ModernDashboardScreen()),
<<<<<<< HEAD
          GoRoute(path: '/profile', builder: (ctx, st) => const ModernProfileScreen()),
          GoRoute(path: '/profile/edit', builder: (ctx, st) => const ProfileEditScreen()),
          GoRoute(path: '/profile/medical', builder: (ctx, st) => const ProfileMedicalScreen()),
          GoRoute(path: '/food-check', builder: (ctx, st) => const FoodCheckScreen()),
          GoRoute(path: '/settings', builder: (ctx, st) => const SettingsScreen()),
          GoRoute(path: '/activity', builder: (ctx, st) => const ActivityScreen()),
          GoRoute(path: '/workouts', builder: (ctx, st) => const WorkoutsScreen()),
          GoRoute(path: '/diet', builder: (ctx, st) => const DietScreen()),
          GoRoute(path: '/progress', builder: (ctx, st) => const ProgressScreen()),
          GoRoute(
            path: '/doctor/patients',
            redirect: (ctx, st) {
=======
          GoRoute(path: '/profile', builder: (ctx, st) => const ProfileScreen()),
          GoRoute(path: '/activity', builder: (ctx, st) => const ActivityScreen()),
          GoRoute(path: '/diet', builder: (ctx, st) => const DietScreen()),
          GoRoute(path: '/progress', builder: (ctx, st) => const ProgressScreen()),
          GoRoute(path: '/recipes', builder: (ctx, st) => const RecipesScreen()),
          GoRoute(
            path: '/doctor/patients',
            redirect: (ctx, st) {
              final ref = ProviderScope.containerOf(ctx);
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
              return roleGuard(ref, 'doctor');
            },
            builder: (ctx, st) => const DoctorPatientsScreen(),
          ),
          GoRoute(
            path: '/doctor/patient/:id',
            redirect: (ctx, st) {
<<<<<<< HEAD
=======
              final ref = ProviderScope.containerOf(ctx);
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
              return roleGuard(ref, 'doctor');
            },
            builder: (ctx, st) => DoctorPatientDetailScreen(id: st.pathParameters['id']!),
          ),
<<<<<<< HEAD
          GoRoute(path: '/support', builder: (ctx, st) => const UserSupportScreen()),
          GoRoute(path: '/notifications', builder: (ctx, st) => const NotificationsScreen()),
        ],
      ),
      GoRoute(
        path: '/admin',
        redirect: (ctx, st) {
          return roleGuard(ref, 'admin');
        },
        builder: (ctx, st) => const AdminPanelScreen(),
      ),
      GoRoute(
        path: '/admin/users',
        redirect: (ctx, st) {
          return roleGuard(ref, 'admin');
        },
        builder: (ctx, st) => const AdminUsersScreen(),
      ),
    ],
    redirect: (ctx, st) {
=======
          GoRoute(
            path: '/admin',
            redirect: (ctx, st) {
              final ref = ProviderScope.containerOf(ctx);
              return roleGuard(ref, 'admin');
            },
            builder: (ctx, st) => const AdminPanelScreen(),
          ),
          GoRoute(
            path: '/admin/users',
            redirect: (ctx, st) {
              final ref = ProviderScope.containerOf(ctx);
              return roleGuard(ref, 'admin');
            },
            builder: (ctx, st) => const AdminUsersScreen(),
          ),
          GoRoute(
            path: '/admin/recipes',
            redirect: (ctx, st) {
              final ref = ProviderScope.containerOf(ctx);
              return roleGuard(ref, 'admin');
            },
            builder: (ctx, st) => const AdminRecipesScreen(),
          ),
        ],
      ),
    ],
    redirect: (ctx, st) {
      final ref = ProviderScope.containerOf(ctx);
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
      return authRedirect(ref, st);
    },
  );
});

<<<<<<< HEAD
String? roleGuard(Ref ref, String requiredRole) {
  final role = ref.read(authProvider).role?.toLowerCase();
  final reqRole = requiredRole.toLowerCase();
  
  if (role == null) return '/';
  if (role != reqRole && role != 'admin') return '/';
  return null;
}

String? authRedirect(Ref ref, GoRouterState state) {
=======
String? roleGuard(ProviderContainer ref, String requiredRole) {
  final role = ref.read(authProvider).role;
  if (role == null) return '/';
  if (role != requiredRole && role != 'admin') return '/';
  return null;
}

String? authRedirect(ProviderContainer ref, GoRouterState state) {
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
  final auth = ref.read(authProvider);
  final isLoggedIn = auth.isAuthenticated;
  final loggingIn = state.uri.toString().startsWith('/login') || state.uri.toString().startsWith('/register');
  if (!isLoggedIn && !loggingIn && state.fullPath != '/' && !state.fullPath!.startsWith('/demo')) {
    return '/login';
  }
  if (isLoggedIn && loggingIn) return '/dashboard';
  return null;
}
