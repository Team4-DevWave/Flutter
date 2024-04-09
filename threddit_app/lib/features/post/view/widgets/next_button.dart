import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/post/viewmodel/post_provider.dart';
import 'package:threddit_clone/theme/colors.dart';

class NextButton extends ConsumerWidget {
  const NextButton({super.key, required this.titleController});
  final TextEditingController titleController;
  Color textColor() {
    return titleController.text.trim().isEmpty
        ? AppColors.whiteColor
        : Colors.white;
  }

  Color backgroundColor() {
    return titleController.text.trim().isEmpty
        ? const Color.fromARGB(255, 30, 31, 31)
        : AppColors.redditOrangeColor;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isValid = (titleController.text.trim().isNotEmpty &&
        (ref.watch(validLink) || ref.watch(postDataProvider)!.link == ""));
    return ElevatedButton(
      onPressed: isValid
          ? () {
            //there is a problem that we don't know if there is actually a link or not
            //so we need correctly know if there is a link then this part is done
              Navigator.pushNamed(context, RouteClass.postToScreen);
            }
          : null,
      //the button is greyed out at first until the user enters a title
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(isValid
            ? AppColors.redditOrangeColor
            : const Color.fromARGB(255, 30, 31, 31)),
      ),
      child: Text("Next",
          style:
              TextStyle(color: isValid ? Colors.white : AppColors.whiteColor)),
    );
  }
}
