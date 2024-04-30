import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/notifications/view_model/fetching_notifications.dart';
import 'package:threddit_clone/features/notifications/view_model/methods.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class NotificationFeedUnit extends StatefulWidget {
  final NotificationData data;
  const NotificationFeedUnit({super.key, required this.data});

  @override
  State<NotificationFeedUnit> createState() => _NotificationFeedUnitState();
}

class _NotificationFeedUnitState extends State<NotificationFeedUnit> {
  bool _seen = false;

  @override
  void initState() {
    // TODO: implement initState
    _seen = widget.data.read;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 5.h,
        ),
        InkWell(
          onTap: () {
            markAsRead(widget.data.id);
            setState(() {
              _seen = true;
            });
          },
          child: Container(
              decoration: BoxDecoration(
                color: !_seen
                    ? const Color.fromARGB(24, 255, 255, 255)
                    : const Color.fromARGB(0, 255, 255, 255),
                borderRadius: BorderRadius.circular(10.sp),
              ),
              height: 75.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      //username  widget.data.content.split(' ')[0].substring(2)
                      // print(widget.data.content.split(' ')[0].substring(2));
                    },
                    child: Container(
                      padding:
                          EdgeInsets.only(right: 10.w, top: 10.h, left: 5.w),
                      child: Stack(
                        children: [
                          ClipOval(
                            child: Image.network(
                              "https://images.unsplash.com/photo-1712460842246-0a79c9bd48e7?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                              fit: BoxFit.cover,
                              width: 45
                                  .w, // You can adjust width and height to your needs
                              height: 45.h,
                            ),
                          ),
                          Positioned(
                            bottom: -5,
                            right: -5,
                            child: Icon(
                                widget.data.type == "follow"
                                    ? Icons.add
                                    : Icons.comment,
                                color: Colors
                                    .white), // This is the icon you want to add
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.data.content.split(' ')[0],
                          style: AppTextStyles.boldTextStyleNotifcation,
                        ),
                        Text(
                          widget.data.content.split(' ').sublist(1).join(' '),
                          style: AppTextStyles.secondaryTextStylenotifications,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
        SizedBox(
          height: 5.h,
        ),
        const Divider(
          color: Colors.grey,
          height: 2,
        ),
      ],
    );
  }
}
