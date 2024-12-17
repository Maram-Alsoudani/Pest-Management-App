import 'package:flutter/material.dart';
import 'package:bug_away/Core/utils/colors.dart';

class RecommendationsCustome extends StatefulWidget {
  final String text;

  const RecommendationsCustome({super.key, required this.text});

  @override
  State<RecommendationsCustome> createState() => _RecommendationsCustomeState();
}

class _RecommendationsCustomeState extends State<RecommendationsCustome> {
  bool onClick = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.text,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Checkbox(
          activeColor: ColorManager.primaryColor,
          checkColor: Colors.white,
          value: onClick,
          onChanged: (value) {
            print(widget.text);
            setState(() {
              onClick = value!;
            });
          },
        ),
      ],
    );
  }
}
