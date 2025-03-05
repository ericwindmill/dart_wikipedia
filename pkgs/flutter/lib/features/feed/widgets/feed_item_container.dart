import 'package:flutter/material.dart';
import 'package:flutter_app/providers/breakpoint_provider.dart';
import 'package:flutter_app/ui/breakpoint.dart';
import 'package:flutter_app/ui/build_context_util.dart';
import 'package:flutter_app/ui/theme/theme.dart';

const double feedItemHeaderHeight = 60;

({double feedItemHeight, double feedItemWidth}) itemSize(BuildContext context) {
  final breakpoint = BreakpointProvider.of(context);
  final totalWidth =
      MediaQuery.of(context).size.width - (breakpoint.margin * 2);

  return switch (breakpoint.width) {
    BreakpointWidth.small => (feedItemHeight: 400, feedItemWidth: totalWidth),
    BreakpointWidth.medium => (
      feedItemHeight: 400,
      // account for spacing between items and nav rail (72)
      feedItemWidth: (totalWidth - 72 - breakpoint.spacing * 2) / 2,
    ),
    BreakpointWidth.large => (
      feedItemHeight: 420,
      // account for spacing between items and extended nav rail (72)
      feedItemWidth: (totalWidth - 248 - breakpoint.spacing * 2) / 2,
    ),
  };
}

class FeedItem extends StatelessWidget {
  const FeedItem({
    required this.child,
    this.onTap,
    this.header,
    this.subhead,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final String? header;
  final String? subhead;

  @override
  Widget build(BuildContext context) {
    final size = itemSize(context);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: size.feedItemHeight,
        width: size.feedItemWidth,
        child: Stack(
          children: [
            if (header != null)
              Positioned(
                top: 0,
                height: feedItemHeaderHeight,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(header!, style: context.titleMedium),
                      if (subhead != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            subhead!,
                            style: context.labelSmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            Positioned(
              top: feedItemHeaderHeight,
              height: size.feedItemHeight - feedItemHeaderHeight,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.radius),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(1, 1),
                      blurRadius: 10,
                      color: Colors.black12,
                    ),
                  ],
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
