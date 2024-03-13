import 'package:flutter/material.dart';
import 'package:threddit_app/theme/text_styles.dart';
import 'package:threddit_app/features/user_system/view/widgets/settings_title.dart';

class ContactSettings extends StatefulWidget {
  @override
  State<ContactSettings> createState() => _ContactSettingState();
}

class _ContactSettingState extends State<ContactSettings> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(crossAxisAlignment: CrossAxisAlignment.start ,children: [
      const SettingsTitle(title: "CONTACT SETTINGS"),
      ListTile(
          leading: Icon(Icons.notifications),
          title: Text("Manage notifications"),
          titleTextStyle: AppTextStyles.primaryTextStyle,
          trailing: Icon(Icons.navigate_next),
          
      ),
     ]);
  }
}
