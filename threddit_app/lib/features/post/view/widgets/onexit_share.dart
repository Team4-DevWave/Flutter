import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/post/viewmodel/share_post_provider.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

/// A widget representing an exit button for discarding post submissions.
///
/// This widget displays an exit button with a close icon. When pressed, it
/// shows an AlertDialog to confirm discarding a post submission. The dialog
/// includes "Cancel" and "Discard" buttons, which respectively cancel or
/// execute the exit action.
///
/// The exit action is managed through a function named `onExit()`, which
/// pops the current screen from the navigation stack based on the `popCounter`
/// state and updates other states related to post sharing.
///
/// Usage:
/// ```dart
/// ExitShare()
/// ```
class ExitShare extends ConsumerWidget {
  /// Constructs a [ExitShare] widget.
  const ExitShare({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Handles the action to be executed when exiting the post submission.
    ///
    /// This function pops the current screen from the navigation stack based
    /// on the `popCounter` state. It also updates the `isFirstTimeEnter`
    /// state to true and resets the `popCounter` state to 1.
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
      icon: Icon(Icons.close, size: 27.spMin),
    );
  }
}
