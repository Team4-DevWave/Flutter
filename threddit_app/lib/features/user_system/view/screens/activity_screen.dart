import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_system/model/notification_settings_model.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/view/widgets/enable_setting.dart';
import 'package:threddit_clone/features/user_system/view/widgets/settings_title.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/theme/text_styles.dart';

/// Notification screen has the options renders the options that the user
/// can use to turn on/off the notifcations he wants/doesn't want.
class ActivityScreen extends ConsumerStatefulWidget {
  final String subredditName;
  const ActivityScreen({super.key, required this.subredditName});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
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

  void toggleNotificationSettings(bool isEnabled) async {
    notificationOn(client: client, isEnabled: isEnabled, token: token!);
    setState(() {
      ref
          .watch(settingsFetchProvider.notifier)
          .getNotificationSetting(client: client);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Activity")),
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
              final isEnabled = snapshot.data!;
              Activity activitySettings =
                  isEnabled.subredditsUserMods[widget.subredditName]!.activity;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    EnableSetting(
                      isEnabled: activitySettings.newPosts,
                      optionName: "New posts",
                      settingIcon: Icons.file_copy,
                      enable: () {},
                    ),
                    ListTile(
                        title: const Text("Posts with Upvotes"),
                        titleTextStyle: AppTextStyles.primaryTextStyle,
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          final arguements = {
                            'subredditName': widget.subredditName,
                            'title': "Posts with Upvotes",
                          };
                          Navigator.pushNamed(
                              context, RouteClass.postNotifications,
                              arguments: arguements);
                        }),
                        ListTile(
                        title: const Text("Posts with Comments"),
                        titleTextStyle: AppTextStyles.primaryTextStyle,
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          final arguements = {
                            'subredditName': widget.subredditName,
                            'title': "Posts with Comments",
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
