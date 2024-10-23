import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Config/theme/theming.dart';

class DialogUtils {



  static showMessage({
    required BuildContext context,
    required Color color,
    required String content,
    required String title,
    String? button1Name,
    Function? button1Function,
    String? button2Name,
    Function? button2Function,
      bool? barrierDismissible}) {
    return showDialog(
      context: context,
      builder: (context) {
        List<Widget> actions = [];
        if (button1Name != null) {
          actions.add(TextButton(
              onPressed: () {
                Navigator.pop(context);
                button1Function?.call();
              },
              child: Text(
                button1Name,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: 20.sp
                ),
              )));
        }
        if (button2Name != null) {
          actions.add(TextButton(
              onPressed: () {
                Navigator.pop(context);
                button2Function?.call();
              },
              child: Text(
                button2Name,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: 20.sp
                ),
              )));
        }
        return AlertDialog(
          backgroundColor: color,
          content: Text(
            content,
            style: Theme.of(context).textTheme.titleSmall
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontSize: 26.sp
            ),
          ),
          actions: actions,
        );
      },
    );
  }
}
