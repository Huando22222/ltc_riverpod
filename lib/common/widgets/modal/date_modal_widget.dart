import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ltc/common/widgets/wheel_widget.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/theme/app_spacing.dart';

enum FilterType { day, week, month, year, range }

class DateModalResult {
  const DateModalResult({required this.dateRange, required this.type});

  final List<DateTime> dateRange;
  final FilterType type;
}

class DateModalWidget extends StatefulWidget {
  const DateModalWidget({
    super.key,
    required this.currentDateRange,
    required this.filterType,
    required this.onChanged,
    required this.onClosed,
    this.onlyPickOne = false,
    this.minDate,
    this.maxDate,
  });

  final List<DateTime> currentDateRange;
  final FilterType filterType;
  final void Function({
    required List<DateTime> dateRange,
    required FilterType type,
  })
  onChanged;
  final void Function({
    required List<DateTime> dateRange,
    required FilterType type,
  })
  onClosed;
  final bool onlyPickOne;
  final DateTime? minDate;
  final DateTime? maxDate;

  @override
  State<DateModalWidget> createState() => _DateModalWidgetState();
}

class _DateModalWidgetState extends State<DateModalWidget> {
  late FilterType _selectedType;
  late DateTime _minDate;
  late DateTime _maxDate;
  late List<int> _years;

  late int _year;
  late int _month;
  late int _day;
  late int _week;

  late int _fromYear;
  late int _fromMonth;
  late int _fromDay;
  late int _toYear;
  late int _toMonth;
  late int _toDay;

  late List<int> _months;
  late List<int> _days;
  late List<int> _weeks;
  late List<int> _fromMonths;
  late List<int> _fromDays;
  late List<int> _toMonths;
  late List<int> _toDays;

  late FixedExtentScrollController _yearCtrl;
  late FixedExtentScrollController _monthCtrl;
  late FixedExtentScrollController _dayCtrl;
  late FixedExtentScrollController _weekCtrl;
  late FixedExtentScrollController _fromYearCtrl;
  late FixedExtentScrollController _fromMonthCtrl;
  late FixedExtentScrollController _fromDayCtrl;
  late FixedExtentScrollController _toYearCtrl;
  late FixedExtentScrollController _toMonthCtrl;
  late FixedExtentScrollController _toDayCtrl;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _selectedType = widget.onlyPickOne ? FilterType.day : widget.filterType;
    _minDate = widget.minDate ?? DateTime(now.year - 10, 1, 1);
    _maxDate = widget.maxDate ?? DateTime(now.year + 1, 12, 31);

    final range = _normalizeRange(widget.currentDateRange);
    final start = _clampDate(range.first);
    final end = _clampDate(range.last);

    _year = start.year;
    _month = start.month;
    _day = start.day;
    _week = weekOfYear(_selectedType == FilterType.week ? end : start);

    _fromYear = start.year;
    _fromMonth = start.month;
    _fromDay = start.day;
    _toYear = end.year;
    _toMonth = end.month;
    _toDay = end.day;

    _years = List.generate(
      _maxDate.year - _minDate.year + 1,
      (index) => _minDate.year + index,
    );

    _rebuildSingleLists();
    _rebuildRangeLists();

