import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Destinations {
  explore('Explore', Icons.home, CupertinoIcons.house_fill),
  timeline('Timeline', Icons.calendar_today_outlined, CupertinoIcons.calendar),
  savedArticles('Saved', Icons.bookmark_border, CupertinoIcons.bookmark);

  const Destinations(this.label, this.materialIcon, this.cupertinoIcon);

  final String label;
  final IconData materialIcon;
  final IconData cupertinoIcon;
}
