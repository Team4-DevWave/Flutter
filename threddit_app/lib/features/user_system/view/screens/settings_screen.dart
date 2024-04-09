import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_system/model/user_mock.dart';
import 'package:threddit_clone/features/user_system/view/widgets/settings_title.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final client = http.Client();
  Future<UserMock> fetchUser() async {
    setState(() {
      ref.watch(settingsFetchProvider.notifier).getUserInfo(client);
    });
    return ref.watch(settingsFetchProvider.notifier).getUserInfo(client);
  }

  void _selectAccountSetting(BuildContext context) {
    Navigator.pushNamed(context, RouteClass.accountSettingScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Settings")),
        body: ListView(children: [
          const SettingsTitle(title: "GENERAL"),
          FutureBuilder(
              future: fetchUser(),
              builder: (BuildContext ctx, AsyncSnapshot<UserMock> snapshot) {
                while (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Text("ERROR LOADING USER DATA");
                } else {
                  final UserMock user = snapshot.data!;
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text("Account settings for u/${user.getUsername}"),
                    titleTextStyle: AppTextStyles.primaryTextStyle,
                    trailing: const Icon(Icons.navigate_next),
                    onTap: () {
                      _selectAccountSetting(context);
                    },
                  );
                }
              }),
          const SettingsTitle(title: "ACCESSIBILITY"),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Increase text size"),
            titleTextStyle: AppTextStyles.primaryTextStyle,
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              _selectAccountSetting(context);
            },
          ),
        ]));
  }
}
