import 'package:flutter/material.dart';
import 'package:threddit_app/theme/text_styles.dart';

class ConnectedAccounts extends StatefulWidget {
  @override
  State<ConnectedAccounts> createState() => _ConnectedAcccountsState();
}

class _ConnectedAcccountsState extends State<ConnectedAccounts> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(children: [
      ListTile(
          leading: ImageIcon(AssetImage("assets/images/google.png")),
          title: Text("Google"),
          titleTextStyle: AppTextStyles.primaryTextStyle,
          trailing: TextButton(onPressed: () {}, child: Text("Connect", style: TextStyle(color: Colors.blue),))),
    //   ListTile(
    //       leading: ImageIcon(AssetImage("assets/images/facebook.png")),
    //       title: Text("Facebook"),
    //       titleTextStyle: AppTextStyles.primaryTextStyle,
    //       trailing: TextButton(onPressed: () {}, child: Text("Connect"))),
     ]);
  }
}
