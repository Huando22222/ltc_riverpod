import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/localization/locale_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ltc/core/theme/theme_provider.dart';

import '../core/theme/app_theme.dart';
import 'router_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);
    final themeAsync = ref.watch(themeProvider);
    return themeAsync.when(
      data: (themeMode) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          locale: locale,
          supportedLocales: const [Locale('vi'), Locale('en')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
      loading: () => const SizedBox(), // hoặc splash screen
      error: (e, _) => const SizedBox(),
    );
  }
}
