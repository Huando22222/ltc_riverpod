import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ltc/common/widgets/modal/container_bottom_modal_sheet.dart';
import 'package:ltc/common/widgets/modal/login_required_widget.dart';
import 'package:ltc/common/widgets/modal/service_modal_widget.dart';
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
        return ContainerBottomModalSheet(height: height, child: child);
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

  static void showServiceModal({
    required BuildContext context,
    required List<ServiceEntity> services,
    List<ServiceEntity> selectedServices = const [],
    ValueChanged<List<ServiceEntity>>? onAdd,
    ValueChanged<List<ServiceEntity>>? onRemove,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ContainerBottomModalSheet(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: EdgeInsets.zero,
        child: ServiceModalWidget(
          services: services,
          selectedServices: selectedServices,
          onAdd: onAdd,
          onRemove: onRemove,
        ),
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
}
