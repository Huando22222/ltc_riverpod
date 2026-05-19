import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/app/shell/bottom_nav_provider.dart';
import 'package:ltc/app/shell/bottom_nav_shell.dart';
import 'package:ltc/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:ltc/features/health/presentation/screens/health_screen.dart';
import 'package:ltc/features/lookup/presentation/screens/lookup_screen.dart';
import 'package:ltc/features/setting/presentation/screens/setting_screen.dart';

class MainShell extends ConsumerWidget {
  MainShell({super.key});

  final List<Widget> _screens = [
    DashboardScreen(),
    HealthScreen(),
    LookupScreen (),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavProvider);
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: currentIndex, children: _screens),
      bottomNavigationBar: BottomNavShell(),
    );
  }
}
