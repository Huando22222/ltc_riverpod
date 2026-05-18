import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/common/helper/modal_helper.dart';
import 'package:ltc/features/auth/presentation/providers/auth_provider.dart';

extension AuthGuardExt on WidgetRef {
  bool isAuthenticated(BuildContext context) {
    final user = read(currentUserProvider);

    if (user == null) {
      ModalHelper.showLoginRequired(context);
      return false;
    }

    return true;
  }
}
