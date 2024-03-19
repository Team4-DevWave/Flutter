import 'package:flutter/material.dart';
import 'package:threddit_app/theme/text_styles.dart';
import 'package:threddit_app/features/user_system/view/widgets/settings_title.dart';
import 'package:threddit_app/features/user_system/view/screens/notifications_settings_screen.dart';

class ContactSettings extends StatefulWidget {
  @override
  State<ContactSettings> createState() => _ContactSettingState();
}

class _ContactSettingState extends State<ContactSettings> {
  void _enterNotifcationSettings(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => const NotificationsSettingsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SettingsTitle(title: "CONTACT SETTINGS"),
      ListTile(
        leading: const Icon(Icons.notifications),
        title: const Text("Manage notifications"),
        titleTextStyle: AppTextStyles.primaryTextStyle,
        trailing: const Icon(Icons.navigate_next),
        onTap: () {
          _enterNotifcationSettings(context);
        },
      ),
    ]);
  }
}
