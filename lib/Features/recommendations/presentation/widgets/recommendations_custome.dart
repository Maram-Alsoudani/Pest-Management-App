import 'package:flutter/material.dart';

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
        IconButton(
            onPressed: () {
              setState(() {
                onClick = !onClick;
              });
            },
            icon: onClick
                ? Icon(Icons.check_box_outline_blank)
                : Icon(Icons.check_box))
      ],
    );
  }
}
