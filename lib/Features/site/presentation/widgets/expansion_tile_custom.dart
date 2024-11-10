import 'package:flutter/material.dart';
import 'package:pesticides/Core/utils/colors.dart';

class ExpansionTileCustom extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const ExpansionTileCustom(
      {super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        iconColor: ColorManager.primaryColor,
        collapsedIconColor: ColorManager.primaryColor,
        collapsedShape: const RoundedRectangleBorder(
          side: BorderSide.none,
        ),
        shape: const RoundedRectangleBorder(
          side: BorderSide.none,
        ),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        children: children);
  }
}
