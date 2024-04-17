import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

/// The [NoNotification] widget is a [StatelessWidget] that displays a message when there are no notifications.
///
/// It displays an image, a title, a description, and a button to check communities.
class NoNotification extends StatelessWidget {
  const NoNotification({super.key});

  /// The build method describes the part of the user interface represented by this widget.
  ///
  /// It returns a [Center] widget that contains a [Column] with an image, a title, a description, and a button.
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            child: Image(
                height: 150.h,
                width: 150.w,
                image:
                    const AssetImage('assets/images/snoovatar-full-hi.png'))),
        SizedBox(
          height: 10.h,
        ),
        Text(
          'You don\'t have any activity yet',
          style: AppTextStyles.boldTextStyle,
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          "That's okay, maybe you just need the right inspiration. Check out a popular community for discussion.",
          style: AppTextStyles.secondaryTextStyle,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10.h,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10), // set the border radius
          ),
          child: TextButton(
            onPressed: () {},
            child: const Text(
              'Check Communites',
              style: TextStyle(color: AppColors.redditOrangeColor),
            ),
          ),
        )
      ],
    ));
  }
}
