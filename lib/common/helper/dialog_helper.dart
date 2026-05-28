import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/theme/app_spacing.dart';

class DialogAction {
  const DialogAction({
    required this.label,
    this.onPressed,
    this.isDestructive = false,
    this.isDefault = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isDestructive;
  final bool isDefault;
}

class DialogHelper {
  const DialogHelper._();

  static Future<T?> dialog<T>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
    EdgeInsets insetPadding = const EdgeInsets.all(24),
    EdgeInsets contentPadding = const EdgeInsets.all(AppSpacing.md),
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => Dialog(
        insetPadding: insetPadding,
        child: Padding(
          padding: contentPadding,
          child: child,
        ),
      ),
    );
  }

  static Future<void> alert({
    required BuildContext context,
    required String title,
    String? message,
    String buttonText = 'OK',
    bool barrierDismissible = true,
    VoidCallback? onPressed,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: message == null ? null : Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onPressed?.call();
            },
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  static Future<bool> confirm({
    required BuildContext context,
    required String title,
    String? message,
    String confirmText = 'Xác nhận',
    String cancelText = 'Hủy',
    bool isDestructive = false,
    bool barrierDismissible = true,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: message == null ? null : Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          FilledButton(
            style: isDestructive
                ? FilledButton.styleFrom(
                    backgroundColor: context.colorScheme.error,
                    foregroundColor: context.colorScheme.onError,
                  )
                : null,
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  static Future<int?> actionSheet({
    required BuildContext context,
    required List<DialogAction> actions,
    String? title,
    String? message,
    String cancelText = 'Hủy',
  }) {
    return showCupertinoModalPopup<int>(
      context: context,
      barrierDismissible: true,
      builder: (context) => CupertinoActionSheet(
        title: title == null ? null : Text(title),
        message: message == null ? null : Text(message),
        actions: List.generate(actions.length, (index) {
          final action = actions[index];
          return CupertinoActionSheetAction(
            isDestructiveAction: action.isDestructive,
            isDefaultAction: action.isDefault,
            onPressed: () {
              Navigator.of(context).pop(index);
              action.onPressed?.call();
            },
            child: Text(action.label),
          );
        }),
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(cancelText),
        ),
      ),
    );
  }

  static Future<T?> loading<T>({
    required BuildContext context,
    String? message,
    bool barrierDismissible = false,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => PopScope(
        canPop: barrierDismissible,
        child: Dialog(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
                if (message != null && message.trim().isNotEmpty) ...[
                  const SizedBox(width: AppSpacing.md),
                  Flexible(child: Text(message)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
