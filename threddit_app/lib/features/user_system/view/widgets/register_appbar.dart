import 'package:flutter/material.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/photos.dart';
import 'package:threddit_clone/theme/text_styles.dart';

///The [RegisterAppBar] is the registeration screens app bar
///
///It contains on the top [Photos.appBarLogo] where this is the reddit official icon
///
///Also contains [action] which is the function to be excuted if the button that
///holds the [title] passed.
class RegisterAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RegisterAppBar({super.key, required this.action, required this.title});

  final Function() action;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundColor,
      title: Center(
        child: Photos.appBarLogo,
      ),
      actions: [
        TextButton(
          onPressed: action,
          child: Text(
            title,
            style: AppTextStyles.primaryTextStyle,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
