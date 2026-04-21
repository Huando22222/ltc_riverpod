import 'package:flutter/material.dart';

///[RefreshWidget] if this widget not stand alone , you MUST wrap it with [Expanded]
class RefreshWidget extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final bool childIsScrollable;
  final Widget child;

  const RefreshWidget({
    super.key,
    required this.onRefresh,
    this.childIsScrollable = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final Widget buildChild;

    if (childIsScrollable) {
      buildChild = this.child;
    } else {
      buildChild = SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: this.child,
      );
    }

    return RefreshIndicator(
      backgroundColor: Colors.lightBlue,
      color: Colors.white,
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableHeight = constraints.maxHeight;
          return SizedBox(
            height: availableHeight,
            child: buildChild,
          );
        },
      ),
    );
  }
}
