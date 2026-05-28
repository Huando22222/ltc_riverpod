import 'package:flutter/material.dart';
import 'package:ltc/core/extensions/color_schema_ext.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/theme/app_spacing.dart';
import 'package:ltc/features/health/presentation/utils/health_overview_ui_models.dart';

class HealthScoreCard extends StatelessWidget {
  const HealthScoreCard({
    super.key,
    required this.signals,
    required this.bloodPressure,
  });

  final List<HealthSignalStatus> signals;
  final String? bloodPressure;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;
    final goodCount = signals.where((e) => e.isGood).length;
    final headline = signals.isEmpty
        ? 'Chưa đủ dữ liệu đánh giá'
        : goodCount == signals.length
            ? 'Các chỉ số chính đang ổn định'
            : 'Có chỉ số cần theo dõi thêm';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: cs.softShadow,
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: CircularProgressIndicator(
                  strokeWidth: 8,
                  value: signals.isEmpty ? .15 : goodCount / signals.length,
                  backgroundColor: cs.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                ),
              ),
              Icon(Icons.insights_outlined, color: cs.primary, size: 28),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headline,
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  bloodPressure == null
                      ? 'Kéo xuống để làm mới hoặc chọn khoảng ngày khác.'
                      : 'Huyết áp gần nhất: $bloodPressure mmHg',
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
