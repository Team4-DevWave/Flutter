import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

/// A stateless widget that displays a message when there are no notifications.
///
/// The `EmptyNotification` widget includes an image, a title, a description,
/// and a container with a border radius. The image is loaded from the assets,
/// and the title and description are hardcoded.
///
/// The `EmptyNotification` widget is typically used in a notifications screen
/// to display a message when the user doesn't have any notifications.
class NoNotification extends StatelessWidget {
  /// Creates an `EmptyNotification` widget.
  const NoNotification({super.key});

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
          key: const Key('fortest'),
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
            onPressed: () {
              // Navigate to the community page
              Navigator.pushNamed(context, RouteClass.mainCommunityScreen);
            },
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
