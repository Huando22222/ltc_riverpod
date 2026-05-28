import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ltc/common/helper/dialog_helper.dart';
import 'package:ltc/common/widgets/modal/booking_data_modal_widget.dart';
import 'package:ltc/common/widgets/modal/container_bottom_modal_sheet_widget.dart';
import 'package:ltc/common/widgets/modal/date_modal_widget.dart';
import 'package:ltc/common/widgets/modal/detail_package_modal_widget.dart';
import 'package:ltc/common/widgets/modal/login_required_widget.dart';
import 'package:ltc/common/widgets/modal/service_modal_widget.dart';
import 'package:ltc/common/widgets/modal/time_modal_widget.dart';
import 'package:ltc/features/lookup/domain/entities/booking_data_entity.dart';
import 'package:ltc/features/service/domain/entities/package_entity.dart';
import 'package:ltc/features/service/domain/entities/service_entity.dart';

/// [PopupAction] use for [popup] to spread property
class PopupAction {
  final String title;
  final VoidCallback onPressed;
  final bool isDestructive;

  PopupAction({
    required this.title,
    required this.onPressed,
    this.isDestructive = false,
  });
}

class ModalHelper {
  static OverlayEntry? overlayLoading;
  // MARK: MODAL
  static Future<T?> modal<T>({
    required BuildContext context,
    bool isDismissible = true,
    double? height,
    required Widget child,
  }) async {
    return await showModalBottomSheet<T>(
      isDismissible: isDismissible,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ContainerBottomModalSheetWidget(height: height, child: child);
      },
    );
  }

  static Future<bool?> showLoginRequired(
    BuildContext context, {
    String? featureName,
  }) {
    return modal<bool>(
      context: context,
      child: LoginRequiredWidget(featureName: featureName),
    );
  }

  static void serviceModal({
    required BuildContext context,
    required List<ServiceEntity> services,
    List<ServiceEntity> selectedServices = const [],
    ValueChanged<List<ServiceEntity>>? onAdd,
    ValueChanged<List<ServiceEntity>>? onRemove,
    bool? isShowDropDown = true,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ContainerBottomModalSheetWidget(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: EdgeInsets.zero,
        child: ServiceModalWidget(
          services: services,
          selectedServices: selectedServices,
          onAdd: onAdd,
          onRemove: onRemove,
          isShowDropDown: isShowDropDown,
        ),
      ),
    );
  }

  static void detailPackageModal({
    required BuildContext context,
    required PackageEntity package,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ContainerBottomModalSheetWidget(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: EdgeInsets.zero,
        child: DetailPackageModalWidget(package: package),
      ),
    );
  }

  // MARK: POPUP
  static Future<int?> popup(
    BuildContext context, {
    required List<String> titles,
    required List<VoidCallback> onPressed,
    String? message,
    String cancelText = 'Cancel',
    List<bool>? isDestructive, // Đánh dấu action nào là destructive (màu đỏ)
  }) {
    assert(
      titles.length == onPressed.length,
      'titles và onPressed phải cùng số phần tử',
    );

    return showCupertinoModalPopup<int>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CupertinoActionSheet(
          message: message != null
              ? Text(
                  message,
                  style: const TextStyle(
                    fontSize: 13,
                    color: CupertinoColors.systemGrey,
                  ),
                )
              : null,
          actions: List.generate(titles.length, (index) {
            final isDestructiveAction =
                isDestructive != null && index < isDestructive.length
                ? isDestructive[index]
                : false;

            return CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context, index);
                onPressed[index]();
              },
              isDestructiveAction: isDestructiveAction,
              child: Text(
                titles[index],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: isDestructiveAction
                      ? CupertinoColors.systemRed
                      : CupertinoColors.systemBlue,
                ),
              ),
            );
          }),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            isDefaultAction: true,
            child: Text(
              cancelText,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.systemBlue,
              ),
            ),
          ),
        );
      },
    );
  }

  static void detailBookingDataModal({
    required BuildContext context,
    required BookingDataEntity data,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ContainerBottomModalSheetWidget(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: EdgeInsets.zero,
        child: BookingDataModalWidget(data: data),
      ),
    );
  }

  static Future<List<DateTime>> filterPickDateTime({
    required BuildContext context,
    required List<DateTime> currentDateRange,
    required FilterType filterType,
    required void Function({
      required List<DateTime> dateRange,
      required FilterType type,
    })
    onChanged,
    bool onlyPickOne = false,
    required void Function({
      required List<DateTime> dateRange,
      required FilterType type,
    })
    onClosed,
    DateTime? minYear,
    DateTime? maxDate,
    bool isDismissible = true,
    bool useSheet = true,
  }) async {
    final normalizedRange = _normalizeDateRange(currentDateRange);
    final effectiveMaxDate = maxDate ?? DateTime.now();
    final picker = DateModalWidget(
      currentDateRange: normalizedRange,
      filterType: filterType,
      onlyPickOne: onlyPickOne,
      minDate: minYear,
      maxDate: effectiveMaxDate,
      onChanged: onChanged,
      onClosed: onClosed,
    );

    final result = useSheet
        ? await modal<DateModalResult>(
            context: context,
            isDismissible: isDismissible,
            height: MediaQuery.of(context).size.height * 0.3,
            child: picker,
          )
        : await DialogHelper.dialog<DateModalResult>(
            context: context,
            barrierDismissible: isDismissible,
            insetPadding: const EdgeInsets.all(20),
            child: picker,
          );

    return result?.dateRange ?? normalizedRange;
  }

  static Future<List<DateTime>?> dateModal({
    required BuildContext context,
    List<DateTime>? currentDateRange,
    FilterType filterType = FilterType.day,
    bool onlyPickOne = false,
    DateTime? minDate,
    DateTime? maxDate,
    bool useSheet = true,
  }) {
    final range = _normalizeDateRange(currentDateRange ?? [DateTime.now()]);
    final effectiveMaxDate = maxDate ?? DateTime.now();
    final picker = DateModalWidget(
      currentDateRange: range,
      filterType: filterType,
      onlyPickOne: onlyPickOne,
      minDate: minDate,
      maxDate: effectiveMaxDate,
      onChanged: ({required dateRange, required type}) {},
      onClosed: ({required dateRange, required type}) {},
    );

    if (!useSheet) {
      return DialogHelper.dialog<DateModalResult>(
        context: context,
        insetPadding: const EdgeInsets.all(20),
        child: picker,
      ).then((value) => value?.dateRange);
    }

    return showModalBottomSheet<DateModalResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ContainerBottomModalSheetWidget(
        height: MediaQuery.of(context).size.height * 0.4,
        padding: EdgeInsets.zero,
        child: picker,
      ),
    ).then((value) => value?.dateRange);
  }

  static Future<TimeOfDay?> timeModal({
    required BuildContext context,
    TimeOfDay? initialTime,
    ValueChanged<TimeOfDay>? onChanged,
    ValueChanged<TimeOfDay>? onClosed,
    int minuteStep = 1,
    bool useSheet = true,
  }) {
    final picker = TimeModalWidget(
      initialTime: initialTime ?? TimeOfDay.now(),
      minuteStep: minuteStep,
      onChanged: onChanged ?? (_) {},
      onClosed: onClosed ?? (_) {},
    );

    if (!useSheet) {
      return DialogHelper.dialog<TimeOfDay>(
        context: context,
        insetPadding: const EdgeInsets.all(24),
        contentPadding: EdgeInsets.zero,
        child: picker,
      );
    }

    return modal<TimeOfDay>(context: context, height: 340, child: picker);
  }

  static Future<TimeOfDay?> pickTime({
    required BuildContext context,
    TimeOfDay? initialTime,
    bool useSheet = true,
    int minuteStep = 1,
  }) {
    if (useSheet) {
      return timeModal(
        context: context,
        initialTime: initialTime,
        minuteStep: minuteStep,
      );
    }

    return showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
    );
  }

  static List<DateTime> _normalizeDateRange(List<DateTime> value) {
    if (value.isEmpty) {
      final now = DateTime.now();
      return [now, now];
    }
    if (value.length == 1) return [value.first, value.first];
    return [value.first, value[1]];
  }
}
