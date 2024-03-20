import 'package:flutter/material.dart';
import 'package:threddit_app/features/user_system/view/widgets/basic_settings.dart';
import 'package:threddit_app/features/user_system/view/widgets/connected_accounts.dart';
import 'package:threddit_app/features/user_system/view/widgets/contact_settings.dart';
import 'package:threddit_app/features/user_system/view/widgets/safety.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Account Settings")),
        body: ListView(children: [
          BasicSettings(),
          ConnectedAccounts(),
          ContactSettings(),
          Safety(),
        ]));
  }
}
