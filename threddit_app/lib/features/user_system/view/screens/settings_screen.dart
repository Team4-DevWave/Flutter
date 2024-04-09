import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_system/model/user_mock.dart'; // Replace with your user model
import 'package:threddit_clone/features/user_system/model/user_settings.dart'; // Replace with your user settings model
import 'package:threddit_clone/features/user_system/view/widgets/settings_title.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart'; // Update if needed
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

const List<String> defaultView = <String>['Card', 'Classic View'];

final userSettingsProvider = StateProvider<UserSettings?>((ref) => null);

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final client = http.Client();

  Future<UserSettings> fetchUser(http.Client client) async {
    final userSettings =
        ref.watch(settingsFetchProvider.notifier).getSettings(client);
    return userSettings;
  }

  void _selectAccountSetting(BuildContext context) {
    Navigator.pushNamed(context, RouteClass.accountSettingScreen);
  }

  void _selectTextSizeScreen(BuildContext context) {
    Navigator.pushNamed(context, RouteClass.textSize);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Settings")),
        body: ListView(children: [
          const SettingsTitle(title: "GENERAL"),
          FutureBuilder(
            future: fetchUser(client),
            builder: (BuildContext ctx, AsyncSnapshot<UserSettings> snapshot) {
              while (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                print(snapshot.error);
                return const Text("ERROR LOADING USER DATA");
              } else {
                final UserSettings user = snapshot.data!;
                String pickedView = user.feedSettings.globalContentView;
                return ListView(
                  shrinkWrap: true,
                  children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(
                        "Account settings for u/${user.userProfile.displayName ?? 'Loading...'}"),
                    titleTextStyle: AppTextStyles.primaryTextStyle,
                    trailing: const Icon(Icons.navigate_next),
                    onTap: () {
                      _selectAccountSetting(context);
                    },
                  ),
                  const SettingsTitle(title: "VIEW OPTIONS"),
                  
                  ListTile(
                    leading: const Icon(Icons.view_module),
                    title: const Text("Default View"),
                    titleTextStyle: AppTextStyles.primaryTextStyle,
                    trailing: DropdownButton<String>(
                      style: AppTextStyles.secondaryTextStyle,
                      dropdownColor: AppColors.backgroundColor,
                      icon: const Icon(Icons.arrow_downward),
                      onChanged: (String? value) {
                        setState(() {
                      pickedView = value!;
                      changeSetting(
                          client: client, change: pickedView);
                    });
                      },
                      value: user.feedSettings.globalContentView,
                      items: defaultView
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ]);
              }
            },
          ),
          const SettingsTitle(title: "ACCESSIBILITY"),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Increase text size"),
            titleTextStyle: AppTextStyles.primaryTextStyle,
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              _selectTextSizeScreen(context);
            },
          ),
        ]));
  }
}
