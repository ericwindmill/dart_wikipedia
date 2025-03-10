import 'package:flutter/material.dart';
import 'package:wikipedia/wikipedia.dart';

import '../../../ui/app_theme.dart';
import '../../../ui/build_context_util.dart';
import '../../../ui/shared_widgets/article_page_view.dart';
import '../page_view.dart';
import '../view_model.dart';
import 'timeline_page_link.dart';
import 'timeline_painter.dart';

class TimelineListItem extends StatelessWidget {
  const TimelineListItem({
    required this.event,
    super.key,
    required this.viewModel,
  });

  final OnThisDayEvent event;
  final TimelineViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          bottom: 0,
          left: sidebarWidth / 2,
          child: CustomPaint(painter: TimelinePainter()),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: sidebarWidth),
                child: Text(
                  event.type != EventType.holiday
                      ? event.year!.absYear
                      : event.type.humanReadable,
                  style: TextTheme.of(
                    context,
                  ).titleMedium?.copyWith(color: AppColors.primary),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: context.breakpoint.padding,
                  left: sidebarWidth,
                  right: context.breakpoint.padding,
                ),
                child: Text(
                  event.text,
                  style: TextTheme.of(context).bodyMedium,
                ),
              ),
            ),
            SizedBox(
              height: 80,
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: event.pages.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    // Put a scrollable blank item
                    if (index == 0) {
                      return Container(width: sidebarWidth);
                    }

                    var summary = event.pages[index - 1];
                    return TimelinePageLink(
                      summary,
                      onTap: () {
                        viewModel.activeArticle = summary;
                        if (context.breakpoint.isSmall ||
                            context.breakpoint.isMedium) {
                          Navigator.of(context).push(
                            context.adaptivePageRoute(
                              title: summary.titles.normalized,
                              builder: (context) {
                                return ArticlePageView(summary: summary);
                              },
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: context.breakpoint.spacing),
          ],
        ),
      ],
    );
  }
}
