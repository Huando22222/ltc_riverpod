import 'package:flutter/material.dart';
import 'package:ltc/common/helper/modal_helper.dart';
import 'package:ltc/common/widgets/modal/date_modal_widget.dart';
import 'package:ltc/common/widgets/states/refresh_widget.dart';
import 'package:ltc/common/widgets/swipe/swiped_widget.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/theme/app_spacing.dart';
import 'package:ltc/features/health/presentation/utils/health_formatters.dart';

class HealthMetricPageScaffold extends StatelessWidget {
  const HealthMetricPageScaffold({
    super.key,
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.onAdd,
    required this.onRefresh,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onAdd;
  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surfaceContainerLow,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: context.colorScheme.surfaceContainerLow,
        surfaceTintColor: context.colorScheme.surfaceContainerLow,
        // actions: [
        //   IconButton(
        //     tooltip: 'Thêm chỉ số',
        //     onPressed: onAdd,
        //     icon: const Icon(Icons.add_rounded),
        //   ),
        // ],
      ),
      body: RefreshWidget(
        onRefresh: onRefresh,
        childIsScrollable: true,
        child: child,
      ),
      // body: RefreshIndicator(onRefresh: onRefresh, child: child),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: accentColor,
        foregroundColor: context.colorScheme.onPrimary,
        onPressed: onAdd,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Thêm'),
      ),
    );
  }
}

class HealthMetricHeroCard extends StatelessWidget {
  const HealthMetricHeroCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.accentColor,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color accentColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: context.softShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(icon, color: accentColor, size: 28),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: context.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.sm),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class HealthInfoTile extends StatelessWidget {
  const HealthInfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            value,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class HealthHistoryCard extends StatelessWidget {
  const HealthHistoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.children,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: context.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (children.isEmpty)
            Text(
              'Chưa có dữ liệu trong khoảng hiện tại.',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            )
          else
            Column(children: children),
        ],
      ),
    );
  }
}

class HealthHistoryItem extends StatelessWidget {
  const HealthHistoryItem({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.date,
    this.leading,
    this.onDelete,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final DateTime date;
  final Widget? leading;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          leading ?? Icon(icon, color: color),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  subtitle,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            HealthFormatters.shortDate(date),
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );

    if (onDelete == null) return content;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: SwipedWidget(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        actions: [
          SwipedActionWidget(
            color: context.colorScheme.error,
            onTap: onDelete!,
            child: Icon(
              Icons.delete_outline,
              color: context.colorScheme.onError,
            ),
          ),
        ],
        child: content,
      ),
    );
  }
}

class MetricSheetContainer extends StatelessWidget {
  const MetricSheetContainer({
    super.key,
    required this.title,
    required this.children,
    required this.onSave,
    required this.saving,
  });

  final String title;
  final List<Widget> children;
  final VoidCallback? onSave;
  final bool saving;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.md,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ...children,
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: saving ? null : onSave,
                child: Text(saving ? 'Đang lưu...' : 'Lưu chỉ số'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MetricDateTimeTile extends StatelessWidget {
  const MetricDateTimeTile({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(
        '${HealthFormatters.time(value)} · ${HealthFormatters.date(value)}',
      ),
      trailing: const Icon(Icons.edit_calendar_outlined),
      onTap: () async {
        final pickedDate = await ModalHelper.dateModal(
          context: context,
          currentDateRange: [value, value],
          filterType: FilterType.day,
          onlyPickOne: true,
          maxDate: DateTime.now(),
          minDate: DateTime.now().subtract(Duration(days: 365)),
        );
        final date = pickedDate?.first;
        if (date == null || !context.mounted) return;

        final time = await ModalHelper.pickTime(
          context: context,
          initialTime: TimeOfDay.fromDateTime(value),
        );
        if (time == null) return;

        onChanged(
          DateTime(date.year, date.month, date.day, time.hour, time.minute),
        );
      },
    );
  }
}

Widget metricNumberField(
  TextEditingController controller,
  String label,
  String suffix, {
  bool required = true,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label, suffixText: suffix),
      validator: (value) {
        if (!required && (value == null || value.trim().isEmpty)) return null;
        if (value == null || value.trim().isEmpty) return 'Không được bỏ trống';
        if (double.tryParse(value.trim()) == null)
          return 'Giá trị không hợp lệ';
        return null;
      },
    ),
  );
}

Widget metricTextField(
  TextEditingController controller,
  String label, {
  bool required = false,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (!required) return null;
        return value == null || value.trim().isEmpty
            ? 'Không được bỏ trống'
            : null;
      },
    ),
  );
}

String? nullableText(TextEditingController controller) {
  final value = controller.text.trim();
  return value.isEmpty ? null : value;
}

double? nullableDouble(TextEditingController controller) {
  final value = controller.text.trim();
  return value.isEmpty ? null : double.tryParse(value);
}

double metricDecimalInput(
  TextEditingController controller, {
  double? scaleWhenGreaterThan,
  double scale = 10,
}) {
  final raw = double.parse(controller.text.trim());
  if (scaleWhenGreaterThan != null && raw > scaleWhenGreaterThan) {
    return raw / scale;
  }
  return raw;
}

double metricPercentInput(TextEditingController controller) {
  final raw = double.parse(controller.text.trim());
  if (raw > 100 && raw <= 10000) return raw / 100;
  return raw;
}

double metricCmInput(TextEditingController controller) {
  return metricDecimalInput(controller, scaleWhenGreaterThan: 300, scale: 10);
}

double metricKgInput(TextEditingController controller) {
  return metricDecimalInput(controller, scaleWhenGreaterThan: 300, scale: 10);
}
