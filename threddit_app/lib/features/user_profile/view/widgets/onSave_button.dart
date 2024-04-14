import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/features/user_system/view_model/user_settings_provider.dart';
import 'package:threddit_clone/theme/colors.dart';

class SaveButton extends ConsumerWidget {
  const SaveButton({super.key, required this.changed});
  final bool changed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: changed
          ? () async {
              final response =
                  await ref.read(userProfileProvider.notifier).updateUserData();
              response.fold((l) {
                showSnackBar(navigatorKey.currentContext!, l.message);
              }, (r) {
                showSnackBar(navigatorKey.currentContext!, "User Data Saved!");
              });
            }
          : null,
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
