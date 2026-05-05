import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:ltc/core/config/routes.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/localization/locale_provider.dart';
import 'package:ltc/core/theme/app_spacing.dart';

class LoginRequiredWidget extends ConsumerWidget {
  final String? featureName;

  const LoginRequiredWidget({super.key, this.featureName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.colorScheme;
    final tt = context.textTheme;
    final tr = ref.watch(stringsProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: cs.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(FontAwesomeIcons.userLock, color: cs.primary, size: 28),
        ),

        // ── Title ────────────────────────
        Text(
          tr.loginRequiredTitle,
          style: tt.titleLarge?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),

        // ── Subtitle ─────────────────────
        Text(
          tr.loginRequiredSubtitle(featureName),
          style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),

        // ── Benefits ─────────────────────
        _BenefitRow(
          icon: FontAwesomeIcons.calendarCheck,
          text: tr.benefitBooking,
        ),
        const SizedBox(height: 10),
        _BenefitRow(
          icon: FontAwesomeIcons.clipboard,
          text: tr.benefitHealthRecord,
        ),
        const SizedBox(height: 10),
        _BenefitRow(icon: FontAwesomeIcons.grip, text: tr.benefitMore),
        const SizedBox(height: 28),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              context.pushNamed(RouteName.login);
            },
            child: Text(tr.loginNow),
          ),
        ),
        const SizedBox(height: 10),

        // ── CTA: Đăng ký ─────────────────
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {},
            child: Text(tr.createAccount),
          ),
        ),
        const SizedBox(height: 10),

        // ── Bỏ qua ───────────────────────
        TextButton(
          onPressed: () {},
          child: Text(
            tr.skipContinue,
            style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// BENEFIT ROW
// ─────────────────────────────────────────────

class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _BenefitRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: cs.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: cs.primary, size: 15),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: tt.bodySmall?.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
