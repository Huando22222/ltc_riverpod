import 'package:flutter/material.dart';
import 'package:ltc/common/widgets/wheel_widget.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/theme/app_spacing.dart';

class TimeModalWidget extends StatefulWidget {
  const TimeModalWidget({
    super.key,
    required this.initialTime,
    required this.onChanged,
    required this.onClosed,
    this.minuteStep = 1,
  });

  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onChanged;
  final ValueChanged<TimeOfDay> onClosed;
  final int minuteStep;

  @override
  State<TimeModalWidget> createState() => _TimeModalWidgetState();
}

class _TimeModalWidgetState extends State<TimeModalWidget> {
  late final List<int> _hours;
  late final List<int> _minutes;
  late int _hour;
  late int _minute;
  late FixedExtentScrollController _hourCtrl;
  late FixedExtentScrollController _minuteCtrl;

  @override
  void initState() {
    super.initState();
    _hours = List.generate(24, (index) => index);
    _minutes = List.generate(60 ~/ widget.minuteStep, (index) {
      return index * widget.minuteStep;
    });
    _hour = widget.initialTime.hour;
    _minute = _nearestMinute(widget.initialTime.minute);
    _hourCtrl = FixedExtentScrollController(initialItem: _hour);
    _minuteCtrl = FixedExtentScrollController(
      initialItem: _minutes.indexOf(_minute).clamp(0, _minutes.length - 1),
    );
  }

  @override
  void dispose() {
    _hourCtrl.dispose();
    _minuteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 48),
            Expanded(
              child: Text(
                'Chọn giờ',
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(onPressed: _close, child: const Text('Xong')),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: WheelWidget(
                controller: _hourCtrl,
                items: _hours
                    .map((hour) => Text(hour.toString().padLeft(2, '0')))
                    .toList(),
                onSelectedChanged: (index) {
                  _hour = _hours[index];
                  _notifyChanged();
                },
              ),
            ),
            Text(
              ':',
              style: context.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            Expanded(
              child: WheelWidget(
                controller: _minuteCtrl,
                items: _minutes
                    .map((minute) => Text(minute.toString().padLeft(2, '0')))
                    .toList(),
                onSelectedChanged: (index) {
                  _minute = _minutes[index];
                  _notifyChanged();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  int _nearestMinute(int value) {
    final nearest = (value / widget.minuteStep).round() * widget.minuteStep;
    return nearest.clamp(0, 59).toInt();
  }

  void _notifyChanged() {
    widget.onChanged(TimeOfDay(hour: _hour, minute: _minute));
  }

  void _close() {
    final time = TimeOfDay(hour: _hour, minute: _minute);
    widget.onClosed(time);
    Navigator.pop(context, time);
  }
}
