import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:bug_away/core/utils/colors.dart';

class DialogUtils {
  static void hideLoadingDialog(BuildContext context) {
    Navigator.pop(context);
  }

  static void showLoadingDialog({
    required BuildContext context,
    required String message,
  }) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    if (Platform.isIOS || Platform.isMacOS) {
      // iOS Style
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoTheme(
            data: CupertinoThemeData(
              brightness: isDarkMode ? Brightness.dark : Brightness.light,
              primaryColor:
                  isDarkMode ? ColorManager.whiteColor : ColorManager.blueColor,
              scaffoldBackgroundColor: isDarkMode
                  ? ColorManager.blackColor.withOpacity(0.8)
                  : ColorManager.whiteColor.withOpacity(0.8),
            ),
            child: CupertinoAlertDialog(
              title: const CupertinoActivityIndicator(),
              content: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode
                        ? ColorManager.whiteColor
                        : ColorManager.blackColor,
                  ),
                ),
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
            backgroundColor: isDarkMode
                ? ColorManager.blackColor.withOpacity(0.8)
                : ColorManager.whiteColor.withOpacity(0.9),
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
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode
                      ? ColorManager.whiteColor
                      : ColorManager.blackColor,
                ),
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
    bool? barrierDismissible,
    Color posColor = ColorManager.dialogBlueColor,
    Color negColor = ColorManager.dialogRedColor,
    Color thirdColor = ColorManager.dialogBlueColor,
  }) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    List<Widget> actions = [];

    // Build Actions
    if (posActionTitle != null) {
      actions.add(
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            posAction?.call();
          },
          child: Text(
            posActionTitle,
            style: TextStyle(
              color: posColor,
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
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
            style: TextStyle(
              color: thirdColor,
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
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
            style: TextStyle(
              color: negColor,
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
        ),
      );
    }

    // Add dividers for iOS style
    List<Widget> actionsWithSeparators = [];

    for (int i = 0; i < actions.length; i++) {
      actionsWithSeparators.add(actions[i]);
      if (i < actions.length - 1) {
        actionsWithSeparators.add(
          Divider(
            color: isDarkMode
                ? ColorManager.whiteColor.withOpacity(0.1)
                : ColorManager.blackColor.withOpacity(0.2),
            thickness: 0.6,
          ),
        );
      }
    }

    if (Platform.isIOS || Platform.isMacOS) {
      // iOS Style
      showCupertinoDialog(
        barrierDismissible: barrierDismissible ?? false,
        context: context,
        builder: (BuildContext context) {
          return CupertinoTheme(
            data: CupertinoThemeData(
              brightness: isDarkMode ? Brightness.dark : Brightness.light,
              primaryColor:
                  isDarkMode ? ColorManager.whiteColor : ColorManager.blueColor,
              scaffoldBackgroundColor: isDarkMode
                  ? ColorManager.blackColor.withOpacity(0.8)
                  : ColorManager.whiteColor.withOpacity(0.8),
            ),
            child: CupertinoAlertDialog(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Center(
                  child: Text(
                    title ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode
                          ? ColorManager.whiteColor
                          : ColorManager.blackColor,
                    ),
                  ),
                ),
              ),
              content: Container(
                padding: const EdgeInsets.only(top: 4.0, bottom: 6.0),
                child: Text(
                  message ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode
                        ? ColorManager.whiteColor.withOpacity(0.7)
                        : ColorManager.blackColor.withOpacity(0.87),
                  ),
                ),
              ),
              actions: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: actionsWithSeparators,
                ),
              ],
            ),
          );
        },
      );
    } else {
      // Android Style
      showDialog(
        barrierDismissible: barrierDismissible ?? false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: isDarkMode
                ? ColorManager.blackColor.withOpacity(0.8)
                : ColorManager.whiteColor.withOpacity(0.9),
            title: Text(
              title ?? '',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDarkMode
                    ? ColorManager.whiteColor
                    : ColorManager.blackColor,
              ),
            ),
            content: Text(
              message ?? '',
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode
                    ? ColorManager.whiteColor.withOpacity(0.7)
                    : ColorManager.blackColor.withOpacity(0.87),
              ),
            ),
            actions: actions,
          );
        },
      );
    }
  }
}
