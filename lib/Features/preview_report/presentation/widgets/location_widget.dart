import 'package:flutter/material.dart';

import '../../../../Core/utils/colors.dart';

class LocationWidget extends StatelessWidget {
  final String location;
  const LocationWidget({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.location_on,
          color: ColorManager.primaryColor,
        ),
        Text(location, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
