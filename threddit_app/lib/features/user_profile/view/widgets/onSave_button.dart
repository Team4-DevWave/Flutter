import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/theme/colors.dart';

class SaveButton extends ConsumerWidget {
  const SaveButton({super.key, required this.changed});
  final bool changed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: changed ? () {} : null,
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(changed
            ? AppColors.redditOrangeColor
            : const Color.fromARGB(255, 30, 31, 31)),
      ),
      child: Text(
        "Save",
        style: TextStyle(color: changed ? Colors.white : AppColors.whiteColor),
      ),
    );
  }
}
