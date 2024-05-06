import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/post/viewmodel/post_provider.dart';
import 'package:threddit_clone/theme/colors.dart';

/// A widget for displaying an image with an option to remove it.
class AddImageWidget extends ConsumerWidget {
  /// Constructs a new [AddImageWidget] widget.
  ///
  /// The [onPressed] parameter is required and represents the function to be called
  /// when the remove button is pressed. The [imagePath] parameter is required and
  /// represents the file path of the image to be displayed.
  const AddImageWidget(
      {super.key, required this.onPressed, required this.imagePath});

  /// Callback function triggered when the remove button is pressed.
  final Function()? onPressed;

  /// The file path of the image to be displayed.
  final File imagePath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(clipBehavior: Clip.hardEdge, children: [
      ConstrainedBox(
          constraints: BoxConstraints.loose(const Size.fromHeight(400)),
          child: Image.file(imagePath)),
      Positioned(
        top: 0,
        right: 0,
        child: IconButton(
          onPressed: () {
            onPressed!.call();
            ref.read(postDataProvider.notifier).removeImages();
          },
          icon: const Icon(Icons.close, color: AppColors.whiteGlowColor),
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                  AppColors.mainColor.withOpacity(0.5))),
        ),
      )
    ]);
  }
}
