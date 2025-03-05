import 'package:flutter/cupertino.dart';
import 'package:flutter_app/features/feed/widgets/feed_item_container.dart';
import 'package:flutter_app/ui/app_localization.dart';
import 'package:flutter_app/ui/shared_widgets/image.dart';
import 'package:flutter_app/ui/shared_widgets/image_modal_view.dart';
import 'package:wikipedia/wikipedia.dart';

class FeaturedImage extends StatelessWidget {
  const FeaturedImage({
    required this.image,
    required this.readableDate,
    required this.imageFile,
    super.key,
  });

  final WikipediaImage image;
  final ImageFile imageFile;
  final String readableDate;

  @override
  Widget build(BuildContext context) {
    return FeedItem(
      onTap: () async {
        await Navigator.of(context).push(
          CupertinoModalPopupRoute<void>(
            barrierDismissible: false,
            builder: (BuildContext context) {
              return ImageModalView(
                image,
                file: imageFile,
                title: AppStrings.imageOfTheDayFor(readableDate),
                attribution: image.artist,
                description: image.description,
              );
            },
          ),
        );
      },
      header: AppStrings.imageOfTheDay,
      subhead: image.artist != null ? AppStrings.by(image.artist!) : '',
      child: GestureDetector(
        child: RoundedImage(source: imageFile.source, height: 400),
      ),
    );
  }
}
