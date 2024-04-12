import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/post/viewmodel/share_post_provider.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class ExitShare extends ConsumerWidget {
  const ExitShare({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onExit() {
      for (int i = 0; i <= ref.watch(popCounter); i++) {
        Navigator.pop(context);
      }
      ref.read(isFirstTimeEnter.notifier).update((state) => true);
      ref.read(popCounter.notifier).update((state) => state = 1);
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
                content: Text(
                  "Discard crosspost submission?",
                  style: AppTextStyles.primaryButtonGlowTextStyle,
                ),
                actions: [
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.transparent)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel",
                          style: AppTextStyles.buttonTextStyle
                              .copyWith(color: AppColors.whiteColor))),
                  ElevatedButton(
                    onPressed: onExit,
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(AppColors.errorColor)),
                    child: Text(
                      "Discard",
                      style: AppTextStyles.buttonTextStyle,
                    ),
                  ),
                ],
              );
            });
      },
      icon: Icon(Icons.close, size: 27.sp),
    );
  }
}
