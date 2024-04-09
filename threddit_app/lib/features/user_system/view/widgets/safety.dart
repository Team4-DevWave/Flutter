import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/user_system/view/screens/blocked_screen.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/features/user_system/view/widgets/settings_title.dart';
import 'package:http/http.dart' as http;

/// Class safety which is responsible for the safety part in the account settings
/// Has the Manage blocked accounts tile.
/// And the allow others to follow you tile.
class Safety extends ConsumerStatefulWidget {
  const Safety({super.key});

  @override
  ConsumerState<Safety> createState() => _SafetyState();
}

class _SafetyState extends ConsumerState<Safety> {
  final client = http.Client();

  void _blockedAccounts(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => const BlockedScreen()));
  }

  bool isFollowableEnabled = false;

  @override
  void initState() {
    super.initState();
    ref
        .read(settingsFetchProvider.notifier)
        .getFollowableSetting(client)
        .then((value) {
      setState(() {
        isFollowableEnabled = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsTitle(title: "SAFETY"),
        ListTile(
          leading: const Icon(Icons.block),
          title: const Text("Manage blocked accounts"),
          titleTextStyle: AppTextStyles.primaryTextStyle,
          trailing: const Icon(Icons.navigate_next),
          onTap: () {
            _blockedAccounts(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text("Allow people to follow you"),
          subtitle: const Text(
              "Followers will be notified about posts you make to your profile and see them in their home feed."),
          titleTextStyle: AppTextStyles.primaryTextStyle,
          trailing: Switch(
            activeColor: const Color.fromARGB(255, 1, 61, 110),
            value: isFollowableEnabled,
            onChanged: (bool? value) {
              setState(() {
                isFollowableEnabled = value!;
                followableOn(client: client, isEnabled: value);
              });
            },
          ),
        ),
      ],
    );
  }
}
