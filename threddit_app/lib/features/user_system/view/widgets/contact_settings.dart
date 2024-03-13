import 'package:flutter/material.dart';
import 'package:threddit_app/theme/text_styles.dart';

class ContactSettings extends StatefulWidget {
  @override
  State<ContactSettings> createState() => _ContactSettingState();
}

class _ContactSettingState extends State<ContactSettings> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(children: [
      ListTile(
          leading: Icon(Icons.notifications),
          title: Text("Manage notifications"),
          titleTextStyle: AppTextStyles.primaryTextStyle,
          trailing: Icon(Icons.navigate_next),
          
      ),
     ]);
  }
}
