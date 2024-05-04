import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:threddit_clone/features/notifications/view/widgets/empty_notification.dart';
import 'package:threddit_clone/features/notifications/view/widgets/notification_feed_unit.dart';
import 'package:threddit_clone/features/notifications/view_model/count_notifications.dart';
import 'package:threddit_clone/features/notifications/view_model/fetching_notifications.dart';
import 'package:threddit_clone/features/notifications/view_model/notification_optian.dart';
import 'package:threddit_clone/theme/colors.dart';

class NotificationFeed extends ConsumerStatefulWidget {
  final String userID;
  const NotificationFeed({Key? key, required this.userID}) : super(key: key);

  @override
  _NotificationFeedState createState() => _NotificationFeedState();
}

class _NotificationFeedState extends ConsumerState<NotificationFeed> {
  late Future<NotificationAPI> futuredata;

  @override
  void initState() {
    super.initState();

    futuredata = fetchDataNotifications(widget.userID);
  }

  @override
  Widget build(BuildContext context) {
    //final notificationsRead = ref.watch(markAllNotificationsAsReadProvider);
    return Expanded(
      child: Container(
        color: AppColors.backgroundColor,
        child: FutureBuilder<NotificationAPI>(
          future: futuredata,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.asset(
                  'assets/animation/loading2.json',
                  repeat: true,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else if (snapshot.hasData) {
              final countryData = snapshot.data!.notifications;

              return (countryData.length > 0)
                  ? ListView.builder(
                      itemCount: countryData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return NotificationFeedUnit(
                          data: countryData[index],
                        );
                      },
                    )
                  : const NoNotification();
            } else {
              return const Text(
                'No data available.',
              );
            }
          },
        ),
      ),
    );
  }
}
