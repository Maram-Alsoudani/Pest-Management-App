import 'package:flutter/material.dart';
import 'package:pesticides/Core/utils/colors.dart';

class RecommendationsCustome extends StatefulWidget {
  final String text;

  RecommendationsCustome({required this.text});

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
          activeColor: ColorManager.primaryColor, // Color when checked
          checkColor: Colors.white,
          value: onClick, onChanged: (value) {
          setState(() {
            onClick = value!;
          });
        },),

      ],
    );
  }
}
