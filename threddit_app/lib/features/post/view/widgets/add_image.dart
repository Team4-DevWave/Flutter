import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:threddit_clone/theme/colors.dart';

class AddImageWidget extends ConsumerWidget {
  const AddImageWidget(
      {super.key, required this.onPressed, required this.imagesList});
  final Function()? onPressed;
  final List<XFile> imagesList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //i want to make sure if the backend takes a list of images or just one image?
    //PostData? post = ref.read(postDataProvider)

    return Stack(clipBehavior: Clip.hardEdge, children: [
      ConstrainedBox(
        constraints: BoxConstraints.loose(const Size.fromHeight(400)),
        child: ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            scrollDirection: Axis.horizontal,
            itemCount: imagesList.length,
            itemBuilder: (context, index) {
              return Image.file(
                File(imagesList[index].path),
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              );
            }),
      ),
      Positioned(
        top: 0,
        right: 0,
        child: IconButton(
          onPressed: onPressed,
          icon: const Icon(Icons.close, color: AppColors.whiteGlowColor),
          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(AppColors.mainColor.withOpacity(0.5))),
        ),
      )
    ]);
  }
}
