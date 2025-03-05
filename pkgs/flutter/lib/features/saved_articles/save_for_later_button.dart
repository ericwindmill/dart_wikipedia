import 'package:flutter/material.dart';
import 'package:flutter_app/features/saved_articles/saved_articles_view_model.dart';
import 'package:flutter_app/ui/theme/theme.dart';
import 'package:wikipedia/wikipedia.dart';

class SaveForLaterButton extends StatelessWidget {
  /// An [IconButton] that, when tapped, adds articles to a
  /// 'save for later' list.
  /// It has it's own ViewModel, and can be dropped in anywhere in the app
  /// to track article summaries for the saveForLater view
  const SaveForLaterButton({
    required this.viewModel,
    required this.summary,
    this.onPressed,
    this.label,
    super.key,
  });

  final VoidCallback? onPressed;
  final Summary summary;
  final SavedArticlesViewModel viewModel;
  final Widget? label;

  void _onPressed() {
    viewModel.articleIsSaved(summary)
        ? viewModel.removeArticle(summary)
        : viewModel.saveArticle(summary);

    // Null-aware function call
    onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final icon = Icon(
          viewModel.articleIsSaved(summary)
              ? Icons.bookmark
              : Icons.bookmark_border,
          color: Theme.of(context).primaryColor,
        );
        if (label != null) {
          return TextButton.icon(
            onPressed: _onPressed,
            icon: icon,
            label: label!,
          );
        }

        return IconButton(
          onPressed: _onPressed,
          padding: EdgeInsets.zero,
          iconSize: AppDimensions.iconSize,
          icon: icon,
        );
      },
    );
  }
}
