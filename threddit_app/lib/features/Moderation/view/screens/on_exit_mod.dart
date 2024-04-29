import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class ExitMod extends ConsumerWidget {
  const ExitMod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onDiscard() {
      Navigator.pop(context);
      Navigator.pop(context);
    }

    void onKeepEditing() {
      Navigator.pop(context);
    }

    return IconButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                surfaceTintColor: AppColors.backgroundColor,
                backgroundColor: AppColors.backgroundColor,
                actionsAlignment: MainAxisAlignment.spaceBetween,
                shadowColor: AppColors.backgroundColor,
                title: Text(
                  "Leave without saving",
                  style: AppTextStyles.primaryButtonGlowTextStyle,
                ),
                content: Text(
                  "You cannot undo this action",
                  style: AppTextStyles.primaryTextStyle,
                ),
                actions: [
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.transparent)),
                      onPressed: onKeepEditing,
                      child: Text("Cancel",
                          style: AppTextStyles.buttonTextStyle
                              .copyWith(color: AppColors.whiteColor))),
                  ElevatedButton(
                    onPressed: onDiscard,
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(AppColors.blueColor)),
                    child: Text(
                      "Leave",
                      style: AppTextStyles.buttonTextStyle
                          .copyWith(color: AppColors.whiteGlowColor),
                    ),
                  ),
                ],
              );
            });
      },
      icon: Icon(Icons.arrow_back, size: 27.spMin),
    );
  }
}
