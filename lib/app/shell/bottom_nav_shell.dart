import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltc/app/shell/bottom_nav_provider.dart';
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
        label: tr.lookup,
      ),
      _NavItemData(
        icon: FontAwesomeIcons.user,
        activeIcon: FontAwesomeIcons.solidUser,
        label: tr.profile,
      ),
    ];

    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(AppSpacing.radiusXl),
      topRight: Radius.circular(AppSpacing.radiusXl),
    );

    return PhysicalShape(
      color: context.colorScheme.surface,
      clipper: ShapeBorderClipper(
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
      ),
      elevation: 12,
      shadowColor: context.colorScheme.shadow,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 10, 16, md.padding.bottom + 4),
        child: Row(
          spacing: 5,
          children: List.generate(items.length, (index) {
            final item = items[index];
            return _NavItem(
              icon: item.icon,
              activeIcon: item.activeIcon,
              label: item.label,
              isSelected: currentIndex == index,
              onTap: () =>
                  ref.read(bottomNavProvider.notifier).changeTab(index),
            );
          }),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// NAV ITEM
// ─────────────────────────────────────────────

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  static const _duration = Duration(milliseconds: 100);
  static const _curve = Curves.easeInOut;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    final activeColor = cs.primary;
    final inactiveColor = cs.onSurfaceVariant;
    final activeBg = cs.surfaceContainerHigh;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: TweenAnimationBuilder<Color?>(
          tween: ColorTween(
            begin: isSelected ? inactiveColor : activeColor,
            end: isSelected ? activeColor : inactiveColor,
          ),
          duration: _duration,
          curve: _curve,
          builder: (context, fgColor, _) {
            final resolvedFg = fgColor ?? inactiveColor;

            // TweenAnimationBuilder cho màu nền
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 7),
              decoration: BoxDecoration(
                color: isSelected ? activeBg : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon: scale transition khi đổi icon active/inactive
                  AnimatedSwitcher(
                    duration: _duration,
                    switchInCurve: _curve,
                    switchOutCurve: _curve,
                    transitionBuilder: (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                    child: Icon(
                      isSelected ? activeIcon : icon,
                      key: ValueKey(isSelected),
                      color: resolvedFg,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Text: animate color + fontWeight
                  AnimatedDefaultTextStyle(
                    duration: _duration,
                    curve: _curve,
                    style: tt.labelSmall!.copyWith(
                      color: resolvedFg,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                    child: Text(label),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
