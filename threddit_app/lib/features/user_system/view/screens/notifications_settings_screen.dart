import 'package:flutter/material.dart';
import 'package:threddit_clone/features/user_system/view/widgets/enable_setting.dart';
import 'package:threddit_clone/features/user_system/view/widgets/settings_title.dart';

/// Notification screen has the options renders the options that the user
/// can use to turn on/off the notifcations he wants/doesn't want.
class NotificationsSettingsScreen extends StatelessWidget {
  const NotificationsSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SettingsTitle(title: "MESSAGES"),
            EnableSetting("Private messages", Icons.mail),
            EnableSetting("Chat messages", Icons.chat),
            EnableSetting("Chat requests", Icons.chat_bubble_outline),
            SettingsTitle(title: "ACTIVITY"),
            EnableSetting("Mentions of u/username", Icons.person),
            EnableSetting("Comments on your posts", Icons.comment),
            EnableSetting("Upvotes on your posts", Icons.arrow_upward),
            EnableSetting("Upvotes on your comments", Icons.arrow_upward_sharp),
            EnableSetting("Replies to your comments", Icons.reply),
            EnableSetting("New followers", Icons.person),
            SettingsTitle(title: "UPDATES"),
            EnableSetting("Cake day", Icons.cake),
            SettingsTitle(title: "MODERATION"),
            EnableSetting("Mod notifications", Icons.shield),
          ]),
        ),
      ),
    );
  }
}
