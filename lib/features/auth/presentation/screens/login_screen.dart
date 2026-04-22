import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltc/common/widgets/buttons/primary_button_widget.dart';
import 'package:ltc/common/widgets/images/asset_image_widget.dart';
import 'package:ltc/common/widgets/text_fields/input_field_widget.dart';
import 'package:ltc/core/constants/image_path_constants.dart';
import 'package:ltc/core/extensions/color_schema_ext.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/localization/locale_provider.dart';
import 'package:ltc/core/theme/app_colors.dart';
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
  void initState() {
    super.initState();
  }

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

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            // ── Background ──────────────────────────────
            const _Background(),
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(top: 10, left: 20),
                  child: Material(
                    color: context.colorScheme.surface.withAlpha(100),
                    shape: CircleBorder(),
                    child: InkWell(
                      customBorder: CircleBorder(),
                      onTap: () {
                        if (context.canPop()) {
                          context.pop();
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          FontAwesomeIcons.angleLeft,
                          color: context.colorScheme.surface,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
                      // ── Back button ──────────────────
                      const Spacer(flex: 3),

                      // ── Logo + Title ─────────────────
                      Column(
                        children: [
                          // Logo
                          Container(
                            width: logoSize,
                            height: logoSize,
                            decoration: BoxDecoration(
                              color: context.colorScheme.surface,
                              borderRadius: BorderRadius.circular(
                                logoSize * 0.28,
                              ),
                              boxShadow: context.colorScheme.softShadow,
                            ),
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            child: AssetImageWidget(
                              assetPath: ImagePathConstants.logo,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          // App name
                          Text(
                            tr.appName,
                            style: context.textTheme.headlineMedium?.copyWith(
                              color: context.colorScheme.surface,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            tr.appTagline,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.colorScheme.surface.withOpacity(
                                0.8,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // ── Form card ────────────────────
                      TweenAnimationBuilder(
                        tween: Tween<double>(begin: 2, end: 1),
                        duration: Duration(milliseconds: 550),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: double.parse(value.toString()),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                              ),
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              decoration: BoxDecoration(
                                color: context.colorScheme.surface,
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusXl,
                                ),
                                boxShadow: context.colorScheme.softShadow,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header
                                  Text(
                                    tr.authLogin,
                                    style: context.textTheme.titleLarge
                                        ?.copyWith(
                                          color: context.colorScheme.onSurface,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    tr.authLoginInstruction,
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(
                                          color: context
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                  ),
                                  const SizedBox(height: AppSpacing.lg),

                                  // Username
                                  InputFieldWidget(
                                    controller: _usernameCtrl,
                                    label: tr.authUsername,
                                    icon: Icons.person_outline_rounded,
                                  ),
                                  const SizedBox(height: AppSpacing.md),

                                  // Password
                                  InputFieldWidget(
                                    controller: _passwordCtrl,
                                    label: tr.authPassword,
                                    icon: Icons.lock_outline_rounded,
                                    isPassword: true,
                                  ),

                                  // Forgot password
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
                                        tr.authForgotPassword,
                                        style: context.textTheme.bodySmall
                                            ?.copyWith(
                                              color:
                                                  context.colorScheme.primary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.md),

                                  // Action row
                                  Row(
                                    children: [
                                      // Login button
                                      Expanded(
                                        child: PrimaryButtonWidget(
                                          isEnabled: true,
                                          title: tr.authLogin,
                                          onPressed: () async {
                                            await ref
                                                .read(authProvider.notifier)
                                                .login(
                                                  username: _usernameCtrl.text,
                                                  password: _passwordCtrl.text,
                                                );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.sm),

                                      // QR button
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tr.authNoAccountMessage,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              tr.authRegister,
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: context.colorScheme.primary,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                                decorationColor: context.colorScheme.primary,
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
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          color: context.colorScheme.primaryContainer,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colorScheme.primary.withOpacity(0.15),
              ),
            ),
            Icon(
              Icons.qr_code_scanner_rounded,
              color: context.colorScheme.primary,
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

    return SizedBox(
      width: size.width,
      height: size.height,
      child: CustomPaint(
        painter: _BackgroundPainter(
          context: context,
          topColor: context.colorScheme.primary,
          bottomColor: context.colorScheme.surfaceContainerLow,
        ),
      ),
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  final Color topColor;
  final Color bottomColor;
  final BuildContext context;
  const _BackgroundPainter({
    required this.context,
    required this.topColor,
    required this.bottomColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = bottomColor,
    );

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

    final circlePaint = Paint()
      ..color = context.colorScheme.primary.withOpacity(0.06)
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
      old.topColor != topColor || old.bottomColor != bottomColor;
}
