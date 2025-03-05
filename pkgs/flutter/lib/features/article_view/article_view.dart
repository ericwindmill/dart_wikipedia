import 'package:flutter/material.dart';
import 'package:flutter_app/features/saved_articles/save_for_later_button.dart';
import 'package:flutter_app/features/saved_articles/saved_articles_view_model.dart';
import 'package:flutter_app/providers/breakpoint_provider.dart';
import 'package:flutter_app/providers/repository_provider.dart';
import 'package:flutter_app/ui/app_localization.dart';
import 'package:flutter_app/ui/breakpoint.dart';
import 'package:flutter_app/ui/build_context_util.dart';
import 'package:flutter_app/ui/shared_widgets/image.dart';
import 'package:wikipedia/wikipedia.dart';

class ArticleView extends StatelessWidget {
  const ArticleView({required this.summary, super.key});

  final Summary summary;

  ({double height, double width}) _imageSize(BuildContext context) {
    final breakpoint = BreakpointProvider.of(context);
    final appWidth =
        MediaQuery.of(context).size.width - (breakpoint.margin * 2);

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
    final breakpoint = BreakpointProvider.of(context);
    final imageSize = _imageSize(context);

    Widget addMargin(Widget child) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: breakpoint.margin),
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
                style: context.titleLarge,
              ),
            ),
          ),
          addMargin(
            Padding(
              padding: EdgeInsets.symmetric(vertical: breakpoint.padding),
              child: Text(summary.description ?? '', style: context.labelSmall),
            ),
          ),

          addMargin(Text(summary.extract)),
          const SizedBox(height: 10),
          Center(
            child: SaveForLaterButton(
              summary: summary,
              label: Text(AppStrings.saveForLater),
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
