// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ltc/common/widgets/avatar/avatar_widget.dart';
import 'package:ltc/common/widgets/dividers/app_bar_divider_widget.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/theme/app_spacing.dart';

class HeaderWidget extends ConsumerWidget {
  final String title;
  final String? image; // url
  const HeaderWidget({super.key, required this.title, required this.image});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      spacing: 5,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.horizontalPaddingScreen,
          ),
          child: Row(
            children: [
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
      ],
    );
  }
}
