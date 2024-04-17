import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:threddit_clone/features/notifications/view/widgets/empty_notification.dart';
import 'package:threddit_clone/features/notifications/view/widgets/notification_feed_unit.dart';
import 'package:threddit_clone/features/notifications/view_model/fetching_notifications.dart';
import 'package:threddit_clone/theme/colors.dart';

/// The `NotificationFeed` is a StatefulWidget that represents the notification feed in the application.
/// This widget takes a user ID as a parameter and fetches the corresponding notifications for that user.
///
/// The widget's state is managed by `_NotificationFeedState`, which initializes the `futuredata` variable
/// in its `initState` method. The `futuredata` variable holds the future that fetches the notifications data.
///
/// The `build` method of `_NotificationFeedState` returns a `Container` widget with a `FutureBuilder`.
/// The `FutureBuilder` takes `futuredata` as its future and builds the UI based on the state of the future. If the future is still loading, it displays a loading animation. If the future completes with an error, it displays the error message. If the future completes with data, it checks the length of the data and either displays a `ListView` of `NotificationFeedUnit` widgets or a `NoNotification` widget. If the future completes without data, it displays a 'No data available.' message.
class NotificationFeed extends StatefulWidget {
  final String userID;
  const NotificationFeed({super.key, required this.userID});

  @override
  State<NotificationFeed> createState() => _NotificationFeedState();
}

class _NotificationFeedState extends State<NotificationFeed> {
  late Future<NotificationAPI> futuredata;

  @override
  void initState() {
    super.initState();

    futuredata = fetchdata(widget.userID);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.backgroundColor,
        child: FutureBuilder<NotificationAPI>(
          future: futuredata,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.asset(
                  'assets/animation/loading.json',
                  repeat: true,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else if (snapshot.hasData) {
              final countryData = snapshot.data!.result;

              return (countryData.length == 6)
                  ? ListView.builder(
                      itemCount: countryData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return const NotificationFeedUnit();
                      },
                    )
                  : const NoNotification();
            } else {
              return const Text('No data available.');
            }
          },
        ));
  }
}
