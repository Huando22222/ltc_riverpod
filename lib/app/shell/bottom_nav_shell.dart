import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltc/app/shell/bottom_nav_provider.dart';
import 'package:ltc/common/widgets/splash_tap_widget.dart';
import 'package:ltc/core/extensions/color_schema_ext.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/localization/locale_provider.dart';
import 'package:ltc/core/theme/app_spacing.dart';

class _NavItemData {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItemData({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class BottomNavShell extends ConsumerWidget {
  const BottomNavShell({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavProvider);
    final tr = ref.watch(stringsProvider);
    final md = MediaQuery.of(context);

    final items = [
      _NavItemData(
        icon: FontAwesomeIcons.house,
        activeIcon: FontAwesomeIcons.solidHouse,
        label: tr.home,
      ),
      _NavItemData(
        icon: FontAwesomeIcons.heart,
        activeIcon: FontAwesomeIcons.solidHeart,
        label: tr.health,
      ),
      _NavItemData(
        icon: FontAwesomeIcons.file,
        activeIcon: FontAwesomeIcons.solidFileLines,
        label: tr.document,
      ),
      _NavItemData(
        icon: FontAwesomeIcons.user,
        activeIcon: FontAwesomeIcons.solidUser,
        label: tr.profile,
      ),
    ];

    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, md.padding.bottom),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.radiusXl),
          topRight: Radius.circular(AppSpacing.radiusXl),
        ),
        color: Colors.white,
        boxShadow: context.colorScheme.softShadow,
      ),
      child: Row(
        spacing: 5,
        children: List.generate(items.length, (index) {
          final item = items[index];

          return _buildNavItem(
            icon: item.icon,
            activeIcon: item.activeIcon,
            label: item.label,
            isSelected: currentIndex == index,
            onTap: () => _onTap(ref, index),
            context: context,
          );
        }),
      ),
    );
  }

  void _onTap(WidgetRef ref, int index) {
    ref.read(bottomNavProvider.notifier).changeTab(index);
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    final color = isSelected
        ? context.colorScheme.primary
        : context.colorScheme.onSurface.withOpacity(0.6);

    return Expanded(
      child: SplashTapWidget(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? context.colorScheme.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(isSelected ? activeIcon : icon, color: color, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: context.textTheme.labelSmall!.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
