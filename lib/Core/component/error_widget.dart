import 'package:flutter/material.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Core/utils/strings.dart';

class CustomErrorWidget extends StatelessWidget {
  final String errorMessage;

  const CustomErrorWidget({required this.errorMessage, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringManager.errorOccurred),
      ),
      body: Center(
        child: Text(
          '${StringManager.errorPrefix}$errorMessage',
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: ColorManager.redColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ErrorWidgetApp extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const ErrorWidgetApp(this.errorDetails, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: StringManager.errorTitle,
      home: CustomErrorWidget(
        errorMessage: errorDetails.exceptionAsString(),
      ),
    );
  }
}
