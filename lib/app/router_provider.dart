import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ltc/app/shell/main_shell.dart';
import 'package:ltc/common/screens/splash_screen.dart';
import 'package:ltc/core/config/routes.dart';
import 'package:ltc/features/auth/presentation/providers/auth_provider.dart';
import 'package:ltc/features/auth/presentation/providers/auth_state.dart';
import 'package:ltc/features/auth/presentation/screens/login_screen.dart';
import 'package:ltc/features/dashboard/presentation/screens/dashboard_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Tạo Listenable lắng nghe authProvider
  final listenable = _AuthListenable(ref);

  final router = GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: listenable,
    redirect: (context, state) {
      final authState = ref.read(authProvider);

      final onSplash = state.matchedLocation == Routes.splash;
      final onLogin = state.matchedLocation == Routes.login;

      if (authState is AuthInitial || authState is AuthLoading) {
        return onSplash ? null : Routes.splash;
      }

      if (authState is AuthUnauthenticated || authState is AuthError) {
        return onLogin ? null : Routes.main;
        // return onLogin ? null : Routes.login;
      }

      if (authState is AuthAuthenticated) {
        return (onLogin || onSplash) ? Routes.main : null;
      }

      return null;
    },
    routes: [
      GoRoute(path: Routes.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: Routes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: Routes.main, builder: (_, __) => MainShell()),
      GoRoute(
        path: Routes.dashboard,
        builder: (_, __) => const DashboardScreen(),
      ),
    ],
  );

  // Tự cleanup khi provider bị huỷ
  ref.onDispose(listenable.dispose);

  return router;
});

// // ChangeNotifier thuần của Flutter — không phải Riverpod provider
// // GoRouter bắt buộc cần Listenable nên vẫn dùng ChangeNotifier
class _AuthListenable extends ChangeNotifier {
  _AuthListenable(Ref ref) {
    _subscription = ref.listen<AuthState>(
      authProvider,
      (_, __) => notifyListeners(),
    );
  }

  late final ProviderSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}
