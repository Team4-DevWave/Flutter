import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/view_model/home_page_provider.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

/// A button widget for closing post submission and navigation.
class ClosedButton extends ConsumerWidget {
  /// Constructs a new [ClosedButton] instance.
  ///
  /// All parameters are required.
  const ClosedButton(
      {super.key,
      required this.resetAll,
      required this.firstScreen,
      required this.titleController,
      required this.isImage,
      required this.isLink,
      required this.isVideo,
      required this.isPoll});
  final void Function() resetAll;

  /// Controller for the post title input field.
  final TextEditingController titleController;

  /// Flag indicating whether an image is attached to the post.
  final bool isImage;

  /// Flag indicating whether a video is attached to the post.
  final bool isVideo;

  /// Flag indicating whether a link is attached to the post.
  final bool isLink;
  final int firstScreen;
  final bool isPoll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onExitPressed() {
      if (firstScreen == 0) {
        ref.watch(currentScreenProvider.notifier).updateCurrentScreen(0);
        Navigator.pushReplacementNamed(context, RouteClass.mainLayoutScreen);
      } else if (firstScreen == 1) {
        ref.watch(currentScreenProvider.notifier).returnToPrevious();
        Navigator.pushReplacementNamed(context, RouteClass.mainLayoutScreen);
      } else {
        Navigator.pop(context);
      }
    }

    return IconButton(
        onPressed: () {
          if (titleController != TextEditingController(text: "") &&
              (isLink || isImage || isVideo || isPoll)) {
            showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    surfaceTintColor: AppColors.backgroundColor,
                    backgroundColor: AppColors.backgroundColor,
                    actionsAlignment: MainAxisAlignment.spaceBetween,
                    shadowColor: AppColors.backgroundColor,
                    content: Text(
                      "Discard post submission?",
                      style: AppTextStyles.primaryButtonGlowTextStyle,
                    ),
                    actions: [
                      ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.transparent)),
                          onPressed: () {
                            ///close the dialog
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel",
                              style: AppTextStyles.buttonTextStyle
                                  .copyWith(color: AppColors.whiteColor))),
                      ElevatedButton(
                        onPressed: () {
                          onExitPressed();
                          resetAll();
                        },
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
          } else {
            onExitPressed();
            resetAll();
          }
        },
        icon: const Icon(Icons.close));
  }
}
