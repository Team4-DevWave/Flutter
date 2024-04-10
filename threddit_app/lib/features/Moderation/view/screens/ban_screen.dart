import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/Moderation/view/widgets/input_form.dart';

import 'package:threddit_clone/features/user_system/view/widgets/settings_title.dart';

class BanScreen extends ConsumerStatefulWidget {
  const BanScreen({super.key});
  ConsumerState<ConsumerStatefulWidget> createState() => _BanScreenState();
}

class _BanScreenState extends ConsumerState<BanScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add a banned user",
        ),
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsTitle(title: "Username"),
          InputForm(formname: "username"),
        ],
      ),
    );
  }
}
