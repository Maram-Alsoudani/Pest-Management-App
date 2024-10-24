import 'package:flutter/material.dart';
import 'package:pesticides/Core/utils/colors.dart';

class ExpansionTileCustom extends StatefulWidget {
  final String title;
  final List<Widget> children;
  const ExpansionTileCustom(
      {super.key, required this.title, required this.children});

  @override
  State<ExpansionTileCustom> createState() => _ExpansionTileCustomState();
}

class _ExpansionTileCustomState extends State<ExpansionTileCustom> with SingleTickerProviderStateMixin{
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    // Define the slide animation from the left to its original position
    _slideAnimation =
        Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0)).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    // Trigger the slide animation after the page loads
    Future.delayed(Duration(milliseconds: 150), () {

      _animationController.forward(); // Start the slide animation
    });
  }

  @override
  void dispose() {
    _animationController.dispose(); // Clean up the controller when done
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ExpansionTile(
          iconColor: ColorManager.primaryColor,
          collapsedIconColor: ColorManager.primaryColor,
          collapsedShape: const RoundedRectangleBorder(
            side: BorderSide.none,
          ),
          shape: const RoundedRectangleBorder(
            side: BorderSide.none,
          ),
          title: Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
          children: widget.children),
    );
  }
}
