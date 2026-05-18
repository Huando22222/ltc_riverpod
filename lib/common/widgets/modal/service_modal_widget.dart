import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltc/common/util/currency_util.dart';
import 'package:ltc/common/util/filter_util.dart';
import 'package:ltc/common/widgets/drop_down/drop_down_widget.dart';
import 'package:ltc/common/widgets/search_bar/search_bar_widget.dart';
import 'package:ltc/common/widgets/states/empty_data_widget.dart';
import 'package:ltc/core/extensions/color_schema_ext.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/theme/app_spacing.dart';
import 'package:ltc/features/service/domain/entities/service_entity.dart';

class ServiceModalWidget extends ConsumerStatefulWidget {
  final List<ServiceEntity> services;
  final List<ServiceEntity> selectedServices;
  final ValueChanged<List<ServiceEntity>>? onAdd;
  final ValueChanged<List<ServiceEntity>>? onRemove;
  final bool? isShowDropDown;
  const ServiceModalWidget({
    super.key,
    required this.services,
    this.selectedServices = const [],
    this.onAdd,
    this.onRemove,
    this.isShowDropDown,
  });

  @override
  ConsumerState<ServiceModalWidget> createState() => _ServiceModalWidgetState();
}

class _ServiceModalWidgetState extends ConsumerState<ServiceModalWidget> {
  late final TextEditingController _searchController;
  String _searchQuery = '';
  String _activeGroupName = _kAll;
  late List<ServiceEntity> _toAdd;
  late List<ServiceEntity> _toRemove;
  static const String _kAll = 'Tất cả';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _toAdd = [];
    _toRemove = [];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Helpers ──────────────────────────────────

  /// Danh sách tên nhóm duy nhất (dùng serGroupName vì DropDownWidget nhận String)
  List<String> get _groupNames {
    final seen = <String>{};
    final result = <String>[_kAll];
    for (final s in widget.services) {
      if (s.isActive && !s.isLogicDel && seen.add(s.serGroupName)) {
        result.add(s.serGroupName);
      }
    }
    return result;
  }

  List<ServiceEntity> get _filtered {
    var list = widget.services
        .where((s) => s.isActive && !s.isLogicDel)
        .toList();

    if (_activeGroupName != _kAll) {
      list = list.where((s) => s.serGroupName == _activeGroupName).toList();
    }

    if (_searchQuery.isNotEmpty) {
      list = FilterUtil.filterData(
        list,
        _searchQuery,
        searchFields: (item) => [item.serName],
      );
    }

    // Khi "Tất cả" + không search → đưa đã chọn lên đầu
    if (_activeGroupName == _kAll && _searchQuery.isEmpty) {
      final selectedFirst = _currentSelected
          .where((sel) => list.any((s) => s.serId == sel.serId))
          .toList();
      final rest = list
          .where((s) => !_currentSelected.any((sel) => sel.serId == s.serId))
          .toList();
      return [...selectedFirst, ...rest];
    }

    return list;
  }

  bool _isSelected(ServiceEntity s) {
    final inOriginal = widget.selectedServices.any((e) => e.serId == s.serId);
    final removed = _toRemove.any((e) => e.serId == s.serId);
    final added = _toAdd.any((e) => e.serId == s.serId);
    return (inOriginal && !removed) || added;
  }

  void _toggle(ServiceEntity s) {
    setState(() {
      final inOriginal = widget.selectedServices.any((e) => e.serId == s.serId);
      if (_isSelected(s)) {
        if (inOriginal) {
          _toRemove.add(s);
        } else {
          _toAdd.removeWhere((e) => e.serId == s.serId);
        }
      } else {
        if (inOriginal) {
          _toRemove.removeWhere((e) => e.serId == s.serId);
        } else {
          _toAdd.add(s);
        }
      }
    });
  }

  // Computed final selection = original - removed + added
  List<ServiceEntity> get _currentSelected {
    return [
      ...widget.selectedServices.where(
        (s) => !_toRemove.any((r) => r.serId == s.serId),
      ),
      ..._toAdd,
    ];
  }

  double get _totalPrice =>
      _currentSelected.fold(0, (sum, s) => sum + s.serTotal);

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;
    final filtered = _filtered;

