import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:ltc/common/screens/splash_screen.dart';
import 'package:ltc/core/config/routes.dart';
import 'package:ltc/features/auth/presentation/providers/auth_provider.dart';
import 'package:ltc/features/auth/presentation/providers/auth_state.dart';
import 'package:ltc/features/auth/presentation/screens/login_screen.dart';
import 'package:ltc/features/dashboard/presentation/screens/dashboard_screen.dart';

// Giúp GoRouter lắng nghe authProvider
class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(this._ref) {
    _ref.listen<AuthState>(authProvider, (_, __) => notifyListeners());
  }
  final Ref _ref;
}

final routerNotifierProvider = ChangeNotifierProvider(_RouterNotifier.new);

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: notifier, // ← tự redirect khi auth thay đổi
    redirect: (context, state) {
      final authState = ref.read(authProvider);

      final onSplash = state.matchedLocation == Routes.splash;
      final onLogin = state.matchedLocation == Routes.login;
      // final onRegister = state.matchedLocation == Routes.register;
      // final onDashboard = state.matchedLocation == Routes.dashboard;

      if (authState is AuthInitial || authState is AuthLoading) {
        return onSplash ? null : Routes.splash;
      }

      if (authState is AuthUnauthenticated || authState is AuthError) {
        return onLogin ? null : Routes.dashboard;
        // return onLogin ? null : Routes.login;
      }

      if (authState is AuthAuthenticated) {
        return (onLogin || onSplash) ? Routes.dashboard : null;
      }

      return null;
    },
    routes: [
      GoRoute(path: Routes.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: Routes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(
        path: Routes.dashboard,
        builder: (_, __) => const DashboardScreen(),
      ),
    ],
  );
});
