import 'package:flutter/material.dart';
import 'package:wikipedia/wikipedia.dart';

import '../../../repository_provider.dart';
import '../../../ui/shared_widgets/rounded_image.dart';
import '../../saved_articles/save_for_later_button.dart';
import '../../saved_articles/view_model.dart';

class TimelinePageLink extends StatelessWidget {
  const TimelinePageLink(this.summary, {super.key, this.onTap});

  final Summary summary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
