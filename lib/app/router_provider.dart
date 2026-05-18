import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ltc/app/shell/main_shell.dart';
import 'package:ltc/common/screens/splash_screen.dart';
import 'package:ltc/core/config/routes.dart';
import 'package:ltc/features/auth/presentation/providers/auth_provider.dart';
import 'package:ltc/features/auth/presentation/states/auth_state.dart';
import 'package:ltc/features/auth/presentation/screens/login_screen.dart';
import 'package:ltc/features/auth/presentation/screens/register_screen.dart';
import 'package:ltc/features/booking/presentation/screens/package_booking_screen.dart';
import 'package:ltc/features/booking/presentation/screens/patient_declaration_screen.dart';
import 'package:ltc/features/booking/presentation/screens/service_booking_screen.dart';
import 'package:ltc/features/booking/presentation/screens/specialty_booking_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Tạo Listenable lắng nghe authProvider
  final listenable = _AuthListenable(ref);
  GoRouter? router;
  router = GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: listenable,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      log('>>> redirect: ${state.matchedLocation} | authState: $authState');
      final stack = router?.routerDelegate.currentConfiguration.matches
          .map((m) => m.matchedLocation)
          .join(' → ');
      log('>>> stack: $stack');
      log('>>> current: ${state.matchedLocation} | auth: $authState');
      if (authState is AuthInitial || authState is AuthError) {
        return Routes.splash;
      }

      if (authState is AuthAuthenticated) {
        if (state.matchedLocation == Routes.splash ||
            state.matchedLocation == Routes.login) {
          return Routes.main;
        }
      }
      // if (authState is AuthUnauthenticated) {
      //   return Routes.main;
      // }
      if (authState is AuthUnauthenticated) {
        if (state.matchedLocation == Routes.splash) {
          return Routes.main;
        }
        if (state.matchedLocation == Routes.main) {
          return Routes.main;
        }
        return null;
      }

      return null;
    },
    routes: [
      GoRoute(
        name: RouteName.splash,
        path: Routes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        name: RouteName.login,
        path: Routes.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        name: RouteName.register,
        path: Routes.register,
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        name: RouteName.main,
        path: Routes.main,
        builder: (_, __) => MainShell(),
      ),
      GoRoute(
        name: RouteName.serviceBooking,
        path: Routes.serviceBooking,
        builder: (_, __) => const ServiceBookingScreen(),
      ),
      GoRoute(
        name: RouteName.specialtyBooking,
        path: Routes.specialtyBooking,
        builder: (_, __) => const SpecialtyBookingScreen(),
      ),
      GoRoute(
        name: RouteName.packageBooking,
        path: Routes.packageBooking,
        builder: (_, __) => const PackageBookingScreen(),
      ),
      GoRoute(
        name: RouteName.patientDeclaration,
        path: Routes.patientDeclaration,
        builder: (_, __) => const PatientDeclarationScreen(),
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
    _subscription = ref.listen<AuthState>(authProvider, (previous, next) {
      // if (previous is AuthAuthenticated && next is AuthUnauthenticated) {
      //   notifyListeners(); // router redirect về main
      // }
      if (next is AuthUnauthenticated) {
        notifyListeners(); // router redirect về main
      }
      if (next is AuthAuthenticated) {
        notifyListeners(); // router redirect về main
      }
      if (next is AuthInitial || next is AuthError) {
        notifyListeners();
      }
      // AuthUnauthenticated → KHÔNG notify → không reset stack
    });
  }

  late final ProviderSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}
