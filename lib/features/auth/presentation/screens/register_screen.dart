import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:ltc/common/widgets/form/field_error_widget.dart';
import 'package:ltc/common/widgets/images/asset_image_widget.dart';
import 'package:ltc/common/widgets/text_fields/input_field_widget.dart';
import 'package:ltc/core/constants/image_path_constants.dart';
import 'package:ltc/core/extensions/color_schema_ext.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/helpers/in_app_notification_helper.dart';
import 'package:ltc/core/localization/locale_provider.dart';
import 'package:ltc/core/theme/app_spacing.dart';
import 'package:ltc/features/auth/presentation/providers/register_provider.dart';

// ── Screen ────────────────────────────────────────────────────────────────────
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _usernameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final success = await ref
        .read(registerProvider.notifier)
        .register(roleId: ['USER']);

    if (!mounted) return;

    if (success) {
      InAppNotificationHelper.showSuccess(
        context,
        message: 'Đăng ký thành công!',
      );
      if (context.canPop()) {
        context.pop({
          'username': _usernameCtrl.text,
          'password': _passwordCtrl.text,
        });
      }
    } else {
      // Đọc message từ state thay vì hardcode
      final errorMessage = ref.read(registerProvider).errorMessage;
      InAppNotificationHelper.showError(
        context,
        message: errorMessage ?? 'Đăng ký không thành công',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(stringsProvider);
    final formState = ref.watch(registerProvider);
    final notifier = ref.read(registerProvider.notifier);
    final md = MediaQuery.of(context);
    final size = md.size;
    final logoSize = size.width * 0.22;
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            const _Background(),
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.only(top: md.padding.top),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: AppSpacing.xxl),

                      // ── Form card ────────────────────
                      TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0.92, end: 1),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) =>
                            Transform.scale(scale: value, child: child),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                          ),
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: cs.surface,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusXl,
                            ),
                            boxShadow: cs.softShadow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                spacing: AppSpacing.gapMd,
                                children: [
                                  Container(
                                    width: logoSize,
                                    height: logoSize,
                                    decoration: BoxDecoration(
                                      color: cs.surface,
                                      borderRadius: BorderRadius.circular(
                                        logoSize * 0.28,
                                      ),
                                      boxShadow: cs.softShadow,
                                    ),
                                    padding: const EdgeInsets.all(
                                      AppSpacing.xs,
                                    ),
                                    child: AssetImageWidget(
                                      assetPath: ImagePathConstants.logo,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tr.register,
                                          style: tt.titleLarge?.copyWith(
                                            color: cs.onSurface,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: AppSpacing.xs),
                                        Text(
                                          'Tạo tài khoản để bắt đầu sử dụng',
                                          style: tt.bodySmall?.copyWith(
                                            color: cs.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              // Header
                              const SizedBox(height: AppSpacing.lg),

                              // ── Username ────────────
                              InputFieldWidget(
                                controller: _usernameCtrl,
                                label: tr.username,
                                icon: Icons.person_outline_rounded,
                                onChanged: notifier.onUsernameChanged,
                              ),
                              FieldErrorWidget(formState.usernameError),
                              const SizedBox(height: AppSpacing.md),

                              // ── Phone ───────────────
                              InputFieldWidget(
                                controller: _phoneCtrl,
                                label: 'Số điện thoại',
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                onChanged: notifier.onPhoneChanged,
                              ),
                              FieldErrorWidget(formState.phoneError),
                              const SizedBox(height: AppSpacing.md),

                              // ── Password ────────────
                              InputFieldWidget(
                                controller: _passwordCtrl,
                                label: tr.password,
                                icon: Icons.lock_outline_rounded,
                                isPassword: true,
                                onChanged: notifier.onPasswordChanged,
                              ),
                              FieldErrorWidget(formState.passwordError),
                              const SizedBox(height: AppSpacing.md),

                              // ── Confirm password ────
                              InputFieldWidget(
                                controller: _confirmPasswordCtrl,
                                label: 'Xác nhận mật khẩu',
                                icon: Icons.lock_reset_outlined,
                                isPassword: true,
                                onChanged: notifier.onConfirmPasswordChanged,
                              ),
                              FieldErrorWidget(formState.confirmPasswordError),
                              const SizedBox(height: AppSpacing.md),

                              // ── Email (optional) ────
                              InputFieldWidget(
                                controller: _emailCtrl,
                                label: 'Email (không bắt buộc)',
                                icon: Icons.mail_outline_rounded,
                                keyboardType: TextInputType.emailAddress,
                                onChanged: notifier.onEmailChanged,
                              ),
                              FieldErrorWidget(formState.emailError),
                              const SizedBox(height: AppSpacing.lg),

                              // ── Submit button ───────
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: formState.isSubmitting
                                      ? null
                                      : _onSubmit,
                                  child: formState.isSubmitting
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: cs.onPrimary,
                                          ),
                                        )
                                      : Text(tr.register),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(),

                      // ── Back to login ────────────────
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Đã có tài khoản?',
                              style: tt.bodyMedium?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                if (context.canPop()) context.pop();
                              },
                              child: Text(
                                tr.login,
                                style: tt.bodyMedium?.copyWith(
                                  color: cs.primary,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                  decorationColor: cs.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Back button (giống login) ────────────────
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: const EdgeInsets.only(top: 10, left: 20),
                  child: Material(
                    color: cs.onPrimary.withOpacity(0.15),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        if (context.canPop()) context.pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          FontAwesomeIcons.angleLeft,
                          color: cs.onPrimary,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Background (copy từ LoginScreen) ─────────────────────────────────────────
class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cs = context.colorScheme;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: CustomPaint(
        painter: _BackgroundPainter(
          context: context,
          primaryColor: cs.primary,
          bottomColor: cs.surface,
        ),
      ),
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  final Color primaryColor;
  final Color bottomColor;
  final BuildContext context;

  const _BackgroundPainter({
    required this.context,
    required this.primaryColor,
    required this.bottomColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = bottomColor,
    );

    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 0.45);
    final paint = Paint()
      ..shader = context.colorScheme.primaryGradient.createShader(rect);

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.35)
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.45,
        size.width * 0.5,
        size.height * 0.41,
      )
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.37,
        0,
        size.height * 0.43,
      )
      ..close();

    canvas.drawPath(path, paint);

    final circlePaint = Paint()
      ..color = primaryColor.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.06),
      size.width * 0.28,
      circlePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.18),
      size.width * 0.15,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _BackgroundPainter old) =>
      old.primaryColor != primaryColor || old.bottomColor != bottomColor;
}
