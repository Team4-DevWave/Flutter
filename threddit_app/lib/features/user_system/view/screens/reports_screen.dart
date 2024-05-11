import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_system/model/notification_settings_model.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/theme/text_styles.dart';
/// This screen allows users to configure notification settings for reports in a specific subreddit.
/// Users can enable or disable notifications for various types of reports, such as posts and comments by navigating to each screen.
/// 
class ReportsScreen extends ConsumerStatefulWidget {
  final String subredditName;
  const ReportsScreen({super.key, required this.subredditName});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  final client = http.Client();
  String? token;
  Future<NotificationsSettingsModel> isNotificationEnabled() async {
    setState(() {
      ref
          .watch(settingsFetchProvider.notifier)
          .getNotificationSetting(client: client);
    });
    return ref
        .watch(settingsFetchProvider.notifier)
        .getNotificationSetting(client: client);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reports")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<NotificationsSettingsModel>(
          future: isNotificationEnabled(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                        title: const Text("Posts"),
                        titleTextStyle: AppTextStyles.primaryTextStyle,
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          final arguements = {
                            'subredditName': widget.subredditName,
                            'title': "Posts",
                          };
                          Navigator.pushNamed(
                              context, RouteClass.postNotifications,
                              arguments: arguements);
                        }),
                    ListTile(
                        title: const Text("Comments"),
                        titleTextStyle: AppTextStyles.primaryTextStyle,
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          final arguements = {
                            'subredditName': widget.subredditName,
                            'title': "Comments",
                          };
                          Navigator.pushNamed(
                              context, RouteClass.postNotifications,
                              arguments: arguements);
                        }),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
