import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/common/widgets/images/asset_image_widget.dart';
import 'package:ltc/core/constants/image_path_constants.dart';
import 'package:ltc/core/localization/locale_provider.dart';
import 'package:ltc/features/auth/presentation/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  // ← đổi thành ConsumerStatefulWidget
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  // ← ConsumerState
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await Future.wait([
        ref.read(authProvider.notifier).checkAuth(),
        ref.read(localeProvider.notifier).loadSavedLocale(),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: AssetImageWidget(
          assetPath: ImagePathConstants.logoLTC,
          height: size.width * 0.5,
        ),
      ),
    );
  }
}
