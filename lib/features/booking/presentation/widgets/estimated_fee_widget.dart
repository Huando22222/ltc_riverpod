// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ltc/common/util/currency_util.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/localization/locale_provider.dart';

class EstimatedFeeWidget extends ConsumerWidget {
  final double total;
  const EstimatedFeeWidget({super.key, required this.total});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = ref.watch(stringsProvider);
    final tt = context.textTheme;
    final cs = context.colorScheme;
    return Column(
      children: [
        const SizedBox(height: 4),
        Divider(color: cs.outlineVariant, height: 1),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tr.estimatedFee,
              style: tt.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
            Text(
              CurrencyUtil.formatPrice(total),

              style: tt.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
