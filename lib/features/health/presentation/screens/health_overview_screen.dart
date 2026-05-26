import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/common/widgets/header/header_widget.dart';
import 'package:ltc/core/localization/locale_provider.dart';

class HealthScreen extends ConsumerStatefulWidget {
  const HealthScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HealthScreenState();
}

class _HealthScreenState extends ConsumerState<HealthScreen> {
  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(stringsProvider);
    final md = MediaQuery.of(context);
    return Column(
      children: [
        SizedBox(height: md.padding.top),
        HeaderWidget(title: tr.health),
      ],
    );
  }
}
