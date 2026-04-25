import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/common/widgets/badge/icon_badge_widget.dart';
import 'package:ltc/common/widgets/buttons/primary_button_widget.dart';
import 'package:ltc/common/widgets/containers/card_widget.dart';
import 'package:ltc/common/widgets/header/header_widget.dart';
import 'package:ltc/core/localization/locale_provider.dart';
import 'package:ltc/core/theme/app_spacing.dart';
import 'package:ltc/features/auth/presentation/providers/auth_provider.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = ref.watch(stringsProvider);
    final md = MediaQuery.of(context);
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(height: md.padding.top),
          HeaderWidget(title: tr.setting, image: null),
          SizedBox(height: AppSpacing.gapMd),
          SingleChildScrollView(
            child: Column(
              children: [
                _buildSection(title: title, icon: icon, color: color, child: ,);
                PrimaryButtonWidget(
                  isEnabled: true,
                  title: tr.logout,
                  onPressed: () {
                    ref.read(authProvider.notifier).logout();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return CardWidget(
      child: Column(
        children: [
          Row(
            children: [
              IconBadgeWidget(icon: icon, color: color),
              Text(title),
            ],
          ),
          child,
        ],
      ),
    );
  }
}
