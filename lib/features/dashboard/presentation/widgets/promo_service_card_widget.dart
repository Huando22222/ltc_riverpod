import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltc/common/widgets/images/network_image_widget.dart';
import 'package:ltc/core/extensions/color_schema_ext.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/extensions/double_extention.dart';
import 'package:ltc/core/theme/app_spacing.dart';
import 'package:ltc/features/dashboard/domain/entities/service_dashboard_entity.dart';

class PromoServiceCardWidget extends StatelessWidget {
  final ServiceDashboardEntity service;
  final VoidCallback onTap;
  const PromoServiceCardWidget({
    super.key,
    required this.service,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: context.colorScheme.softShadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  NetworkImageWidget(url: service.image, fit: BoxFit.cover),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: context.colorScheme.imageOverlayGradient,
                      ),
                    ),
                  ),

                  Positioned(
                    left: AppSpacing.sm,
                    bottom: AppSpacing.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusFull,
                        ),
                      ),
                      child: Text(
                        service.price.formatCurrency,
                        style: context.textTheme.labelSmall?.copyWith(
                          color: context.colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      service.title,
                      style: context.textTheme.labelMedium?.copyWith(
                        color: context.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.locationDot,
                          size: 10,
                          color: context.colorScheme.secondary,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            service.clinicName,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.secondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