    return Column(
      spacing: 5,
      children: [
        // ── Dropdown nhóm dịch vụ ────────────
        if (widget.isShowDropDown ?? true)
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.horizontalPaddingScreen,
              right: AppSpacing.horizontalPaddingScreen,
            ),
            child: DropDownWidget(
              categories: _groupNames,
              selectedCategory: _activeGroupName,
              customIcons: const {'Tất cả': Icons.apps_rounded},
              onChanged: (v) {
                if (v != null) {
                  setState(() {
                    _activeGroupName = v;
                    _searchQuery = '';
                    _searchController.clear();
                  });
                }
              },
            ),
          ),

        // ── Search ───────────────────────────
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.horizontalPaddingScreen,
            right: AppSpacing.horizontalPaddingScreen,
          ),
          child: SearchBarWidget(
            controller: _searchController,
            hint: 'Tìm kiếm dịch vụ...',
            onChanged: (v) => setState(() {
              _searchQuery = v;
              if (v.isNotEmpty) _activeGroupName = _kAll;
            }),
            onSubmitted: (v) => setState(() {
              _searchQuery = v;
              if (v.isNotEmpty) _activeGroupName = _kAll;
            }),
          ),
        ),

        Expanded(
          child: filtered.isEmpty
              ? EmptyDataWidget()
              : Scrollbar(
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.horizontalPaddingScreen,
                      5,
                      AppSpacing.horizontalPaddingScreen,
                      5,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final service = filtered[i];
                      return _ServiceCard(
                        service: service,
                        isSelected: _isSelected(service),
                        showGroup: _activeGroupName == _kAll,
                        onTap: () => _toggle(service),
                      );
                    },
                  ),
                ),
        ),

        _BottomBar(
          selectedCount: _currentSelected.length,
          totalPrice: _totalPrice,
          onConfirm: (_toAdd.isEmpty && _toRemove.isEmpty)
              ? null
              : () {
                  widget.onAdd?.call(_toAdd);
                  widget.onRemove?.call(_toRemove);
                  Navigator.pop(context);
                },
        ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final ServiceEntity service;
  final bool isSelected;
  final bool showGroup;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.service,
    required this.isSelected,
    required this.showGroup,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.only(
            bottom: 8,
            top: 8,
            left: 12,
            right: 12,
          ),
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? cs.primary.withOpacity(0.35)
                  : cs.outlineVariant,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: cs.softShadow,
          ),
          child: Row(
            children: [
              // ── Leading gradient box ─────
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      cs.primary.withOpacity(0.18),
                      cs.primary.withOpacity(0.07),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: isSelected
                    ? Icon(
                        FontAwesomeIcons.circleCheck,
                        size: 18,
                        color: cs.primary,
                      )
                    : null,
              ),
              const SizedBox(width: 12),

              // ── Name / group / price ─────
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.serName,
                            style: tt.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: cs.onSurface,
                              height: 1.3,
                            ),
                          ),
                          if (showGroup) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: cs.primaryContainer,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: cs.primary.withOpacity(0.2),
                                  width: 0.5,
                                ),
                              ),
                              child: Text(
                                service.serGroupName,
                                style: tt.labelSmall?.copyWith(
                                  color: cs.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 4),
                          Text(
                            CurrencyUtil.formatPrice(service.serTotal),
                            style: tt.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // ── +/- button ──────────
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isSelected
                            ? FontAwesomeIcons.minus
                            : FontAwesomeIcons.plus,
                        size: 14,
                        color: isSelected ? cs.error : cs.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BOTTOM BAR
// ─────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final int selectedCount;
  final double totalPrice;
  final VoidCallback? onConfirm;

  const _BottomBar({
    required this.selectedCount,
    required this.totalPrice,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;
    final md = MediaQuery.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedCount == 0
                      ? 'Chưa chọn dịch vụ'
                      : '$selectedCount dịch vụ',
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
                if (selectedCount > 0) ...[
                  const SizedBox(height: 2),
                  Text(
                    CurrencyUtil.formatPrice(totalPrice),
                    style: tt.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(minimumSize: const Size(130, 46)),
            child: Text('Xác nhận'),
          ),
        ],
      ),
    );
  }
}
