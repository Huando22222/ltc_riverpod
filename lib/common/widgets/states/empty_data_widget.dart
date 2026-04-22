import 'package:flutter/material.dart';

enum SearchData { search, empty, error }

class EmptyDataWidget extends StatelessWidget {
  final SearchData iconType;
  final String title;
  final String? subTitle;
  final VoidCallback? onRetry;
  final Widget? iconWidget; // icon tùy chỉnh

  const EmptyDataWidget({
    super.key,
    this.iconType = SearchData.empty,
    this.title = "Không có dữ liệu",
    this.subTitle,
    this.onRetry,
    this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1469AE); // xanh y tế
    const Color errorColor = Color(0xFFDC2626);

    final bool isError = iconType == SearchData.error;
    final Color accentColor = isError ? errorColor : primaryColor;

    IconData icon;
    switch (iconType) {
      case SearchData.search:
        icon = Icons.search_off_rounded;
        break;
      case SearchData.empty:
        icon = Icons.inbox_outlined;
        break;
      case SearchData.error:
        icon = Icons.error_outline_rounded;
        break;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icon ──────────────────────────────────────────
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: Center(
                child:
                    iconWidget ??
                    Icon(
                      icon,
                      size: 36,
                      color: accentColor.withValues(alpha: 0.7),
                    ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Title ─────────────────────────────────────────
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: accentColor,
              ),
            ),

            // ── Subtitle ──────────────────────────────────────
            if (subTitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subTitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                  height: 1.5,
                ),
              ),
            ],

            // ── Retry button (chỉ hiện khi error) ─────────────
            if (isError && onRetry != null) ...[
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Thử lại'),
                style: TextButton.styleFrom(
                  foregroundColor: errorColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: errorColor.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
