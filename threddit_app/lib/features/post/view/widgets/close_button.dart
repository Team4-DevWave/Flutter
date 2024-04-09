import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/view_model/home_page_provider.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class ClosedButton extends ConsumerWidget {
  const ClosedButton(
      {super.key,
      required this.resetAll,
      required this.firstScreen,
      required this.titleController,
      required this.isImage,
      required this.isLink,
      required this.isVideo});
  final void Function() resetAll;
  final TextEditingController titleController;
  final bool isImage;
  final bool isVideo;
  final bool isLink;
  final bool firstScreen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
        onPressed: () {
          if (titleController != TextEditingController(text: "") &&
              (isLink || isImage || isVideo)) {
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
                          firstScreen
                              ? ref
                                  .read(currentScreenProvider.notifier)
                                  .returnToPrevious()
                              : ref
                                  .read(currentScreenProvider.notifier)
                                  .updateCurrentScreen(0);
                          Navigator.pushReplacementNamed(
                              context, RouteClass.mainLayoutScreen);
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
            firstScreen
                ? ref.read(currentScreenProvider.notifier).returnToPrevious()
                : ref
                    .read(currentScreenProvider.notifier)
                    .updateCurrentScreen(0);
            Navigator.pushReplacementNamed(
                context, RouteClass.mainLayoutScreen);
          }
        },
        icon: const Icon(Icons.close));
  }
}
