import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  // ─── Spacing ────────────────────────────────────
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // ─── Border Radius ──────────────────────────────
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusFull = 999;

  // ─── Icon Size ──────────────────────────────────
  static const double iconXs = 12; // badge, tag nhỏ
  static const double iconSm = 16; // icon inline với text
  static const double iconMd = 20; // icon button, nav bar
  static const double iconLg = 24; // icon mặc định
  static const double iconXl = 32; // icon lớn trong card
  static const double iconXxl = 48; // icon hero, empty state

  // ─── Screen Padding ─────────────────────────────
  static const double horizontalPaddingScreen = md;
  static const double verticalPaddingScreen = lg;
  static const EdgeInsets paddingScreen = EdgeInsets.symmetric(
    horizontal: md,
    vertical: lg,
  );

  // ─── Common Padding ─────────────────────────────
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);

  static const EdgeInsets paddingHSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingVSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVMd = EdgeInsets.symmetric(vertical: md);

  // ─── Gap (SizedBox shortcuts) ───────────────────
  static const double gapXs = xs;
  static const double gapSm = sm;
  static const double gapMd = md;
  static const double gapLg = lg;
  static const double gapXl = xl;

  static const double gapHXs = xs;
  static const double gapHSm = sm;
  static const double gapHMd = md;
  static const double gapHLg = lg;
}
