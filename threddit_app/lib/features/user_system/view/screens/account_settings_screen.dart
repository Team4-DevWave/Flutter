import 'package:flutter/material.dart';
import 'package:threddit_clone/features/user_system/view/widgets/basic_settings.dart';
import 'package:threddit_clone/features/user_system/view/widgets/connected_accounts.dart';
import 'package:threddit_clone/features/user_system/view/widgets/contact_settings.dart';
import 'package:threddit_clone/features/user_system/view/widgets/safety.dart';

final genders = [
  'Woman',
  'Man',
];

/// The class responsible for rendering the Account Setting screen and calls the rest of the widgets.
class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Account Settings")),
        body: ListView(children: const [
          BasicSettings(),
          ConnectedAccounts(),
          ContactSettings(),
          Safety(),
        ]));
  }
}
