import 'package:flutter/material.dart';
import 'package:flutter_app/features/article_view/article_page_view.dart';
import 'package:flutter_app/features/feed/widgets/feed_item_container.dart';
import 'package:flutter_app/features/saved_articles/save_for_later_button.dart';
import 'package:flutter_app/features/saved_articles/saved_articles_view_model.dart';
import 'package:flutter_app/providers/breakpoint_provider.dart';
import 'package:flutter_app/providers/repository_provider.dart';
import 'package:flutter_app/ui/app_localization.dart';
import 'package:flutter_app/ui/build_context_util.dart';
import 'package:flutter_app/ui/shared_widgets/image.dart';
import 'package:flutter_app/ui/theme/theme.dart';
import 'package:wikipedia/wikipedia.dart';

class FeaturedArticle extends StatelessWidget {
  const FeaturedArticle({
    required this.featuredArticle,
    required this.header,
    required this.subhead,
    super.key,
  });

  final Summary featuredArticle;
  final String header;
  final String subhead;

  @override
  Widget build(BuildContext context) {
    final breakpoint = BreakpointProvider.of(context);

    return FeedItem(
      onTap: () async {
        await Navigator.of(context).push(
          context.adaptivePageRoute(
            title: featuredArticle.titles.normalized,
            builder: (BuildContext context) {
              return ArticlePageView(summary: featuredArticle);
            },
          ),
        );
      },
      header: header,
      subhead: subhead,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (featuredArticle.hasImage)
            RoundedImage(
              source: featuredArticle.preferredSource!,
              height: itemSize(context).feedItemHeight / 2.5,
              width: double.infinity,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.radius),
                topRight: Radius.circular(AppDimensions.radius),
              ),
            ),
          Padding(
            padding: EdgeInsets.only(
              top: breakpoint.padding,
              left: breakpoint.padding,
              right: breakpoint.padding,
            ),
            child: Text(
              featuredArticle.titles.normalized,
              overflow: TextOverflow.ellipsis,
              style: context.titleLarge,
            ),
          ),
          if (featuredArticle.description != null)
            Padding(
              padding: EdgeInsets.all(breakpoint.padding),
              child: Text(
                featuredArticle.description!,
                style: context.labelSmall,
              ),
            ),
          Padding(
            padding: EdgeInsets.only(
              top: breakpoint.padding,
              left: breakpoint.padding,
              right: breakpoint.padding,
            ),
            child: Text(
              featuredArticle.extract,
              overflow: TextOverflow.ellipsis,
              maxLines: featuredArticle.hasImage ? 3 : 10,
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(
              left: 4.0,
              bottom: BreakpointProvider.of(context).padding / 3,
            ),
            child: SaveForLaterButton(
              label: Text(AppStrings.saveForLater),
              viewModel: SavedArticlesViewModel(
                repository:
                    RepositoryProvider.of(context).savedArticlesRepository,
              ),
              summary: featuredArticle,
            ),
          ),
        ],
      ),
    );
  }
}
