import 'package:flutter/material.dart';
import 'package:flutter_app/features/article_view/article_page_view.dart';
import 'package:flutter_app/features/saved_articles/save_for_later_button.dart';
import 'package:flutter_app/features/saved_articles/saved_articles_view_model.dart';
import 'package:flutter_app/providers/repository_provider.dart';
import 'package:flutter_app/ui/build_context_util.dart';
import 'package:flutter_app/ui/shared_widgets/image.dart';
import 'package:wikipedia/wikipedia.dart';

class TimelinePageLink extends StatelessWidget {
  const TimelinePageLink(this.summary, {super.key});

  final Summary summary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          context.adaptivePageRoute(
            title: summary.titles.normalized,
            builder: (BuildContext context) {
              return ArticlePageView(summary: summary);
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          width: 240,
          padding: const EdgeInsets.only(top: 5, bottom: 5, right: 8, left: 2),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(1, 1),
                blurRadius: 2,
                color: Colors.black12,
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              SaveForLaterButton(
                summary: summary,
                viewModel: SavedArticlesViewModel(
                  repository:
                      RepositoryProvider.of(context).savedArticlesRepository,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        summary.titles.normalized,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        summary.description ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ),
              if (summary.thumbnail != null)
                RoundedImage(
                  source: summary.thumbnail!.source,
                  height: 45,
                  width: 45,
                  borderRadius: BorderRadius.circular(3),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
