import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_tracker/presentation/views/expense_tracker_screen.dart';
import 'package:personal_tracker/presentation/views/expense_screen.dart';
import 'package:personal_tracker/presentation/views/loading_screen.dart';
import 'package:personal_tracker/presentation/views/password_code_screen.dart';
import 'package:personal_tracker/presentation/views/password_reset_screen.dart';
import 'package:personal_tracker/presentation/views/register_screen.dart';
import 'package:personal_tracker/presentation/views/settings_screen.dart';
import 'package:personal_tracker/presentation/views/sign_in_screen.dart';
import 'package:personal_tracker/presentation/views/verification_screen.dart';
import 'package:personal_tracker/provider/route_provider.dart';

// configures Gorouter to handle routing based on the current route state managed by the routenotifier class
final goRouterProvider = Provider<GoRouter>((ref) {
  final route = ref.watch(routeNotifierProvider);

  return GoRouter(
    initialLocation: '/logIn',
    routes: [
      GoRoute(
        path: '/password-reset',
        builder: (context, state) => PasswordResetScreen(),
      ),
      GoRoute(
        path: '/password-code',
        builder: (context, state) => PasswordCodeScreen(),
      ),
      GoRoute(
        path: '/logIn',
        builder: (context, state) => LogInScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        path: '/verify',
        builder: (context, state) => VerificationScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => ExpenseTrackerScreen(),
        routes: [
          GoRoute(
            path: 'settings',
            builder: (context, state) => SettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/addExpense',
        builder: (context, state) => ExpenseScreen(),
      ),
      GoRoute(
        path: '/loading',
        builder: (context, state) => LoadingScreen(),
      ),
    ],
    debugLogDiagnostics: true,
    redirect: (context, state) {
      switch (route) {
        case AppRoute.verification:
          return '/verify';
        case AppRoute.passwordcode:
          return '/password-code';
        case AppRoute.passwordReset:
          return '/password-reset';
        case AppRoute.dashboard:
          return '/dashboard';
        case AppRoute.addExpense:
          return '/addExpense';
        case AppRoute.loading:
          return '/loading';
        case AppRoute.settings:
          return '/dashboard/settings';
        case AppRoute.register:
          return '/register';
        case AppRoute.logIn:
          return '/logIn';
        default:
          return '/logIn';
      }
    },
  );
});
