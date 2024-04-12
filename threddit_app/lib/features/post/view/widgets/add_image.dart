
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/post/viewmodel/post_provider.dart';
import 'package:threddit_clone/theme/colors.dart';

class AddImageWidget extends ConsumerWidget {
  const AddImageWidget(
      {super.key, required this.onPressed, required this.imagePath});
  final Function()? onPressed;
  final File imagePath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //i want to make sure if the backend takes a list of images or just one image?

    return Stack(clipBehavior: Clip.hardEdge, children: [
      ConstrainedBox(
        constraints: BoxConstraints.loose(const Size.fromHeight(400)),
        child: Image.file(imagePath)
      ),
      Positioned(
        top: 0,
        right: 0,
        child: IconButton(
          onPressed: (){
            onPressed!.call();
            ref.read(postDataProvider.notifier).removeImages();
          },
          icon: const Icon(Icons.close, color: AppColors.whiteGlowColor),
          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(AppColors.mainColor.withOpacity(0.5))),
        ),
      )
    ]);
  }
}
