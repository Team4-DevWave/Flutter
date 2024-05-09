import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_system/model/notification_settings_model.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/view/screens/mod_notifications_screen.dart';
import 'package:threddit_clone/features/user_system/view/widgets/enable_setting.dart';
import 'package:threddit_clone/features/user_system/view/widgets/settings_title.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

/// Notification screen has the options renders the options that the user.
/// can use to turn on/off the notifcations he wants/doesn't want.
/// Then it renders the subreddits that the user is a moderator in and the user can press on to get redirected to each subreddit's specific mod notification.
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

  List<Widget> buildListTileWidgets(
      Map<String, SubredditSettings> subredditUserMods) {
    return subredditUserMods.entries.map((entry) {
      final subredditName = entry.key;
      return ListTile(
          tileColor: Color.fromARGB(0, 19, 19, 19),
          contentPadding: EdgeInsets.only(left: 20.w),
          titleTextStyle: AppTextStyles.primaryTextStyle,
          title: Text("r/$subredditName"),
          onTap: () {
            final arguements = {
              'subredditName': subredditName,
            };
            Navigator.pushNamed(context, RouteClass.modNotificationsSettings,
                arguments: arguements);
          });
    }).toList();
  }

  @override
  void initState() {
    super.initState();
  }

  void toggleNotificationSettings(String settingName) async {
    notificationOn(client: client, settingName: settingName);
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
              return Center(
                child: Text(snapshot.error.toString()),
              );
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
                      enable: () =>
                          toggleNotificationSettings("privateMessages"),
                    ),
                    EnableSetting(
                        isEnabled: isEnabled.chatMessages,
                        optionName: "Chat messages",
                        settingIcon: Icons.chat,
                        enable: () =>
                            toggleNotificationSettings("chatMessages")),
                    EnableSetting(
                        isEnabled: isEnabled.chatRequests,
                        optionName: "Chat requests",
                        settingIcon: Icons.chat_bubble_outline,
                        enable: () =>
                            toggleNotificationSettings("chatRequests")),
                    const SettingsTitle(title: "ACTIVITY"),
                    EnableSetting(
                        isEnabled: isEnabled.mentionsOfUsername,
                        optionName: "Mentions of u/username",
                        settingIcon: Icons.person,
                        enable: () =>
                            toggleNotificationSettings("mentionsOfUsername")),
                    EnableSetting(
                        isEnabled: isEnabled.commentsOnYourPost,
                        optionName: "Comments on your posts",
                        settingIcon: Icons.comment,
                        enable: () =>
                            toggleNotificationSettings("commentsOnYourPost")),
                    EnableSetting(
                        isEnabled: isEnabled.upvotesOnYourPost,
                        optionName: "Upvotes on your posts",
                        settingIcon: Icons.arrow_upward,
                        enable: () =>
                            toggleNotificationSettings("upvotesOnYourPost")),
                    EnableSetting(
                        isEnabled: isEnabled.upvotesOnYourComments,
                        optionName: "Upvotes on your comments",
                        settingIcon: Icons.arrow_upward_sharp,
                        enable: () => toggleNotificationSettings(
                            "upvotesOnYourComments")),
                    // EnableSetting(
                    //     isEnabled: isEnabled.repliesToYourComments,
                    //     optionName: "Replies to your comments",
                    //     settingIcon: Icons.reply,
                    //     enable: () {}),
                    EnableSetting(
                      isEnabled: isEnabled.newFollowers,
                      optionName: "New followers",
                      settingIcon: Icons.person,
                      enable: () => toggleNotificationSettings("newFollowers"),
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
                        enable: () =>
                            toggleNotificationSettings("modNotifications")),
                    Column(
                      children:
                          buildListTileWidgets(isEnabled.subredditsUserMods),
                    )
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
