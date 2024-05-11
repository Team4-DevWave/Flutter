import 'package:flutter/material.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

/// This class represents the layout of the buttons of the
/// right drawer, It takes the Button's [icon],[title],[onTap] function
/// and sets it for each button in the drawer.

class RightDrawerButtons extends StatelessWidget {
  // ignore: lines_longer_than_80_chars
  const RightDrawerButtons(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap});

  final Icon icon;
  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        splashColor: AppColors.whiteColor,
        onTap: onTap,
        child: Row(children: [
          icon,
          const SizedBox(width: 20),
          Text(
            title,
            style: AppTextStyles.secondaryTextStyle,
          ),
        ]),
      ),
    );
  }
}
