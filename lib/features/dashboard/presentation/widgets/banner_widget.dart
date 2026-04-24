import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ltc/common/widgets/images/network_image_widget.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/theme/app_spacing.dart';

class BannerItem {
  const BannerItem({
    required this.title,
    required this.imageUrl,
    this.subtitle,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final String imageUrl;
  final VoidCallback? onTap;
}

class BannerWidget extends StatefulWidget {
  const BannerWidget({
    super.key,
    required this.items,
    this.autoPlayDuration = const Duration(seconds: 5),
    this.height = 160,
  });

  final List<BannerItem> items;
  final Duration autoPlayDuration;
  final double height;

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  late final PageController _pageCtrl;
  late Timer _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController(viewportFraction: 0.92);
    _startAutoPlay();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageCtrl.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(widget.autoPlayDuration, (_) {
      if (!mounted || widget.items.isEmpty) return;

      final next = (_currentIndex + 1) % widget.items.length;
      _pageCtrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  void _onUserScroll() {
    _timer.cancel();
    _startAutoPlay();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── PageView ──────────────────────────────────
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageCtrl,
            itemCount: widget.items.length,
            onPageChanged: _onPageChanged,
            // Reset timer khi user vuốt
            physics: const PageScrollPhysics(),
            itemBuilder: (context, index) {
              return NotificationListener<ScrollNotification>(
                onNotification: (n) {
                  if (n is UserScrollNotification) _onUserScroll();
                  return false;
                },
                child: _BannerCard(
                  item: widget.items[index],
                  isActive: index == _currentIndex,
                ),
              );
            },
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        // ── Dot indicator ─────────────────────────────
        if (widget.items.length > 1)
          _DotIndicator(count: widget.items.length, current: _currentIndex),
      ],
    );
  }
}

// ── Banner Card ───────────────────────────────────────────
class _BannerCard extends StatelessWidget {
  const _BannerCard({required this.item, required this.isActive});

  final BannerItem item;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: isActive ? 0 : AppSpacing.xs, // active cao hơn 1 chút
      ),
      child: GestureDetector(
        onTap: item.onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: Stack(
            fit: StackFit.expand,
            children: [
              NetworkImageWidget(url: item.imageUrl),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.55),
                      ],
                      stops: const [0.4, 1.0],
                    ),
                  ),
                ),
              ),

              // ── Text content ─────────────────────────
              Positioned(
                left: AppSpacing.md,
                right: AppSpacing.md,
                bottom: AppSpacing.md,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        item.subtitle!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.85),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // ── Tap ripple ───────────────────────────
              if (item.onTap != null)
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: item.onTap,
                      splashColor: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Dot Indicator ─────────────────────────────────────────
class _DotIndicator extends StatelessWidget {
  const _DotIndicator({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive
                ? context.colorScheme.primary
                : context.colorScheme.primary.withOpacity(0.25),
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
        );
      }),
    );
  }
}
