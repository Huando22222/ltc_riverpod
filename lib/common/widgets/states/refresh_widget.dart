import 'package:flutter/material.dart';

/// [RefreshWidget]
///
/// Nếu widget này không standalone trong Column/Row
/// thì nên wrap bằng [Expanded].
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
    final cs = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final hasBoundedHeight = constraints.hasBoundedHeight;
        final buildChild = childIsScrollable
            ? child
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                child: hasBoundedHeight
                    ? ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: child,
                      )
                    : child,
              );

        return RefreshIndicator(
          elevation: 0,
          strokeWidth: 2.6,
          backgroundColor: cs.surface,
          color: cs.primary,
          onRefresh: onRefresh,
          child: buildChild,
        );
      },
    );
  }
}
