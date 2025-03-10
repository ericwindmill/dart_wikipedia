import 'package:flutter/material.dart';

class RoundedImage extends StatelessWidget {
  RoundedImage({
    required this.source,
    super.key,
    this.height,
    this.width,
    BorderRadius? borderRadius,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.topCenter,
  }) : radius = borderRadius ?? BorderRadius.circular(8);

  final String source;
  final BoxFit fit;
  final double? height;
  final double? width;
  final BorderRadius radius;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    // The container adds a background color because some images from
    // wikipedia have a transparent background
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: radius),
      child: ClipRRect(
        borderRadius: radius,
        child: Image.network(
          source,
          height: height,
          width: width,
          fit: fit,
          alignment: alignment,
        ),
      ),
    );
  }
}
