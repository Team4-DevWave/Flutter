import 'package:flutter/material.dart';
import 'package:threddit_app/theme/photos.dart';
import 'package:threddit_app/theme/text_styles.dart';

class RegisterAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RegisterAppBar({super.key, required this.action, required this.title});

  final Function() action;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(
        child: Photos.appBarLogo,
      ),
      actions: [
        TextButton(
            onPressed: action,
            child: Text(
              title,
              style: AppTextStyles.primaryTextStyle,
            )),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