    _yearCtrl = _controllerFor(_years, _year);
    _monthCtrl = _controllerFor(_months, _month);
    _dayCtrl = _controllerFor(_days, _day);
    _weekCtrl = _controllerFor(_weeks, _week);
    _fromYearCtrl = _controllerFor(_years, _fromYear);
    _fromMonthCtrl = _controllerFor(_fromMonths, _fromMonth);
    _fromDayCtrl = _controllerFor(_fromDays, _fromDay);
    _toYearCtrl = _controllerFor(_years, _toYear);
    _toMonthCtrl = _controllerFor(_toMonths, _toMonth);
    _toDayCtrl = _controllerFor(_toDays, _toDay);
  }

  @override
  void dispose() {
    _yearCtrl.dispose();
    _monthCtrl.dispose();
    _dayCtrl.dispose();
    _weekCtrl.dispose();
    _fromYearCtrl.dispose();
    _fromMonthCtrl.dispose();
    _fromDayCtrl.dispose();
    _toYearCtrl.dispose();
    _toMonthCtrl.dispose();
    _toDayCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(onReset: _resetToToday, onDone: _close),
        if (!widget.onlyPickOne) ...[
          const SizedBox(height: AppSpacing.sm),
          _FilterTypeSelector(
            selectedType: _selectedType,
            onSelected: _changeType,
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: _selectedType == FilterType.range
              ? _buildRangePicker()
              : _buildSinglePicker(),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }

  Widget _buildSinglePicker() {
    return Row(
      key: ValueKey(_selectedType),
      children: [
        Expanded(
          child: WheelWidget(
            controller: _yearCtrl,
            items: _years.map((year) => Text('$year')).toList(),
            onSelectedChanged: (index) {
              _year = _years[index];
              _syncSingleAfterYearOrMonthChanged();
            },
          ),
        ),
        if (_selectedType == FilterType.day ||
            _selectedType == FilterType.month)
          Expanded(
            flex: 2,
            child: WheelWidget(
              controller: _monthCtrl,
              items: _months.map((month) => Text('Tháng $month')).toList(),
              onSelectedChanged: (index) {
                _month = _months[index];
                _syncSingleAfterYearOrMonthChanged();
              },
            ),
          ),
        if (_selectedType == FilterType.day)
          Expanded(
            flex: 2,
            child: WheelWidget(
              controller: _dayCtrl,
              items: _days.map((day) => Text('$day')).toList(),
              onSelectedChanged: (index) {
                _day = _days[index];
                _notifyChanged();
              },
            ),
          ),
        if (_selectedType == FilterType.week)
          Expanded(
            flex: 3,
            child: WheelWidget(
              controller: _weekCtrl,
              items: _weeks.map(_weekLabel).toList(),
              onSelectedChanged: (index) {
                _week = _weeks[index];
                _notifyChanged();
              },
            ),
          ),
      ],
    );
  }

  Widget _buildRangePicker() {
    return Column(
      key: const ValueKey(FilterType.range),
      children: [
        _RangeLabel(text: 'Từ ngày'),
        Row(
          children: [
            Expanded(
              child: WheelWidget(
                controller: _fromYearCtrl,
                items: _years.map((year) => Text('$year')).toList(),
                onSelectedChanged: (index) {
                  _fromYear = _years[index];
                  _ensureRangeOrder(fromChanged: true);
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: WheelWidget(
                controller: _fromMonthCtrl,
                items: _fromMonths
                    .map((month) => Text('Tháng $month'))
                    .toList(),
                onSelectedChanged: (index) {
                  _fromMonth = _fromMonths[index];
                  _ensureRangeOrder(fromChanged: true);
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: WheelWidget(
                controller: _fromDayCtrl,
                items: _fromDays.map((day) => Text('$day')).toList(),
                onSelectedChanged: (index) {
                  _fromDay = _fromDays[index];
                  _ensureRangeOrder(fromChanged: true);
                },
              ),
            ),
          ],
        ),
        const Divider(height: AppSpacing.lg),
        _RangeLabel(text: 'Đến ngày'),
        Row(
          children: [
            Expanded(
              child: WheelWidget(
                controller: _toYearCtrl,
                items: _years.map((year) => Text('$year')).toList(),
                onSelectedChanged: (index) {
                  _toYear = _years[index];
                  _ensureRangeOrder(fromChanged: false);
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: WheelWidget(
                controller: _toMonthCtrl,
                items: _toMonths.map((month) => Text('Tháng $month')).toList(),
                onSelectedChanged: (index) {
                  _toMonth = _toMonths[index];
                  _ensureRangeOrder(fromChanged: false);
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: WheelWidget(
                controller: _toDayCtrl,
                items: _toDays.map((day) => Text('$day')).toList(),
                onSelectedChanged: (index) {
                  _toDay = _toDays[index];
                  _ensureRangeOrder(fromChanged: false);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _changeType(FilterType type) {
    setState(() {
      if (_selectedType == FilterType.range && type != FilterType.range) {
        _year = _fromYear;
        _month = _fromMonth;
        _day = _fromDay;
        _week = weekOfYear(DateTime(_year, _month, _day));
      }

      if (type == FilterType.range && _selectedType != FilterType.range) {
        final range = _getDateRange();
        _fromYear = range.first.year;
        _fromMonth = range.first.month;
        _fromDay = range.first.day;
        _toYear = range.last.year;
        _toMonth = range.last.month;
        _toDay = range.last.day;
        _rebuildRangeLists();
        _syncRangeControllers();
      }

      _selectedType = type;
      _rebuildSingleLists();
      if (_selectedType == FilterType.week) {
        _week = weekOfYear(DateTime(_year, _month, _day));
        if (!_weeks.contains(_week)) _week = _weeks.last;
      }
      _syncSingleControllers();
      _notifyChanged();
    });
  }

  void _resetToToday() {
    final target = _clampDate(DateTime.now());
    setState(() {
      if (_selectedType == FilterType.range) {
        _fromYear = target.year;
        _fromMonth = target.month;
        _fromDay = 1;
        _toYear = target.year;
        _toMonth = target.month;
        _toDay = target.day;
        _rebuildRangeLists();
        _syncRangeControllers();
      } else {
        _year = target.year;
        _month = target.month;
        _day = target.day;
        _week = weekOfYear(target);
        _rebuildSingleLists();
        _syncSingleControllers();
      }
      _notifyChanged();
    });
  }

  void _syncSingleAfterYearOrMonthChanged() {
    setState(() {
      _rebuildSingleLists();
      if (!_months.contains(_month)) _month = _months.last;
      if (!_days.contains(_day)) _day = _days.last;
      if (!_weeks.contains(_week)) _week = _weeks.last;
      _syncSingleControllers(skipYear: true);
      _notifyChanged();
    });
  }

  void _ensureRangeOrder({required bool fromChanged}) {
    setState(() {
      _rebuildRangeLists();

      if (!_fromMonths.contains(_fromMonth)) _fromMonth = _fromMonths.last;
      if (!_fromDays.contains(_fromDay)) _fromDay = _fromDays.last;
      if (!_toMonths.contains(_toMonth)) _toMonth = _toMonths.first;
      if (!_toDays.contains(_toDay)) _toDay = _toDays.first;

      final from = DateTime(_fromYear, _fromMonth, _fromDay);
      final to = DateTime(_toYear, _toMonth, _toDay);
      if (from.isAfter(to)) {
        if (fromChanged) {
          _toYear = _fromYear;
          _toMonth = _fromMonth;
          _toDay = _fromDay;
        } else {
          _fromYear = _toYear;
          _fromMonth = _toMonth;
          _fromDay = _toDay;
        }
        _rebuildRangeLists();
      }

      _syncRangeControllers();
      _notifyChanged();
    });
  }

  void _rebuildSingleLists() {
    _months = _availableMonths(_year);
    _days = _availableDays(_year, _month);
    _weeks = _availableWeeks(_year);
  }

  void _rebuildRangeLists() {
    _fromMonths = _availableMonths(_fromYear);
    _fromDays = _availableDays(_fromYear, _fromMonth);
    _toMonths = _availableToMonths();
    _toDays = _availableToDays();
  }

  List<int> _availableMonths(int year) {
    final start = year == _minDate.year ? _minDate.month : 1;
    final end = year == _maxDate.year ? _maxDate.month : 12;
    return List.generate(end - start + 1, (index) => start + index);
  }

  List<int> _availableDays(int year, int month) {
    final maxDayInMonth = DateUtils.getDaysInMonth(year, month);
    final start = year == _minDate.year && month == _minDate.month
        ? _minDate.day
        : 1;
    final end = year == _maxDate.year && month == _maxDate.month
        ? _maxDate.day.clamp(1, maxDayInMonth).toInt()
        : maxDayInMonth;
    return List.generate(end - start + 1, (index) => start + index);
  }

  List<int> _availableWeeks(int year) {
    final total = weeksInYear(year);
    if (year == _maxDate.year) {
      return List.generate(
        weekOfYear(_maxDate).clamp(1, total).toInt(),
        (i) => i + 1,
      );
    }
    if (year == _minDate.year) {
      final minWeek = weekOfYear(_minDate);
      return List.generate(total - minWeek + 1, (i) => minWeek + i);
    }
    return List.generate(total, (i) => i + 1);
  }

  List<int> _availableToMonths() {
    final all = _availableMonths(_toYear);
    if (_toYear != _fromYear) return all;
    return all.where((month) => month >= _fromMonth).toList();
  }

  List<int> _availableToDays() {
    final all = _availableDays(_toYear, _toMonth);
    if (_toYear != _fromYear || _toMonth != _fromMonth) return all;
    return all.where((day) => day >= _fromDay).toList();
  }

  List<DateTime> _getDateRange() {
    switch (_selectedType) {
      case FilterType.day:
        final date = DateTime(_year, _month, _day);
        return [date, date];
      case FilterType.week:
        final start = firstDateOfWeek(_year, _week);
        final end = _clampDate(start.add(const Duration(days: 6)));
        return [_clampDate(start), end];
      case FilterType.month:
        final start = DateTime(_year, _month, 1);
        final end = DateTime(_year, _month + 1, 0);
        return [_clampDate(start), _clampDate(end)];
      case FilterType.year:
        final start = DateTime(_year, 1, 1);
        final end = DateTime(_year, 12, 31);
        return [_clampDate(start), _clampDate(end)];
      case FilterType.range:
        return [
          DateTime(_fromYear, _fromMonth, _fromDay),
          DateTime(_toYear, _toMonth, _toDay),
        ];
    }
  }

  void _notifyChanged() {
    widget.onChanged(dateRange: _getDateRange(), type: _selectedType);
  }

  void _close() {
    final result = _getDateRange();
    widget.onClosed(dateRange: result, type: _selectedType);
    Navigator.pop(
      context,
      DateModalResult(dateRange: result, type: _selectedType),
    );
  }

  void _syncSingleControllers({bool skipYear = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!skipYear) _jump(_yearCtrl, _years, _year);
      _jump(_monthCtrl, _months, _month);
      _jump(_dayCtrl, _days, _day);
      _jump(_weekCtrl, _weeks, _week);
    });
  }

  void _syncRangeControllers() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _jump(_fromYearCtrl, _years, _fromYear);
      _jump(_fromMonthCtrl, _fromMonths, _fromMonth);
      _jump(_fromDayCtrl, _fromDays, _fromDay);
      _jump(_toYearCtrl, _years, _toYear);
      _jump(_toMonthCtrl, _toMonths, _toMonth);
      _jump(_toDayCtrl, _toDays, _toDay);
    });
  }

  void _jump(
    FixedExtentScrollController controller,
    List<int> items,
    int value,
  ) {
    if (!controller.hasClients || items.isEmpty) return;
    controller.jumpToItem(
      items.indexOf(value).clamp(0, items.length - 1).toInt(),
    );
  }

  FixedExtentScrollController _controllerFor(List<int> items, int value) {
    return FixedExtentScrollController(
      initialItem: items.indexOf(value).clamp(0, items.length - 1).toInt(),
    );
  }

  DateTime _clampDate(DateTime date) {
    if (date.isBefore(_minDate)) return _minDate;
    if (date.isAfter(_maxDate)) return _maxDate;
    return date;
  }

  List<DateTime> _normalizeRange(List<DateTime> value) {
    if (value.isEmpty) {
      final now = DateTime.now();
      return [now, now];
    }
    if (value.length == 1) return [value.first, value.first];
    return [value.first, value[1]];
  }

  Widget _weekLabel(int week) {
    final start = firstDateOfWeek(_year, week);
    final end = _clampDate(start.add(const Duration(days: 6)));
    final formatter = DateFormat('dd/MM');
    return Text(
      '(T$week) ${formatter.format(start)} - ${formatter.format(end)}',
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onReset, required this.onDone});

  final VoidCallback onReset;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: 'Về hôm nay',
          onPressed: onReset,
          icon: const Icon(Icons.refresh_rounded),
        ),
        Expanded(
          child: Text(
            'Chọn thời gian',
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        TextButton(onPressed: onDone, child: const Text('Xong')),
      ],
    );
  }
}

class _FilterTypeSelector extends StatelessWidget {
  const _FilterTypeSelector({
    required this.selectedType,
    required this.onSelected,
  });

  final FilterType selectedType;
  final ValueChanged<FilterType> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      alignment: WrapAlignment.center,
      children: FilterType.values.map((type) {
        final selected = selectedType == type;
        return ChoiceChip(
          selected: selected,
          label: Text(_filterTypeLabel(type)),
          onSelected: (_) => onSelected(type),
          selectedColor: context.colorScheme.primaryContainer,
          labelStyle: TextStyle(
            color: selected
                ? context.colorScheme.onPrimaryContainer
                : context.colorScheme.onSurfaceVariant,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            side: BorderSide(color: context.colorScheme.outlineVariant),
          ),
        );
      }).toList(),
    );
  }
}

class _RangeLabel extends StatelessWidget {
  const _RangeLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.textTheme.labelLarge?.copyWith(
        color: context.colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

String _filterTypeLabel(FilterType type) {
  switch (type) {
    case FilterType.day:
      return 'Ngày';
    case FilterType.week:
      return 'Tuần';
    case FilterType.month:
      return 'Tháng';
    case FilterType.year:
      return 'Năm';
    case FilterType.range:
      return 'Khoảng';
  }
}

int weekOfYear(DateTime date) {
  final firstDay = DateTime(date.year, 1, 1);
  final daysOffset = firstDay.weekday - DateTime.monday;
  final firstMonday = firstDay.subtract(Duration(days: daysOffset));
  return ((date.difference(firstMonday).inDays) / 7).floor() + 1;
}

int weeksInYear(int year) {
  return weekOfYear(DateTime(year, 12, 31));
}

DateTime firstDateOfWeek(int year, int week) {
  final firstDay = DateTime(year, 1, 1);
  final daysOffset = firstDay.weekday - DateTime.monday;
  final firstMonday = firstDay.subtract(Duration(days: daysOffset));
  return firstMonday.add(Duration(days: (week - 1) * 7));
}
