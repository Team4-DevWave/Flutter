import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/user_system/model/notification_settings_model.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/view/widgets/enable_setting.dart';
import 'package:threddit_clone/features/user_system/view/widgets/settings_title.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:http/http.dart' as http;

/// Notification screen has the options renders the options that the user
/// can use to turn on/off the notifcations he wants/doesn't want.
class NotificationsSettingsScreen extends ConsumerStatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  ConsumerState<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends ConsumerState<NotificationsSettingsScreen> {
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
      appBar: AppBar(title: const Text("Notifications")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<NotificationsSettingsModel>(
          future: isNotificationEnabled(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()),);
            } else {
              final isEnabled = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SettingsTitle(title: "MESSAGES"),
                    EnableSetting(
                      isEnabled: isEnabled.privateMessages,
                      optionName: "Private messages",
                      settingIcon: Icons.mail,
                      enable: () => toggleNotificationSettings(
                          !isEnabled.privateMessages),
                    ),
                    EnableSetting(
                        isEnabled: isEnabled.chatMessages,
                        optionName: "Chat messages",
                        settingIcon: Icons.chat,
                        enable: () {}),
                    EnableSetting(
                        isEnabled: isEnabled.chatRequests,
                        optionName: "Chat requests",
                        settingIcon: Icons.chat_bubble_outline,
                        enable: () {}),
                    const SettingsTitle(title: "ACTIVITY"),
                    EnableSetting(
                        isEnabled: isEnabled.mentionsOfUsername,
                        optionName: "Mentions of u/username",
                        settingIcon: Icons.person,
                        enable: () {}),
                    EnableSetting(
                        isEnabled: isEnabled.commentsOnYourPost,
                        optionName: "Comments on your posts",
                        settingIcon: Icons.comment,
                        enable: () {}),
                    EnableSetting(
                        isEnabled: isEnabled.upvotesOnYourPost,
                        optionName: "Upvotes on your posts",
                        settingIcon: Icons.arrow_upward,
                        enable: () {}),
                    EnableSetting(
                    isEnabled: isEnabled.upvotesOnYourComments,
                    optionName: "Upvotes on your comments",
                    settingIcon: Icons.arrow_upward_sharp,
                    enable: () {}),
                    // EnableSetting(
                    //     isEnabled: isEnabled.repliesToYourComments,
                    //     optionName: "Replies to your comments",
                    //     settingIcon: Icons.reply,
                    //     enable: () {}),
                    EnableSetting(
                      isEnabled: isEnabled.newFollowers,
                      optionName: "New followers",
                      settingIcon: Icons.person,
                      enable: () {},
                    ),
                    // EnableSetting(
                    //     isEnabled: isEnabled,
                    //     optionName: "Cake day",
                    //     settingIcon: Icons.cake,
                    //     enable: () {}),
                    const SettingsTitle(title: "MODERATION"),
                    EnableSetting(
                        isEnabled: isEnabled.modNotifications,
                        optionName: "Mod notifications",
                        settingIcon: Icons.shield,
                        enable: () {}),
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
