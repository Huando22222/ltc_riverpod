import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltc/common/widgets/images/asset_image_widget.dart';
import 'package:ltc/common/widgets/text_fields/input_field_widget.dart';
import 'package:ltc/core/config/routes.dart';
import 'package:ltc/core/constants/image_path_constants.dart';
import 'package:ltc/core/extensions/color_schema_ext.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/helpers/in_app_notification_helper.dart';
import 'package:ltc/core/localization/locale_provider.dart';
import 'package:ltc/core/theme/app_spacing.dart';
import 'package:ltc/features/auth/presentation/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(stringsProvider);
    final size = MediaQuery.of(context).size;
    final logoSize = size.width * 0.28;
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            // ── Background ──────────────────────────────
            const _Background(),

            // ── Content ─────────────────────────────────
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
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
                      const Spacer(flex: 3),

                      // ── Logo + Title ─────────────────
                      Column(
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
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            child: AssetImageWidget(
                              assetPath: ImagePathConstants.logo,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            tr.appName,
                            style: tt.headlineMedium?.copyWith(
                              // ✅ onPrimary — text trên nền gradient primary
                              color: cs.onPrimary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            tr.appTagline,
                            style: tt.bodyMedium?.copyWith(
                              // ✅ onPrimary mờ hơn cho tagline
                              color: cs.onPrimary.withOpacity(0.75),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // ── Form card ────────────────────
                      TweenAnimationBuilder(
                        tween: Tween<double>(begin: 2, end: 1),
                        duration: const Duration(milliseconds: 550),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
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
                                  Text(
                                    tr.login,
                                    style: tt.titleLarge?.copyWith(
                                      color: cs.onSurface,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    tr.loginInstruction,
                                    style: tt.bodySmall?.copyWith(
                                      color: cs.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.lg),

                                  InputFieldWidget(
                                    controller: _usernameCtrl,
                                    label: tr.username,
                                    icon: Icons.person_outline_rounded,
                                  ),
                                  const SizedBox(height: AppSpacing.md),

                                  InputFieldWidget(
                                    controller: _passwordCtrl,
                                    label: tr.password,
                                    icon: Icons.lock_outline_rounded,
                                    isPassword: true,
                                  ),

                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppSpacing.sm,
                                          vertical: AppSpacing.xs,
                                        ),
                                      ),
                                      child: Text(
                                        tr.forgotPassword,
                                        style: tt.bodySmall?.copyWith(
                                          color: cs.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.md),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            final result = await ref
                                                .read(authProvider.notifier)
                                                .login(
                                                  username: _usernameCtrl.text,
                                                  password: _passwordCtrl.text,
                                                );

                                            if (!result) {
                                              InAppNotificationHelper.showError(
                                                context,
                                                message: 'k thành công',
                                              );
                                            } else {
                                              context.goNamed(RouteName.main);
                                            }
                                          },
                                          child: Text(tr.login),
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      _QrButton(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      const Spacer(flex: 1),

                      // ── Register row ─────────────────
                      // ✅ Nằm dưới curve → nền là surface → dùng onSurface
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tr.noAccountMessage,
                            style: tt.bodyMedium?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final result = await context
                                  .pushNamed<Map<String, dynamic>>(
                                    RouteName.register,
                                  );
                              if (result != null) {
                                _usernameCtrl.text = result['username'];
                                _passwordCtrl.text = result['password'];
                              }
                            },
                            child: Text(
                              tr.register,
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
                    ],
                  ),
                ),
              ),
            ),

            // ── Back button ──────────────────────────────
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: const EdgeInsets.only(top: 10, left: 20),
                  child: Material(
                    // ✅ onPrimary translucent — nút nằm trên nền gradient
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
                          // ✅ onPrimary — icon trên nền gradient
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

// ── QR Button ─────────────────────────────────────────────
class _QrButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          // ✅ primaryContainer — bg button phụ trên surface
          color: cs.primaryContainer,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // ✅ primary với opacity — halo effect
                color: cs.primary.withOpacity(0.12),
              ),
            ),
            Icon(
              Icons.qr_code_scanner_rounded,
              // ✅ onPrimaryContainer — icon trên primaryContainer
              color: cs.onPrimaryContainer,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Background ────────────────────────────────────────────
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
          // ✅ surface (#FFFFFF) — nền trắng rõ cho phần dưới form
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
    // Nền trắng toàn màn hình
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = bottomColor,
    );

    // Gradient primary phần trên
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 0.62);
    final paint = Paint()
      ..shader = context.colorScheme.primaryGradient.createShader(rect);

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.52)
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.62,
        size.width * 0.5,
        size.height * 0.58,
      )
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.54,
        0,
        size.height * 0.62,
      )
      ..close();

    canvas.drawPath(path, paint);

    // Decorative circles
    final circlePaint = Paint()
      ..color = primaryColor.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.08),
      size.width * 0.3,
      circlePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.25),
      size.width * 0.18,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _BackgroundPainter old) =>
      old.primaryColor != primaryColor || old.bottomColor != bottomColor;
}
