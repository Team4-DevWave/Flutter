import 'package:flutter/material.dart';
import 'package:threddit_app/theme/text_styles.dart';
import 'package:threddit_app/features/user_system/view/widgets/settings_title.dart';

class ConnectedAccounts extends StatefulWidget {
  const ConnectedAccounts({super.key});

  @override
  State<ConnectedAccounts> createState() => _ConnectedAcccountsState();
}

class _ConnectedAcccountsState extends State<ConnectedAccounts> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SettingsTitle(title: "CONNECTED ACCOUNTS"),
      ListTile(
          leading: const ImageIcon(AssetImage("assets/images/google.png")),
          title: const Text("Google"),
          titleTextStyle: AppTextStyles.primaryTextStyle,
          // ignore: lines_longer_than_80_chars
          trailing: TextButton(
              onPressed: () {},
              child: const Text(
                "Connect",
                style: TextStyle(color: Colors.blue),
              ))),
    ]);
  }
}
