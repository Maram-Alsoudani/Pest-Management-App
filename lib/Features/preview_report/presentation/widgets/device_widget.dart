import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/site_report/presentation/manager/report_view_model.dart';

import 'title_divider_widget.dart';

class DeviceWidget extends StatelessWidget {
  final double opacity;
  final Animation<Offset> position;
  const DeviceWidget(
      {super.key, required this.opacity, required this.position});

  @override
  Widget build(BuildContext context) {
    final reportViewModel = context.read<ReportViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitleWithDivider(title: StringManager.devices),
        SlideTransition(
          position: position,
          child: reportViewModel.devices.isNotEmpty
              ? Column(
                  children: reportViewModel.devices.map((device) {
                    return ListTile(
                      title: Text(device,
                          style: Theme.of(context).textTheme.titleMedium),
                    );
                  }).toList(),
                )
              : Text(StringManager.noDevices,
                  style: Theme.of(context).textTheme.titleMedium),
        ),
      ],
    );
  }
}
