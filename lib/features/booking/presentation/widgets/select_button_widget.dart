import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/localization/locale_provider.dart';

class SelectButtonWidget extends ConsumerWidget {
  final bool hasSelected;
  final bool isLoading;
  final VoidCallback onTap;

  const SelectButtonWidget({
    super.key,
    required this.hasSelected,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.colorScheme;
    final tt = context.textTheme;
    final tr = ref.watch(stringsProvider);
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasSelected
                ? cs.primary.withOpacity(0.4)
                : cs.outlineVariant,
            width: hasSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              hasSelected
                  ? FontAwesomeIcons.penToSquare
                  : FontAwesomeIcons.plus,
              size: 14,
              color: hasSelected ? cs.primary : cs.onSurfaceVariant,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                hasSelected ? tr.editService : tr.pickService,
                style: tt.bodySmall?.copyWith(
                  color: hasSelected ? cs.primary : cs.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isLoading)
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: cs.primary,
                ),
              )
            else
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: hasSelected ? cs.primary : cs.outlineVariant,
              ),
          ],
        ),
      ),
    );
  }
}
