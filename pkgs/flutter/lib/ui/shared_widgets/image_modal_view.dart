import 'package:flutter/material.dart';
import 'package:flutter_app/providers/breakpoint_provider.dart';
import 'package:flutter_app/ui/build_context_util.dart';
import 'package:flutter_app/ui/shared_widgets/image.dart';
import 'package:wikipedia/wikipedia.dart';

class ImageModalView extends StatelessWidget {
  const ImageModalView(
    this.image, {
    required this.file,
    super.key,
    this.title,
    this.attribution,
    this.description,
  });

  final WikipediaImage image;
  final ImageFile file;
  Color get foregroundColor => Colors.white;
  final String? title;
  final String? attribution;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = context.bodyMedium;
    return Dismissible(
      direction: DismissDirection.vertical,
      onDismissed: Navigator.of(context).pop,
      key: const Key('ImageModal'),
      child: Stack(
        children: <Widget>[
          Center(
            child: RoundedImage(
              borderRadius: BorderRadius.zero,
              source: file.source,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ColoredBox(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(BreakpointProvider.of(context).padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: BreakpointProvider.of(context).spacing,
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.drag_handle,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    if (title != null) Text(title!, style: context.titleMedium),
                    if (description != null)
                      Text(description!, style: textStyle),
                    if (attribution != null)
                      Text(
                        attribution!,
                        style: textStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
