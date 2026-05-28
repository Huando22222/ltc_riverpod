import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:ltc/common/widgets/avatar/avatar_widget.dart';
import 'package:ltc/common/widgets/badge/icon_badge_widget.dart';
import 'package:ltc/common/widgets/dividers/section_divider.dart';
import 'package:ltc/common/widgets/header/header_widget.dart';
import 'package:ltc/common/widgets/size/animated_size_widget.dart';
import 'package:ltc/common/widgets/splash_tap_widget.dart';
import 'package:ltc/core/config/routes.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/extensions/string_ext.dart';
import 'package:ltc/core/localization/locale_provider.dart';
import 'package:ltc/core/theme/app_colors.dart';
import 'package:ltc/core/theme/app_spacing.dart';
import 'package:ltc/core/theme/theme_provider.dart';
import 'package:ltc/features/auth/presentation/providers/auth_provider.dart';
import 'package:ltc/features/auth/domain/entities/user_entity.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = ref.watch(stringsProvider);
    final auth = ref.watch(currentUserProvider);
    final md = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: context.colorScheme.surfaceContainerLow,
      body: Column(
        children: [
          SizedBox(height: md.padding.top),
          HeaderWidget(title: tr.setting, image: null),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  _ProfileCard(user: auth),
                  SizedBox(height: AppSpacing.gapMd),
                  _SettingSection(
                    icon: FontAwesomeIcons.solidUser,
                    color: context.colorScheme.primary,
                    title: tr.account,
                    items: [
                      _SettingItem(
                        icon: FontAwesomeIcons.solidIdCard,
                        color: context.colorScheme.primary,
                        label: tr.editProfile,
                        onTap: () {},
                      ),
                      _SettingItem(
                        icon: FontAwesomeIcons.lock,
                        color: AppColors.warning,
                        label: tr.changePassword,
                        onTap: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.gapMd),

                  // Cài đặt ứng dụng
                  _SettingSection(
                    icon: FontAwesomeIcons.gear,
                    color: AppColors.success,
                    title: tr.setting,
                    items: [
                      _SettingItem(
                        icon: FontAwesomeIcons.language,
                        color: AppColors.success,
                        label: tr.language,
                        trailing: _LanguageBadge(),
                        onTap: () =>
                            ref.read(localeProvider.notifier).toggleLocale(),
                      ),
                      const _ThemeModeSettingItem(),
                      _SettingItem(
                        icon: FontAwesomeIcons.bell,
                        color: AppColors.warning,
                        label: tr.notification,
                        onTap: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md),

                  // Hỗ trợ
                  _SettingSection(
                    icon: FontAwesomeIcons.circleQuestion,
                    color: context.colorScheme.tertiary,
                    title: tr.support,
                    items: [
                      _SettingItem(
                        icon: FontAwesomeIcons.headset,
                        color: context.colorScheme.tertiary,
                        label: tr.contactSupport,
                        onTap: () {},
                      ),
                      _SettingItem(
                        icon: FontAwesomeIcons.shieldHalved,
                        color: context.colorScheme.primary,
                        label: tr.privacyPolicy,
                        onTap: () {},
                      ),
                      _SettingItem(
                        icon: FontAwesomeIcons.fileLines,
                        color: AppColors.textSecondary,
                        label: tr.termOfUse,
                        onTap: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.gapLg),
                  // Logout
                  if (auth != null)
                    _LogoutButton(
                      label: tr.logout,
                      onTap: () async {
                        ref.read(authProvider.notifier).logout();
                      },
                    ),

                  SizedBox(height: AppSpacing.gapMd),
                  Text(
                    'v1.0.0',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),

                  SizedBox(height: md.padding.bottom + AppSpacing.md),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends ConsumerWidget {
  final UserEntity? user;
  const _ProfileCard({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: user != null ? _buildProfile(context) : _buildGuest(context),
    );
  }

  Widget _buildProfile(BuildContext context) {
    return Row(
      children: [
        AvatarWidget(
          size: 56,
          borderRadius: AppSpacing.radiusFull,
          initialLetter: user?.fullname,
          showBorder: true,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user!.fullname,
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (user!.email.isNotNullOrEmpty)
                Text(
                  user!.email,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              if (user?.phoneNumber != null &&
                  user!.phoneNumber.trim().isNotEmpty) ...[
                Text(
                  user!.phoneNumber,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        SplashTapWidget(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xs),
            child: Icon(
              FontAwesomeIcons.penToSquare,
              size: AppSpacing.iconMd,
              color: context.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuest(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final tr = ref.watch(stringsProvider);
        return SplashTapWidget(
          onTap: () => context.pushNamed(RouteName.login),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colorScheme.primaryContainer,
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: context.colorScheme.primary,
                  size: AppSpacing.iconXl,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr.loginToContinue,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: context.colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      tr.guestSubtitle,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: context.colorScheme.primary,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Setting Section ───────────────────────────────────────
class _SettingSection extends StatelessWidget {
  const _SettingSection({
    required this.icon,
    required this.color,
    required this.title,
    required this.items,
  });

  final IconData icon;
  final Color color;
  final String title;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Section title
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Row(
              children: [
                IconBadgeWidget(
                  icon: icon,
                  color: color,
                  size: AppSpacing.iconSm,
                  padding: AppSpacing.xs,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  title,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SectionDivider(margin: EdgeInsets.zero),

          Padding(
            padding: EdgeInsets.only(left: AppSpacing.xl),
            child: Column(
              children: [
                ...items.asMap().entries.map((entry) {
                  final isLast = entry.key == items.length - 1;
                  return Column(
                    children: [
                      entry.value,
                      if (!isLast)
                        Padding(
                          padding: const EdgeInsets.only(
                            left:
                                AppSpacing.md +
                                AppSpacing.iconSm +
                                AppSpacing.sm * 2,
                          ),
                          child: SectionDivider(margin: EdgeInsets.zero),
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Setting Item ──────────────────────────────────────────
class _SettingItem extends StatelessWidget {
  const _SettingItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SplashTapWidget(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 2,
        ),
        child: Row(
          children: [
            IconBadgeWidget(
              icon: icon,
              color: color,
              size: AppSpacing.iconSm,
              padding: AppSpacing.xs,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
            ),
            trailing ??
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 10,
                  color: context.colorScheme.onSurfaceVariant,
                ),
          ],
        ),
      ),
    );
  }
}

class _ThemeModeSettingItem extends ConsumerStatefulWidget {
  const _ThemeModeSettingItem();

  @override
  ConsumerState<_ThemeModeSettingItem> createState() =>
      _ThemeModeSettingItemState();
}

class _ThemeModeSettingItemState extends ConsumerState<_ThemeModeSettingItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider).value ?? ThemeMode.system;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SplashTapWidget(
            onTap: () {
              setState(() => _isExpanded = !_isExpanded);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  IconBadgeWidget(
                    icon: FontAwesomeIcons.circleHalfStroke,
                    color: context.colorScheme.primary,
                    size: AppSpacing.iconSm,
                    padding: AppSpacing.xs,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'Giao diện',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  _ThemeSummaryBadge(themeMode: themeMode),
                  const SizedBox(width: AppSpacing.sm),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 10,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSizeWidget(
            isExpanded: _isExpanded,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.xs,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: _ThemeModeSelector(
                selectedMode: themeMode,
                onChanged: (mode) {
                  ref.read(themeProvider.notifier).setTheme(mode);
                  setState(() => _isExpanded = false);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeModeSelector extends StatelessWidget {
  const _ThemeModeSelector({
    required this.selectedMode,
    required this.onChanged,
  });

  final ThemeMode selectedMode;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = [
      _ThemeModeOption(
        mode: ThemeMode.system,
        icon: FontAwesomeIcons.mobileScreenButton,
        label: 'Tự động',
      ),
      _ThemeModeOption(
        mode: ThemeMode.light,
        icon: FontAwesomeIcons.solidSun,
        label: 'Sáng',
      ),
      _ThemeModeOption(
        mode: ThemeMode.dark,
        icon: FontAwesomeIcons.solidMoon,
        label: 'Tối',
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withOpacity(0.55),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          for (final entry in options.asMap().entries) ...[
            _ThemeModeButton(
              option: entry.value,
              selected: selectedMode == entry.value.mode,
              onTap: () => onChanged(entry.value.mode),
            ),
            if (entry.key != options.length - 1)
              Padding(
                padding: const EdgeInsets.only(left: AppSpacing.xl),
                child: SectionDivider(
                  // color: context.colorScheme.outlineVariant.withOpacity(0.5),
                  margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _ThemeModeButton extends StatelessWidget {
  const _ThemeModeButton({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _ThemeModeOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selectedColor = context.colorScheme.primary;

    return SplashTapWidget(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected
              ? context.colorScheme.primaryContainer.withOpacity(0.5)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Row(
          children: [
            Icon(
              option.icon,
              size: AppSpacing.iconSm,
              color: selected
                  ? selectedColor
                  : context.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                option.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodySmall?.copyWith(
                  color: selected
                      ? selectedColor
                      : context.colorScheme.onSurfaceVariant,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            AnimatedScale(
              scale: selected ? 1 : 0.75,
              duration: const Duration(milliseconds: 160),
              child: Icon(
                selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                size: AppSpacing.iconSm,
                color: selected
                    ? selectedColor
                    : context.colorScheme.outlineVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeSummaryBadge extends StatelessWidget {
  const _ThemeSummaryBadge({required this.themeMode});

  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    final label = switch (themeMode) {
      ThemeMode.system => 'Tự động',
      ThemeMode.light => 'Sáng',
      ThemeMode.dark => 'Tối',
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: context.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ThemeModeOption {
  const _ThemeModeOption({
    required this.mode,
    required this.icon,
    required this.label,
  });

  final ThemeMode mode;
  final IconData icon;
  final String label;
}

// ── Language Badge ────────────────────────────────────────
class _LanguageBadge extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final isVi = locale.languageCode == 'vi';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        isVi ? '🇻🇳 VI' : '🇬🇧 EN',
        style: context.textTheme.labelSmall?.copyWith(
          color: context.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Logout Button ─────────────────────────────────────────
class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SplashTapWidget(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.errorLight,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.arrowRightFromBracket,
              size: AppSpacing.iconMd,
              color: AppColors.error,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: context.textTheme.labelLarge?.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
