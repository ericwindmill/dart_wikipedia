import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/features/feed/feed_view_model.dart';
import 'package:flutter_app/features/feed/widgets/featured_article.dart';
import 'package:flutter_app/features/feed/widgets/featured_image.dart';
import 'package:flutter_app/features/feed/widgets/most_read_preview.dart';
import 'package:flutter_app/features/feed/widgets/timeline_preview.dart';
import 'package:flutter_app/providers/breakpoint_provider.dart';
import 'package:flutter_app/ui/app_localization.dart';
import 'package:flutter_app/ui/breakpoint.dart';
import 'package:flutter_app/ui/build_context_util.dart';

class FeedView extends StatelessWidget {
  const FeedView({required this.viewModel, super.key});

  final FeedViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            if (context.isCupertino)
              const CupertinoSliverNavigationBar(largeTitle: Text('Today'))
            else
              const SliverAppBar(title: Text('Title')),
          ];
        },
        body: SingleChildScrollView(
          child: ListenableBuilder(
            listenable: viewModel,
            builder: (BuildContext context, _) {
              // TODO(ewindmill): handle errors
              if (viewModel.hasError) {
                return Center(child: Text(viewModel.error));
              }
              if (!viewModel.hasData && !viewModel.hasError) {
                return const Center(
                  child: Center(child: CircularProgressIndicator.adaptive()),
                );
              }

              final breakpoint = BreakpointProvider.of(context);

              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(
                  horizontal: BreakpointProvider.of(context).margin,
                ),
                child: Column(
                  spacing: BreakpointProvider.of(context).spacing,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      spacing: BreakpointProvider.of(context).spacing,
                      runSpacing: switch (BreakpointProvider.of(
                        context,
                      ).width) {
                        BreakpointWidth.small => breakpoint.spacing * 6,
                        BreakpointWidth.medium => breakpoint.spacing * 2,
                        BreakpointWidth.large => breakpoint.spacing * 2,
                      },
                      children: [
                        if (viewModel.todaysFeaturedArticle != null)
                          FeaturedArticle(
                            header: AppStrings.todaysFeaturedArticle,
                            subhead: AppStrings.fromLanguageWikipedia,
                            featuredArticle: viewModel.todaysFeaturedArticle!,
                          ),
                        if (viewModel.timelinePreview.isNotEmpty)
                          TimelinePreview(
                            timelinePreviewItems: viewModel.timelinePreview,
                            readableDate: viewModel.readableDate,
                          ),
                        if (viewModel.hasImageOfTheDay)
                          FeaturedImage(
                            image: viewModel.imageOfTheDay!,
                            imageFile: viewModel.imageOfTheDaySource!,
                            readableDate: viewModel.readableDate,
                          ),
                        if (viewModel.mostRead.isNotEmpty)
                          MostReadView(topReadArticles: viewModel.mostRead),
                        if (viewModel.randomArticle != null)
                          FeaturedArticle(
                            header: AppStrings.randomArticle,
                            subhead: AppStrings.fromLanguageWikipedia,
                            featuredArticle: viewModel.randomArticle!,
                          ),
                      ],
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
