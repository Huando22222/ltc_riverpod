import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

class AppTheme {
  AppTheme._();

  // ════════════════════════════════════════════════
  //  LIGHT
  // ════════════════════════════════════════════════
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    iconTheme: const IconThemeData(
      color: AppColors.textPrimary,
      size: AppSpacing.iconLg,
    ),
    colorScheme: const ColorScheme.light(
      // ── Primary ──
      primary: AppColors.primary, // #2F80ED — button, active icon, link
      onPrimary: AppColors.white, // text/icon trên primary
      primaryContainer: AppColors.primaryLight, // #EBF3FF — chip bg, badge bg
      onPrimaryContainer: AppColors.primaryDark, // text trên primaryContainer
      // ── Secondary ────────────────────────────
      secondary: AppColors.primaryGradientEnd, // #56CCF2 — gradient end, tag
      onSecondary: AppColors.white,
      secondaryContainer: Color(0xFFDFF5FB), // bg chip secondary
      onSecondaryContainer: Color(0xFF0D4A5C), // text trên secondaryContainer
      // ── Tertiary ─────────────────────────────
      tertiary: AppColors.success, // #27AE60 — status tích cực
      onTertiary: AppColors.white,
      tertiaryContainer: AppColors.successLight, // #E9F7EF
      onTertiaryContainer: Color(0xFF1A5C36),

      // ── Error ────────────────────────────────
      error: AppColors.error, // #EB5757
      onError: AppColors.white,
      errorContainer: AppColors.errorLight, // #FDECEC
      onErrorContainer: Color(0xFF8B1A1A),

      // ── Surface ──────────────────────────────────────────────
      surface: AppColors.white, // #FFFFFF — Card, Input, Dialog, BottomSheet
      onSurface: AppColors.textPrimary, // # — Text chính, Icon chính
      onSurfaceVariant:
          AppColors.textSecondary, // #666666 — Text phụ, Label, Subtitle
      surfaceContainerLowest: AppColors.white, // #FFFFFF — Ít dùng, trắng tinh
      surfaceContainerLow:
          AppColors.backgroundLight, // #F8FAFE — Scaffold background
      surfaceContainer:
          AppColors.backgroundLight, // #F8FAFE — Section bg, Chip bg
      surfaceContainerHigh: Color(
        0xFFF0F4FF,
      ), // #F0F4FF — Selected item, Hover, Active bg
      surfaceContainerHighest:
          AppColors.backgroundLight, // #F8FAFE — Input disabled fill input fill
      // ── Background ───────────────────────────
      // ignore: deprecated_member_use_from_same_package (vẫn cần cho một số widget cũ)
      // background:           AppColors.backgroundLight,
      // onBackground:         AppColors.textPrimary,

      // ── Outline ──────────────────────────────
      outline: AppColors.border, // #E0E0E0 — border mặc định
      outlineVariant: AppColors.borderVariant, // #EEEEEE — border nhạt hơn
      // ── Inverse ──────────────────────────────
      inverseSurface: AppColors.textPrimary, // SnackBar bg
      onInverseSurface: AppColors.white, // SnackBar text
      inversePrimary: AppColors.primaryLight, // highlight ngược
      // ── Misc ─────────────────────────────────
      shadow: Color(0x1A000000),
      scrim: Color(0x99000000), // overlay modal/drawer
    ),

    scaffoldBackgroundColor: AppColors.backgroundLight,
    textTheme: AppTypography.textTheme,

