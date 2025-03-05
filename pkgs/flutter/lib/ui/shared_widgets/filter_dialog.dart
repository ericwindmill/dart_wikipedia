import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ui/app_localization.dart';
import 'package:flutter_app/ui/build_context_util.dart';

class FilterDialog<T extends Enum> extends StatefulWidget {
  const FilterDialog({
    required this.options,
    required this.onSelectItem,
    required this.onSubmit,
    super.key,
  });

  final Map<T, bool> options;
  final void Function({required T value, bool? isChecked}) onSelectItem;
  final VoidCallback onSubmit;

  @override
  State<FilterDialog<T>> createState() => _FilterDialogState<T>();
}

class _FilterDialogState<T extends Enum> extends State<FilterDialog<T>> {
  @override
  Widget build(BuildContext context) {
    final dialogBody = Column(
      children: <Widget>[
        ...List<Widget>.generate(widget.options.length, (int idx) {
          final T option = widget.options.keys.elementAt(idx);
          return CheckboxListTile.adaptive(
            tileColor: Colors.white,
            title: Text(option.name),
            value: widget.options[option],
            onChanged: (bool? value) {
              setState(() {
                widget.onSelectItem(
                  isChecked: value,
                  value: widget.options.entries.elementAt(idx).key,
                );
              });
            },
          );
        }),
      ],
    );

    final actions = [
      if (context.isCupertino)
        CupertinoDialogAction(
          child: Text(AppStrings.confirmChoices),
          onPressed: () {
            widget.onSubmit();
            Navigator.of(context).pop();
          },
        )
      else
        TextButton(
          onPressed: () {
            widget.onSubmit();
            Navigator.of(context).pop();
          },
          child: Text(AppStrings.confirmChoices),
        ),
    ];

    return context.isCupertino
        ? Material(
          color: Colors.transparent,
          child: CupertinoAlertDialog(content: dialogBody, actions: actions),
        )
        : AlertDialog(content: dialogBody, actions: actions);
  }
}
