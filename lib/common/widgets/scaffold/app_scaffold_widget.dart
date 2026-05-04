import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:ltc/common/widgets/dividers/app_bar_divider_widget.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/theme/app_spacing.dart';

class AppScaffoldWidget extends StatelessWidget {
  final String title;
  final bool isShowBack;
  final VoidCallback? onBack;
  final Widget child;
  const AppScaffoldWidget({
    super.key,
    required this.title,
    this.isShowBack = true,
    this.onBack,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final md = MediaQuery.of(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: md.padding.top),
        child: Column(
          spacing: 5,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.horizontalPaddingScreen,
              ),
              child: Row(
                spacing: 20,
                children: [
                  GestureDetector(
                    onTap:
                        onBack ??
                        () {
                          context.pop();
                        },
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        FontAwesomeIcons.arrowLeft,
                        color: context.colorScheme.primary,
                        size: AppSpacing.iconMd,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: context.textTheme.headlineSmall!.copyWith(
                        color: context.colorScheme.primary,
                      ),
                    ),
                  ),
                  // AvatarWidget(borderRadius: 500, showBorder: true),
                ],
              ),
            ),
            AppBarDividerWidget(),
            child,
          ],
        ),
      ),
    );
  }
}
