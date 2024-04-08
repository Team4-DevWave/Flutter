import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/user_system/view/widgets/basic_settings.dart';
import 'package:threddit_clone/features/user_system/view/widgets/connected_accounts.dart';
import 'package:threddit_clone/features/user_system/view/widgets/contact_settings.dart';
import 'package:threddit_clone/features/user_system/view/widgets/safety.dart';
import 'package:http/http.dart' as http;

final genders = [
  'Woman',
  'Man',
];

/// The class responsible for rendering the Account Setting screen and calls the rest of the widgets.
class AccountSettingsScreen extends ConsumerStatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends ConsumerState<AccountSettingsScreen> {
  final client = http.Client();

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
