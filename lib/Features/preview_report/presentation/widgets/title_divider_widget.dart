import 'package:flutter/material.dart';
import 'package:bug_away/Core/utils/colors.dart';

class SectionTitleWithDivider extends StatelessWidget {
  final String title;

  const SectionTitleWithDivider({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Divider(
          color: ColorManager.primaryColor,
          thickness: 1,
          indent: 15,
          endIndent: 15,
        ),
      ],
    );
  }
}
