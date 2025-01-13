import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bug_away/Core/utils/colors.dart';

class DateSeparator extends StatelessWidget {
  final DateTime date;

  const DateSeparator({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final dayOfWeek = DateFormat('EEEE').format(date);
    final formattedDate = DateFormat('dd/MM/yyyy').format(date);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Text(
            dayOfWeek,
            style: const TextStyle(
              color: ColorManager.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            formattedDate,
            style: const TextStyle(
              color: ColorManager.subtitleGrey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
