import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavigatorBarWidget extends ConsumerStatefulWidget {
  const BottomNavigatorBarWidget({super.key});

  @override
  ConsumerState<BottomNavigatorBarWidget> createState() =>
      _BottomNavigatorBarWidgetState();
}

class _BottomNavigatorBarWidgetState
    extends ConsumerState<BottomNavigatorBarWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