    // ── AppBar ────────────────────────────────────
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0.5,
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.textPrimary,
      centerTitle: false,
      shadowColor: AppColors.border,
      titleTextStyle: AppTypography.textTheme.titleLarge?.copyWith(
        color: AppColors.textPrimary,
      ),
    ),

    // ── Card ──────────────────────────────────────
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.white,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: const BorderSide(color: AppColors.border),
      ),
      margin: EdgeInsets.zero,
    ),

    // ── ElevatedButton ────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        textStyle: AppTypography.textTheme.labelLarge,
      ),
    ),

    // ── OutlinedButton ────────────────────────────
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        minimumSize: const Size.fromHeight(48),
        side: const BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        textStyle: AppTypography.textTheme.labelLarge,
      ),
    ),

    // ── TextButton ────────────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTypography.textTheme.labelLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
    ),

    // ── Input ─────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.borderVariant),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 4,
      ),
      hintStyle: AppTypography.textTheme.bodyMedium?.copyWith(
        color: AppColors.textDisabled,
      ),
      labelStyle: AppTypography.textTheme.bodyMedium?.copyWith(
        color: AppColors.textSecondary,
      ),
      errorStyle: AppTypography.textTheme.bodySmall?.copyWith(
        color: AppColors.error,
      ),
    ),

    // ── BottomNavigationBar ───────────────────────
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textDisabled,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),

    // ── NavigationBar (M3) ────────────────────────
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.white,
      indicatorColor: AppColors.primaryLight,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.primary);
        }
        return const IconThemeData(color: AppColors.textDisabled);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTypography.textTheme.labelSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          );
        }
        return AppTypography.textTheme.labelSmall?.copyWith(
          color: AppColors.textDisabled,
        );
      }),
      elevation: 0,
      shadowColor: Colors.transparent,
    ),

    // ── Chip ──────────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.backgroundLight,
      selectedColor: AppColors.primaryLight,
      disabledColor: AppColors.borderVariant,
      labelStyle: AppTypography.textTheme.labelMedium?.copyWith(
        color: AppColors.textSecondary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      side: const BorderSide(color: AppColors.border),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
    ),

    // ── Divider ───────────────────────────────────
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
      space: 0,
    ),

    // ── ListTile ──────────────────────────────────
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      titleTextStyle: AppTypography.textTheme.bodyLarge?.copyWith(
        color: AppColors.textPrimary,
      ),
      subtitleTextStyle: AppTypography.textTheme.bodySmall?.copyWith(
        color: AppColors.textSecondary,
      ),
    ),

    // ── Dialog ────────────────────────────────────
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      titleTextStyle: AppTypography.textTheme.titleLarge?.copyWith(
        color: AppColors.textPrimary,
      ),
      contentTextStyle: AppTypography.textTheme.bodyMedium?.copyWith(
        color: AppColors.textSecondary,
      ),
    ),

    // ── SnackBar ──────────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.textPrimary,
      contentTextStyle: AppTypography.textTheme.bodyMedium?.copyWith(
        color: AppColors.white,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      behavior: SnackBarBehavior.floating,
    ),

    // ── BottomSheet ───────────────────────────────
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
    ),
  );

  // ════════════════════════════════════════════════
  //  DARK
  // ════════════════════════════════════════════════
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      // ── Primary ──────────────────────────────
      primary: AppColors.primary, // #2F80ED
      onPrimary: AppColors.white,
      primaryContainer: AppColors.primaryContainerDark, // #1A3A6E
      onPrimaryContainer: AppColors.primaryLight, // #EBF3FF
      // ── Secondary ────────────────────────────
      secondary: AppColors.primaryGradientEnd, // #56CCF2
      onSecondary: AppColors.black,
      secondaryContainer: AppColors.secondaryContainerDark, // #0D3A4A
      onSecondaryContainer: Color(0xFF9BE8F8),

      // ── Tertiary ─────────────────────────────
      tertiary: AppColors.success, // #27AE60
      onTertiary: AppColors.white,
      tertiaryContainer: AppColors.tertiaryContainerDark, // #0D2A3A
      onTertiaryContainer: Color(0xFF9BE8C0),

      // ── Error ────────────────────────────────
      error: AppColors.errorDark, // #FF6B6B
      onError: AppColors.black,
      errorContainer: AppColors.errorContainerDark, // #4A1A1A
      onErrorContainer: AppColors.onErrorContainerDark, // #FFB4B4
      // ── Surface ──────────────────────────────
      surface: AppColors.surfaceDark, // #1E1E2E — card, input, dialog
      onSurface: AppColors.onSurfaceDark, // #E8EAED — text chính
      onSurfaceVariant: AppColors.onSurfaceVariantDark, // #BDBDBD — text phụ
      surfaceContainerLowest: AppColors.backgroundDark, // #121212
      surfaceContainerLow: AppColors.surfaceDark, // #1E1E2E
      surfaceContainer: AppColors.surfaceContainerDark, // #252538
      surfaceContainerHigh: AppColors.surfaceContainerHighDark, // #2A2A3E
      surfaceContainerHighest:
          AppColors.surfaceContainerHighDark, // disabled input fill
      // ── Outline ──────────────────────────────
      outline: AppColors.borderDark, // #2A2A3E — border mặc định
      outlineVariant: AppColors.borderVariantDark, // #3A3A5C — border nhạt hơn
      // ── Inverse ──────────────────────────────
      inverseSurface: AppColors.inverseSurfaceDark, // #E8EAED — SnackBar bg
      onInverseSurface:
          AppColors.onInverseSurfaceDark, // #1E1E2E — SnackBar text
      inversePrimary: AppColors.inversePrimaryDark, // #1C5BB2
      // ── Misc ─────────────────────────────────
      shadow: Color(0x33000000),
      scrim: Color(0xCC000000), // overlay đậm hơn dark mode
    ),

    scaffoldBackgroundColor: AppColors.backgroundDark,
    textTheme: AppTypography.textTheme,

    // ── AppBar ────────────────────────────────────
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0.5,
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: AppColors.onSurfaceDark,
      centerTitle: false,
      shadowColor: AppColors.borderDark,
      titleTextStyle: AppTypography.textTheme.titleLarge?.copyWith(
        color: AppColors.onSurfaceDark,
      ),
    ),

    // ── Card ──────────────────────────────────────
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.surfaceDark,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: const BorderSide(color: AppColors.borderDark),
      ),
      margin: EdgeInsets.zero,
    ),

    // ── ElevatedButton ────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        textStyle: AppTypography.textTheme.labelLarge,
      ),
    ),

    // ── OutlinedButton ────────────────────────────
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        minimumSize: const Size.fromHeight(48),
        side: const BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        textStyle: AppTypography.textTheme.labelLarge,
      ),
    ),

    // ── TextButton ────────────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTypography.textTheme.labelLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
    ),

    // ── Input ─────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceContainerDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.errorDark),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.errorDark, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.borderVariantDark),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 4,
      ),
      hintStyle: AppTypography.textTheme.bodyMedium?.copyWith(
        color: AppColors.onSurfaceVariantDark,
      ),
      labelStyle: AppTypography.textTheme.bodyMedium?.copyWith(
        color: AppColors.onSurfaceVariantDark,
      ),
      errorStyle: AppTypography.textTheme.bodySmall?.copyWith(
        color: AppColors.errorDark,
      ),
    ),

    // ── BottomNavigationBar ───────────────────────
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.onSurfaceVariantDark,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),

    // ── NavigationBar (M3) ────────────────────────
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      indicatorColor: AppColors.primaryContainerDark,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.primary);
        }
        return const IconThemeData(color: AppColors.onSurfaceVariantDark);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTypography.textTheme.labelSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          );
        }
        return AppTypography.textTheme.labelSmall?.copyWith(
          color: AppColors.onSurfaceVariantDark,
        );
      }),
      elevation: 0,
      shadowColor: Colors.transparent,
    ),

    // ── Chip ──────────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceContainerDark,
      selectedColor: AppColors.primaryContainerDark,
      disabledColor: AppColors.borderDark,
      labelStyle: AppTypography.textTheme.labelMedium?.copyWith(
        color: AppColors.onSurfaceDark,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      side: const BorderSide(color: AppColors.borderDark),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
    ),

    // ── Divider ───────────────────────────────────
    dividerTheme: const DividerThemeData(
      color: AppColors.borderDark,
      thickness: 1,
      space: 0,
    ),

    // ── ListTile ──────────────────────────────────
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      titleTextStyle: AppTypography.textTheme.bodyLarge?.copyWith(
        color: AppColors.onSurfaceDark,
      ),
      subtitleTextStyle: AppTypography.textTheme.bodySmall?.copyWith(
        color: AppColors.onSurfaceVariantDark,
      ),
    ),

    // ── Dialog ────────────────────────────────────
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceContainerDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      titleTextStyle: AppTypography.textTheme.titleLarge?.copyWith(
        color: AppColors.onSurfaceDark,
      ),
      contentTextStyle: AppTypography.textTheme.bodyMedium?.copyWith(
        color: AppColors.onSurfaceVariantDark,
      ),
    ),

    // ── SnackBar ──────────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.inverseSurfaceDark,
      contentTextStyle: AppTypography.textTheme.bodyMedium?.copyWith(
        color: AppColors.onInverseSurfaceDark,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      behavior: SnackBarBehavior.floating,
    ),

    // ── BottomSheet ───────────────────────────────
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surfaceContainerDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
    ),
  );
}
