import 'package:flutter/material.dart';
import 'package:threddit_app/theme/text_styles.dart';
import 'package:threddit_app/features/user_system/view/widgets/settings_title.dart';
class ConnectedAccounts extends StatefulWidget {
  @override
  State<ConnectedAccounts> createState() => _ConnectedAcccountsState();
}

class _ConnectedAcccountsState extends State<ConnectedAccounts> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(crossAxisAlignment: CrossAxisAlignment.start ,children: [
      const SettingsTitle(title: "CONNECTED ACCOUNTS"),
      ListTile(
          leading: const ImageIcon(AssetImage("assets/images/google.png")),
          title: const Text("Google"),
          titleTextStyle: AppTextStyles.primaryTextStyle,
          trailing: TextButton(onPressed: () {}, child: const Text("Connect", style: TextStyle(color: Colors.blue),))),
    //   ListTile(
    //       leading: ImageIcon(AssetImage("assets/images/facebook.png")),
    //       title: Text("Facebook"),
    //       titleTextStyle: AppTextStyles.primaryTextStyle,
    //       trailing: TextButton(onPressed: () {}, child: Text("Connect"))),
     ]);
  }
}
