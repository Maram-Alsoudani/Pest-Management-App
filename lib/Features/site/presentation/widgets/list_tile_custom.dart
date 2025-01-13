import 'package:flutter/material.dart';

class ListTileCustom extends StatelessWidget {
  final Widget child;
  final Function onTap;
  const ListTileCustom({super.key, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: child,
      onTap: () {
        onTap();
      },
    );
  }
}
