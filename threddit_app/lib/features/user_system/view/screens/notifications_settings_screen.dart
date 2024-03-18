import 'package:flutter/material.dart';
import 'package:threddit_app/features/user_system/view/widgets/enable_setting.dart';
import 'package:threddit_app/features/user_system/view/widgets/settings_title.dart';

class NotificationsSettingsScreen extends StatelessWidget {
  const NotificationsSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SettingsTitle(title: "MESSAGES"),
            EnableSetting("Private messages", Icons.mail),
            EnableSetting("Chat messages", Icons.chat),
            EnableSetting("Chat requests", Icons.chat_bubble_outline),
            const SettingsTitle(title: "ACTIVITY"),
            EnableSetting("Mentions of u/username", Icons.person),
            EnableSetting("Comments on your posts", Icons.comment),
            EnableSetting("Upvotes on your posts", Icons.arrow_upward),
            EnableSetting("Upvotes on your comments", Icons.arrow_upward_sharp),
            EnableSetting("Replies to your comments", Icons.reply),
            EnableSetting("New followers", Icons.person),
            const SettingsTitle(title: "UPDATES"),
            EnableSetting("Cake day", Icons.cake),
            const SettingsTitle(title: "MODERATION"),
            EnableSetting("Mod notifications", Icons.shield),
          ]),
        ),
      ),
    );
  }
}
