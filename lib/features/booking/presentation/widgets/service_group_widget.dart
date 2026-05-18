import 'package:flutter/material.dart';
import 'package:ltc/common/util/currency_util.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/features/service/domain/entities/service_entity.dart';

class ServiceGroupWidget extends StatelessWidget {
  final String groupName;
  final List<ServiceEntity> services;

  const ServiceGroupWidget({
    super.key,
    required this.groupName,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group label
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 13,
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 7),
              Text(
                groupName,
                style: tt.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurfaceVariant,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${services.length}',
                  style: tt.labelSmall?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Service rows
        ...services.map(
          (s) => Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Icon(
                  Icons.check_circle_rounded,
                  size: 14,
                  color: cs.primary.withOpacity(0.7),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    s.serName,
                    style: tt.bodySmall?.copyWith(color: cs.onSurface),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  CurrencyUtil.formatPrice(s.serTotal),

                  style: tt.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
