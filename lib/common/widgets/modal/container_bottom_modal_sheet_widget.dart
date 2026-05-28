import 'package:flutter/material.dart';
import 'package:ltc/core/extensions/context_ext.dart';

class ContainerBottomModalSheetWidget extends StatelessWidget {
  final EdgeInsets padding;

  ///[height] general height is 380
  final double? height;

  final Widget child;
  const ContainerBottomModalSheetWidget({
    super.key,
    this.padding = const EdgeInsets.only(left: 20, right: 20, top: 0),
    this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final md = MediaQuery.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        padding: padding.copyWith(bottom: md.padding.bottom + 5),
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 12, bottom: 8),
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: cs.outlineVariant, //cs.onSurface,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            if (height == null) child else Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
