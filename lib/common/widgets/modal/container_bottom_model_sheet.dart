import 'package:flutter/material.dart';

class ContainerBottomModelSheet extends StatelessWidget {
  final EdgeInsets padding;

  ///[height] general height is 380
  final double? height;

  final Widget child;
  const ContainerBottomModelSheet({
    super.key,
    this.padding = const EdgeInsets.only(left: 20, right: 20, top: 0),
    this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        padding: padding.copyWith(
          bottom: MediaQuery.of(context).padding.bottom + 5,
        ),
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
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
                color: Color(0xFF1469AE).withOpacity(0.3),
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
