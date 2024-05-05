import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

/// A widget for displaying an exit button when editing a post.
///
/// This widget displays an IconButton that, when pressed, shows a dialog
/// asking the user if they want to discard their changes or keep editing.
class ExitEdit extends ConsumerWidget {
  /// Constructs a [ExitEdit] widget.
  const ExitEdit({super.key});

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
                content: Text(
                  "Do you want to discard your changes?",
                  style: AppTextStyles.primaryButtonGlowTextStyle,
                ),
                actions: [
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.transparent)),
                      onPressed: onKeepEditing,
                      child: Text("Keep editing",
                          style: AppTextStyles.buttonTextStyle
                              .copyWith(color: AppColors.whiteColor))),
                  ElevatedButton(
                    onPressed: onDiscard,
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(AppColors.blueColor)),
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
