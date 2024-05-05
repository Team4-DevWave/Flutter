/// A Flutter widget that displays a feed of notifications.
///
/// This widget is typically used in a notifications screen to display a list of notifications.
/// It includes a `ConsumerStatefulWidget` that fetches the notifications and displays them in a list.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lottie/lottie.dart';
import 'package:threddit_clone/features/notifications/view/widgets/empty_notification.dart';
import 'package:threddit_clone/features/notifications/view/widgets/notification_feed_unit.dart';

import 'package:threddit_clone/features/notifications/view_model/fetching_notifications.dart';

import 'package:threddit_clone/theme/colors.dart';

/// A stateful widget that displays a feed of notifications.
///
/// The `NotificationFeed` widget takes a user ID as a parameter and fetches the notifications
/// for that user. The notifications are displayed in a list using the `NotificationFeedUnit` widget.
///
/// The `NotificationFeed` widget is typically used in a notifications screen to display a list of notifications.
class NotificationFeed extends ConsumerStatefulWidget {
  /// The ID of the user for whom to fetch notifications.
  final String userID;

  /// Creates a `NotificationFeed` widget.
  ///
  /// The [userID] parameter must not be null.
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
    return Column(
      children: [
        Expanded(
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

                  return (countryData.isNotEmpty)
                      ? ListView.builder(
                          itemCount: countryData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return NotificationFeedUnit(
                                data: countryData[index],
                                userID: widget.userID);
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
        ),
      ],
    );
  }
}
