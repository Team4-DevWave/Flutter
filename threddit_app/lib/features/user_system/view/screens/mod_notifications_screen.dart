import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_system/model/notification_settings_model.dart';
import 'package:threddit_clone/features/user_system/view/widgets/enable_setting.dart';
import 'package:threddit_clone/features/user_system/view/widgets/settings_title.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/theme/text_styles.dart';

/// Notification screen has the options renders the options that the user
/// can use to turn on/off the notifcations he wants/doesn't want.
class ModNotificationsSettingsScreen extends ConsumerStatefulWidget {
  final String subredditName;
  const ModNotificationsSettingsScreen(
      {super.key, required this.subredditName});

  @override
  ConsumerState<ModNotificationsSettingsScreen> createState() =>
      _ModNotificationsSettingsScreenState();
}

class _ModNotificationsSettingsScreenState
    extends ConsumerState<ModNotificationsSettingsScreen> {
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
      appBar: AppBar(title: const Text("Mod Notifications")),
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
              SubredditSettings? notifiSettings =
                  isEnabled.subredditsUserMods[widget.subredditName];
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SettingsTitle(
                        title:
                            "Manage what mod notifications you recieve for r/${widget.subredditName}"),
                    EnableSetting(
                      isEnabled: notifiSettings!.allowModNotifications,
                      optionName: "Allow notifications",
                      settingIcon: Icons.mail,
                      enable: () => toggleNotificationSettings(
                          !isEnabled.privateMessages),
                    ),
                    const SettingsTitle(title: "ACTIVITY & COMMUNICATIONS"),
                    ListTile(
                        title: const Text("Activity"),
                        titleTextStyle: AppTextStyles.primaryTextStyle,
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          final arguements = {
                            'subredditName': widget.subredditName,
                          };
                          Navigator.pushNamed(
                              context, RouteClass.activitySettings,
                              arguments: arguements);
                        }),
                    ListTile(
                        title: const Text("Mod Mail"),
                        titleTextStyle: AppTextStyles.primaryTextStyle,
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          final arguements = {
                            'subredditName': widget.subredditName,
                          };
                          Navigator.pushNamed(context, RouteClass.modMail,
                              arguments: arguements);
                        }),
                    ListTile(
                        title: const Text("Reports"),
                        titleTextStyle: AppTextStyles.primaryTextStyle,
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          final arguements = {
                            'subredditName': widget.subredditName,
                          };
                          Navigator.pushNamed(
                              context, RouteClass.reportSettings,
                              arguments: arguements);
                        })
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
