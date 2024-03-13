import 'package:flutter/material.dart';
import 'package:threddit_app/theme/text_styles.dart';
import 'package:threddit_app/features/user_system/view/widgets/settings_title.dart';

var isFollowable = false;
class Safety extends StatefulWidget {
  @override
  State<Safety> createState() => _SafetyState();
}

class _SafetyState extends State<Safety> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(crossAxisAlignment: CrossAxisAlignment.start ,children: [
      const SettingsTitle(title: "SAFETY"),
      ListTile(
          leading: Icon(Icons.block),
          title: Text("Manage blocked accounts"),
          titleTextStyle: AppTextStyles.primaryTextStyle,
          trailing: Icon(Icons.navigate_next),
          
      ),
      ListTile(
          leading: Icon(Icons.person),
          title: Text("Allow people to follow you"),
          subtitle: Text("Followers will be notified about posts you make to your profile and see them in their home feed."),
          titleTextStyle: AppTextStyles.primaryTextStyle,
          trailing: Switch(activeColor: const Color.fromARGB(255, 1, 61, 110),value: isFollowable, onChanged: (bool? value){
            setState(() {
              isFollowable = value!;
            });
          }),
          
      ),
     ]);
  }
}
