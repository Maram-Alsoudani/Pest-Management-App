import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:pesticides/Core/utils/colors.dart';

class DialogUtils {
  static void hideLoadingDialog(BuildContext context) {
    Navigator.pop(context);
  }

  static void showLoadingDialog(
      {required BuildContext context, required String message}) {
    if (Platform.isIOS || Platform.isMacOS) {
      // IOS Style
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const CupertinoActivityIndicator(),
            content: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          );
        },
      );
    } else {
      // Android Style
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor:
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Center(child: CircularProgressIndicator()),
            content: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          );
        },
      );
    }
  }

  static void showAlertDialog({
    required BuildContext context,
    String? title,
    String? message,
    String? posActionTitle,
    String? negActionTitle,
    String? thirdActionTitle,
    Function? posAction,
    Function? negAction,
    Function? thirdAction,
    Color posColor = ColorManager.dialogBlueColor,
    Color negColor = ColorManager.dialogRedColor,
    Color thirdColor = ColorManager.dialogBlueColor,
  }) {
    List<Widget> actions = [];
    // IOS Style
    if (Platform.isIOS || Platform.isMacOS) {
      if (posActionTitle != null) {
        actions.add(
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              posAction?.call();
            },
            child: Text(
              posActionTitle,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: posColor),
            ),
          ),
        );
      }
      if (thirdActionTitle != null) {
        actions.add(
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              thirdAction?.call();
            },
            child: Text(
              thirdActionTitle,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: thirdColor),
            ),
          ),
        );
      }
      if (negActionTitle != null) {
        actions.add(
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              negAction?.call();
            },
            child: Text(
              negActionTitle,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: negColor),
            ),
          ),
        );
      }
    } else {
      // Android Style
      if (negActionTitle != null) {
        actions.add(
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              negAction?.call();
            },
            child: Text(
              negActionTitle,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: negColor),
            ),
          ),
        );
      }
      if (thirdActionTitle != null) {
        actions.add(
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              thirdAction?.call();
            },
            child: Text(
              thirdActionTitle,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: thirdColor),
            ),
          ),
        );
      }
      if (posActionTitle != null) {
        actions.add(
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              posAction?.call();
            },
            child: Text(
              posActionTitle,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: posColor),
            ),
          ),
        );
      }
    }
    // Construct actions with separators, the function we're calling after making vertical dividers
    List<Widget> actionsWithSeparators = [];
    for (int i = 0; i < actions.length; i++) {
      actionsWithSeparators.add(actions[i]);
      if (i < actions.length - 1) {
        actionsWithSeparators.add(
          const Divider(
            color: ColorManager.greyShade4,
            thickness: 0.6,
          ),
        );
      }
    }
    if (Platform.isIOS || Platform.isMacOS) {
      // iOS Style
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child: Center(
                child: Text(
                  title ?? '',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
            content: Text(
              message ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            actions: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: actionsWithSeparators,
              ),
            ],
          );
        },
      );
    } else {
      // Android Style
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor:
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
            title: Text(
              title ?? '',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            content: Text(
              message ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            actions: actions,
          );
        },
      );
    }
  }
}
