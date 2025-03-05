import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/features/article_view/article_page_view.dart';
import 'package:flutter_app/features/article_view/article_view.dart';
import 'package:flutter_app/features/saved_articles/saved_articles_view_model.dart';
import 'package:flutter_app/providers/breakpoint_provider.dart';
import 'package:flutter_app/ui/breakpoint.dart';
import 'package:flutter_app/ui/build_context_util.dart';
import 'package:flutter_app/ui/shared_widgets/image.dart';
import 'package:flutter_app/ui/theme/theme.dart';
import 'package:wikipedia/wikipedia.dart';

class SavedArticlesView extends StatelessWidget {
  const SavedArticlesView({required this.viewModel, super.key});

  final SavedArticlesViewModel viewModel;

  Future<void> _onTap(Summary summary, BuildContext context) async {
    if (BreakpointProvider.of(context).width != BreakpointWidth.large) {
      await Navigator.of(context).push(
        context.adaptivePageRoute(
          title: summary.titles.normalized,
          builder: (BuildContext context) {
            return ArticlePageView(summary: summary);
          },
        ),
      );
    } else {
      viewModel.activeArticle = summary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final breakpoint = BreakpointProvider.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            if (context.isCupertino)
              const CupertinoSliverNavigationBar(
                largeTitle: Text('Saved articles'),
              )
            else
              const SliverAppBar(title: Text('Saved articles')),
          ];
        },
        body: ListenableBuilder(
          listenable: viewModel,
          builder: (context, snapshot) {
            if (viewModel.savedArticles.isEmpty) {
              return Center(
                child: Text('No saved articles', style: context.labelSmall),
              );
            }

            final mainContent = ColoredBox(
              color: AppColors.cupertinoScaffoldBackgroundColor,
              child: ListView.separated(
                itemCount: viewModel.savedArticles.length,
                separatorBuilder: (context, index) {
                  return const Divider(thickness: .1, height: .1);
                },
                itemBuilder: (context, index) {
                  final summary =
                      viewModel.savedArticles.entries.elementAt(index).value;
                  final trailing =
                      summary.hasImage
                          ? RoundedImage(
                            source: summary.preferredSource!,
                            height: 30,
                            width: 30,
                          )
                          : null;

                  if (context.isCupertino) {
                    return Dismissible(
                      key: Key(summary.titles.canonical),
                      onDismissed: (details) {
                        viewModel.removeArticle(summary);
                      },
                      direction:
                          breakpoint.width == BreakpointWidth.small
                              ? DismissDirection.endToStart
                              : DismissDirection.none,
                      background: const ColoredBox(
                        color: AppColors.warmRed,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(
                              CupertinoIcons.delete,
                              color: Colors.black26,
                            ),
                          ),
                        ),
                      ),
                      child: CupertinoListTile(
                        backgroundColor: Colors.white,
                        trailing:
                            BreakpointProvider.of(context).width !=
                                    BreakpointWidth.small
                                ? IconButton(
                                  icon: const Icon(
                                    CupertinoIcons.clear_circled,
                                  ),
                                  onPressed:
                                      () => viewModel.removeArticle(summary),
                                )
                                : null,
                        title: Text(summary.titles.normalized),
                        subtitle: Text(summary.description ?? ''),
                        leading: trailing,
                        onTap: () => _onTap(summary, context),
                      ),
                    );
                  } else {
                    return ColoredBox(
                      color: Colors.white,
                      child: ListTile(
                        title: Text(summary.titles.normalized),
                        subtitle: Text(summary.description ?? ''),
                        trailing: trailing,
                        onTap: () => _onTap(summary, context),
                      ),
                    );
                  }
                },
              ),
            );

            final right =
                viewModel.activeArticle != null
                    ? ArticleView(summary: viewModel.activeArticle!)
                    : const Center(child: Text('Select an article'));

            if (breakpoint.width == BreakpointWidth.large) {
              return Row(
                children: [
                  Flexible(flex: 2, child: mainContent),
                  Flexible(flex: 3, child: right),
                ],
              );
            }

            return mainContent;
          },
        ),
      ),
    );
  }
}
