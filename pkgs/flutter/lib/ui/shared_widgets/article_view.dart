/*
 * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
 * // Use of this source code is governed by a BSD-style license that can be
 * // found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'package:wikipedia/wikipedia.dart';

import '../../features/saved_articles/save_for_later_button.dart';
import '../../features/saved_articles/view_model.dart';
import '../../repository_provider.dart';
import '../../ui/breakpoint.dart';
import '../../ui/shared_widgets/rounded_image.dart';
import '../build_context_util.dart';

class ArticleView extends StatelessWidget {
  const ArticleView({required this.summary, super.key});

  final Summary summary;

  ({double height, double width}) _imageSize(BuildContext context) {
    final breakpoint = context.breakpoint;
    final appWidth = MediaQuery.of(context).size.width;
    return switch (breakpoint.width) {
      BreakpointWidth.small => (height: appWidth, width: appWidth),
      BreakpointWidth.medium => (
        height: BreakpointWidth.medium.begin,
        width: BreakpointWidth.medium.begin,
      ),
      BreakpointWidth.large => (
        height: BreakpointWidth.medium.begin,
        width: BreakpointWidth.medium.begin,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final imageSize = _imageSize(context);
    final breakpoint = context.breakpoint;

    Widget addMargin(Widget child) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: breakpoint.padding),
        child: child,
      );
    }

    return ColoredBox(
      color: Colors.white,
      child: ListView(
        children: [
          if (summary.originalImage != null)
            RoundedImage(
              source: summary.originalImage!.source,
              height: imageSize.height,
              width: imageSize.width,
              borderRadius: BorderRadius.zero,
            ),
          addMargin(
            Padding(
              padding: EdgeInsets.only(top: breakpoint.padding),
              child: Text(
                summary.titles.normalized,
                overflow: TextOverflow.ellipsis,
                style: TextTheme.of(context).titleLarge,
              ),
            ),
          ),
          addMargin(
            Padding(
              padding: EdgeInsets.symmetric(vertical: breakpoint.padding),
              child: Text(
                summary.description ?? '',
                style: TextTheme.of(context).labelSmall,
              ),
            ),
          ),

          addMargin(Text(summary.extract)),
          SizedBox(height: context.breakpoint.spacing),
          Center(
            child: SaveForLaterButton(
              summary: summary,
              label: Text('Save for later'),
              viewModel: SavedArticlesViewModel(
                repository:
                    RepositoryProvider.of(context).savedArticlesRepository,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
