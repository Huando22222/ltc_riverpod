import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:ltc/common/helper/modal_helper.dart';
import 'package:ltc/common/widgets/images/asset_image_widget.dart';
import 'package:ltc/common/widgets/splash_tap_widget.dart';
import 'package:ltc/core/config/routes.dart';
import 'package:ltc/core/constants/image_path_constants.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/extensions/widget_ref_ext.dart';
import 'package:ltc/core/localization/locale_provider.dart';
import 'package:ltc/core/theme/app_spacing.dart';
import 'package:ltc/features/auth/presentation/providers/auth_provider.dart';
import 'package:ltc/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:ltc/features/dashboard/presentation/widgets/banner_widget.dart';
import 'package:ltc/features/dashboard/presentation/widgets/content_card_widget.dart';
import 'package:ltc/features/dashboard/presentation/widgets/promo_service_card_widget.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(dashboardProvider.notifier).getDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(stringsProvider);
    final db = ref.watch(dashboardProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: context.colorScheme.surfaceContainerLow,
      body: CustomScrollView(
        slivers: [
          // ── AppBar ──────────────────────────────────
          SliverAppBar(
            floating: true,
            snap: true,
            pinned: false,
            backgroundColor: context.colorScheme.surfaceContainerLow,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            expandedHeight: 56,
            flexibleSpace: FlexibleSpaceBar(
              background: _DashboardHeader(),
              collapseMode: CollapseMode.pin,
            ),
          ),

          // ── Body ────────────────────────────────────
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: AppSpacing.sm),

              // Banner
              BannerWidget(
                items: db.slider
                    .map((e) => BannerItem(title: e.title, imageUrl: e.image))
                    .toList(),
              ),
              const SizedBox(height: AppSpacing.md),
              _QuickActionsGrid(),
              const SizedBox(height: AppSpacing.lg),

              _SectionHeader(title: tr.packages, trailing: tr.viewAll),
              const SizedBox(height: AppSpacing.sm),
              _HorizontalList(height: size.height * 0.2, items: db.package),

              const SizedBox(height: AppSpacing.lg),

              _SectionHeader(title: tr.testServices, trailing: tr.viewAll),
              const SizedBox(height: AppSpacing.sm),
              _HorizontalList(height: size.height * 0.2, items: db.test),

              const SizedBox(height: AppSpacing.lg),

              _SectionHeader(title: tr.medicalTopics),
              const SizedBox(height: AppSpacing.sm),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.horizontalPaddingScreen,
                ),
                child: Column(
                  children: db.medicalTopic
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: ContentCardWidget(item: e),
                        ),
                      )
                      .toList(),
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),
            ]),
          ),
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────
class _DashboardHeader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = ref.watch(stringsProvider);
    return Container(
      color: context.colorScheme.surfaceContainerLow,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      alignment: Alignment.bottomLeft,
      child: Row(
        children: [
          AssetImageWidget(
            assetPath: ImagePathConstants.logo,
            width: 36,
            height: 36,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              tr.appName,
              style: context.textTheme.titleLarge?.copyWith(
                color: context.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SplashTapWidget(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: Icon(
                FontAwesomeIcons.magnifyingGlass,
                size: 18,
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Header ────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.trailing,
    this.onTrailingTap,
  });

  final String title;
  final String? trailing;
  final VoidCallback? onTrailingTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.horizontalPaddingScreen,
      ),
      child: Row(
        children: [
          // Accent bar
          Container(
            width: 3,
            height: 18,
            margin: const EdgeInsets.only(right: AppSpacing.sm),
            decoration: BoxDecoration(
              color: context.colorScheme.primary,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (trailing != null)
            SplashTapWidget(
              onTap: onTrailingTap,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: 2,
                ),
                child: Row(
                  children: [
                    Text(
                      trailing!,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 10,
                      color: context.colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Horizontal List ───────────────────────────────────────
class _HorizontalList extends StatelessWidget {
  const _HorizontalList({required this.height, required this.items});

  final double height;
  final List items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.horizontalPaddingScreen,
          vertical: AppSpacing.xs,
        ),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) => AspectRatio(
          aspectRatio: 4 / 3,
          child: PromoServiceCardWidget(service: items[index], onTap: () {}),
        ),
      ),
    );
  }
}

class _QuickActionsGrid extends ConsumerWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = ref.watch(stringsProvider);
    final user = ref.watch(currentUserProvider);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.horizontalPaddingScreen,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.primary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.xs,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _QuickActionButton(
                    icon: FontAwesomeIcons.calendarCheck,
                    label: tr.booking,
                    onTap: () {
                      if (!ref.isAuthenticated(context)) return;
                      context.pushNamed(RouteName.serviceBooking);
                    },
                  ),
                ),
                Expanded(
                  child: _QuickActionButton(
                    onTap: () {
                      if (!ref.isAuthenticated(context)) return;
                      context.pushNamed(RouteName.specialtyBooking);
                    },
                    icon: FontAwesomeIcons.hospitalUser,
                    label: tr.specialty,
                  ),
                ),

                Expanded(
                  child: _QuickActionButton(
                    icon: FontAwesomeIcons.flask,
                    label: tr.labTest,
                  ),
                ),
                Expanded(
                  child: _QuickActionButton(
                    onTap: () {
                      if (!ref.isAuthenticated(context)) return;
                      context.pushNamed(RouteName.packageBooking);
                    },
                    icon: FontAwesomeIcons.layerGroup,
                    label: tr.package,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xs),

            Row(
              children: [
                Expanded(
                  child: _QuickActionButton(
                    icon: FontAwesomeIcons.pills,
                    label: tr.medication,
                  ),
                ),
                Expanded(
                  child: _QuickActionButton(
                    icon: FontAwesomeIcons.truckMedical,
                    label: tr.emergency,
                  ),
                ),
                Expanded(
                  child: _QuickActionButton(
                    icon: FontAwesomeIcons.fileWaveform,
                    label: tr.lookup,
                  ),
                ),
                Expanded(
                  child: _QuickActionButton(
                    icon: FontAwesomeIcons.commentMedical,
                    label: tr.consultation,
                  ),
                ),
                // Expanded(
                //   child: _QuickActionButton(
                //     icon: FontAwesomeIcons.ellipsis,
                //     label: tr.all,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Button ────────────────────────────────────────────────
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? bgColor;
  final Color? iconColor;
  final VoidCallback? onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    this.bgColor,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = this.iconColor ?? context.colorScheme.primary;
    final Color bgColor = this.bgColor ?? context.colorScheme.primaryContainer;

    return SplashTapWidget(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.xs,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: FaIcon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: context.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colorScheme.onSurface,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
