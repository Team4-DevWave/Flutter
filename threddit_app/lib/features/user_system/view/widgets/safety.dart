import 'package:flutter/material.dart';
import 'package:threddit_app/features/user_system/view/screens/blocked_screen.dart';
import 'package:threddit_app/features/user_system/view/screens/notifications_settings_screen.dart';
import 'package:threddit_app/theme/text_styles.dart';
import 'package:threddit_app/features/user_system/view/widgets/settings_title.dart';

var isFollowable = false;
class Safety extends StatefulWidget {
  @override
  State<Safety> createState() => _SafetyState();
}

class _SafetyState extends State<Safety> {
  void _blockedAccounts(BuildContext context) {
      Navigator.push(
          context, MaterialPageRoute(builder: (ctx) => BlockedScreen()));
  
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(crossAxisAlignment: CrossAxisAlignment.start ,children: [
      const SettingsTitle(title: "SAFETY"),
      ListTile(
          leading: const Icon(Icons.block),
          title: const Text("Manage blocked accounts"),
          titleTextStyle: AppTextStyles.primaryTextStyle,
          trailing: const Icon(Icons.navigate_next),
          onTap: (){
            _blockedAccounts(context);
          },
      ),
      ListTile(
          leading: const Icon(Icons.person),
          title: const Text("Allow people to follow you"),
          subtitle: const Text("Followers will be notified about posts you make to your profile and see them in their home feed."),
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
