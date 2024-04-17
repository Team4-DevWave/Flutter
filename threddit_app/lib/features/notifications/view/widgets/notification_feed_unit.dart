import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/theme/text_styles.dart';

/// The `NotificationFeedUnit` is a StatefulWidget that represents a single notification unit in the feed. This widget is designed to be used in the notifications screen of the application. It consists of a user avatar, an add icon, and a couple of text messages.
///
/// The avatar is a circular image fetched from a network source. The add icon is positioned at the bottom right of the avatar. The text messages are displayed in a column, with the first one styled as bold and the second one as secondary.
///
/// The entire widget is wrapped in a Padding widget for spacing and a SizedBox to constrain its height. The widget's state is managed by `_NotificationFeedUnitState`, which builds the widget's UI.
class NotificationFeedUnit extends StatefulWidget {
  const NotificationFeedUnit({super.key});

  @override
  State<NotificationFeedUnit> createState() => _NotificationFeedUnitState();
}

class _NotificationFeedUnitState extends State<NotificationFeedUnit> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
          height: 50.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(right: 10.w),
                child: Stack(
                  children: [
                    ClipOval(
                      child: Image.network(
                        "https://images.unsplash.com/photo-1712460842246-0a79c9bd48e7?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                        fit: BoxFit.cover,
                        width: 35
                            .w, // You can adjust width and height to your needs
                        height: 35.h,
                      ),
                    ),
                    const Positioned(
                      bottom: -5,
                      right: -5,
                      child: Icon(Icons.add,
                          color:
                              Colors.white), // This is the icon you want to add
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Abo laly",
                    style: AppTextStyles.boldTextStyleNotifcation,
                  ),
                  Text(
                    "wants to follow you",
                    style: AppTextStyles.secondaryTextStylenotifications,
                  ),
                ],
              )
            ],
          )),
    );
  }
}
