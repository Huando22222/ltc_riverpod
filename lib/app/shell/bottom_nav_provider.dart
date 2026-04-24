import 'package:flutter_riverpod/flutter_riverpod.dart';

// final bottomNavProvider = Provider<int>((ref) => 0);

class BottomNavNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void changeTab(int index) {
    state = index;
  }
}

final bottomNavProvider = NotifierProvider<BottomNavNotifier, int>(
  BottomNavNotifier.new,
);
