// app_bar_divider_widget.dart
import 'package:flutter/material.dart';
import 'package:ltc/core/extensions/context_ext.dart';

class AppBarDividerWidget extends StatelessWidget {
  const AppBarDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1,
      decoration: BoxDecoration(
        color: context.colorScheme.outline, // #E0E0E0 / #2A2A3E dark
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withOpacity(0.06),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }
}
