import 'package:flutter/material.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_system/model/user_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
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
  String? token = "";
  void _blockedAccounts(BuildContext context) {
    Navigator.pushNamed(context, RouteClass.blockedScreen);
  }

  bool isFollowableEnabled = false;

  @override
  void initState() {
    getUserToken().then((value) => ref
            .read(settingsFetchProvider.notifier)
            .getSettings(client: client, token: token!)
            .then((value) {
          setState(() {
            isFollowableEnabled = value.userProfile.allowFollowers;
          });
        }));
    super.initState();
  }

  Future getUserToken() async {
    String? result = await getToken();
    print(result);
    setState(() {
      token = result!;
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
            value: isFollowableEnabled,
            onChanged: (bool? value) {
              setState(() {
                isFollowableEnabled = value!;
                changeSetting(
                    client: client,
                    change: value,
                    settingsName: "allowFollowers",
                    settingsType: "userProfile",
                    token: token!);
              });
            },
          ),
        ),
      ],
    );
  }
}
