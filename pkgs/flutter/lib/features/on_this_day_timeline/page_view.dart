/*
 * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
 * // Use of this source code is governed by a BSD-style license that can be
 * // found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'package:wikipedia/wikipedia.dart';

import '../../ui/app_theme.dart';
import '../../ui/build_context_util.dart';
import '../../ui/shared_widgets/article_view.dart';
import 'view_model.dart';
import 'widgets/timeline_list_item.dart';

const double sidebarWidth = 60;
const double mainColumnWidthPercentage = .85;

class TimelinePageView extends StatelessWidget {
  const TimelinePageView({required this.viewModel, super.key});

  final TimelineViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (BuildContext context, _) {
        if (viewModel.hasError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(viewModel.error!, style: TextTheme.of(context).labelSmall),
              SizedBox(height: 10),
            ],
          );
        }
        if (!viewModel.hasData && !viewModel.hasError) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        final mainContent = ColoredBox(
          color: Colors.white,
          child: ListView.builder(
            itemCount: viewModel.filteredEvents.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Padding(
                  padding: EdgeInsets.all(context.breakpoint.margin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        viewModel.readableDate,
                        style: TextTheme.of(
                          context,
                        ).titleMedium?.copyWith(fontSize: 24),
                      ),
                      SizedBox(height: context.breakpoint.spacing),
                      Text(
                        '${viewModel.filteredEvents.length} historic events'
                            .toUpperCase(),
                        style: TextTheme.of(
                          context,
                        ).titleMedium?.copyWith(color: AppColors.labelOnLight),
                      ),
                      if (viewModel.readableYearRange != '')
                        Text(
                          'from ${viewModel.readableYearRange}',
                          style: TextTheme.of(context).titleMedium?.copyWith(
                            color: AppColors.labelOnLight,
                          ),
                        ),
                      SizedBox(height: context.breakpoint.spacing),
                    ],
                  ),
                );
              }

              final OnThisDayEvent event = viewModel.filteredEvents[index - 1];
              return TimelineListItem(event: event, viewModel: viewModel);
            },
          ),
        );

        final right =
            viewModel.activeArticle != null
                ? ArticleView(summary: viewModel.activeArticle!)
                : const Center(child: Text('Select an article'));

        if (context.breakpoint.isLarge) {
          return Row(
            children: [
              Flexible(flex: 3, child: mainContent),
              Flexible(flex: 3, child: right),
            ],
          );
        }

        return mainContent;
      },
    );
  }
}
