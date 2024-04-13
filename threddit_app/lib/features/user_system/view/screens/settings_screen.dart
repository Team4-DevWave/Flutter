import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/features/user_system/model/user_settings.dart';
import 'package:threddit_clone/features/user_system/view/widgets/settings_title.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

const List<String> defaultView = <String>['card', 'classic'];
const List<String> thumbnail = <String>[
  "Always show",
  "Never show",
  "Community default"
];

final userSettingsProvider = StateProvider<UserSettings?>((ref) => null);

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final client = http.Client();
  late UserSettings settings;
  late String? token;
  late UserModelMe user;
  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchUser(http.Client client) async {
    final userModel = ref.watch(settingsFetchProvider.notifier).getMe();

    user = await userModel;
  }

  Future<UserSettings> fetchSettings(http.Client client) async {
    final userSettings =
        ref.watch(settingsFetchProvider.notifier).getSettings();
    settings = await userSettings;
    return userSettings;
  }

  void _selectAccountSetting(BuildContext context) {
    Navigator.pushNamed(context, RouteClass.accountSettingScreen);
  }

  void _selectTextSizeScreen(BuildContext context) {
    Navigator.pushNamed(context, RouteClass.textSize);
  }

  String currentThumbnail = "Community default";
  bool volumeOff = false;
  bool recentOn = false;
  String commentSorting = "Best";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Settings")),
        body: ListView(children: [
          const SettingsTitle(title: "GENERAL"),
          FutureBuilder(
            future: fetchUser(client),
            builder: (BuildContext ctx, AsyncSnapshot<void> snapshot) {
              while (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return const Text("ERROR LOADING USER DATA");
              } else {
                return ListView(shrinkWrap: true, children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: Text("Account settings for u/${user.username}"),
                    titleTextStyle: AppTextStyles.primaryTextStyle,
                    trailing: const Icon(Icons.navigate_next),
                    onTap: () {
                      _selectAccountSetting(context);
                    },
                  ),
                ]);
              }
            },
          ),
          const SettingsTitle(title: "VIEW OPTIONS"),
          FutureBuilder(
              future: fetchSettings(client),
              builder:
                  (BuildContext ctx, AsyncSnapshot<UserSettings> snapshot) {
                while (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return const Text("ERROR LOADING DATA");
                } else {
                  String pickedView = settings.feedSettings.globalContentView;
                  return ListView(shrinkWrap: true, children: [
                    ListTile(
                      leading: const Icon(Icons.view_agenda),
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
                              settingsName: "globalContentView",
                              settingsType: "feedSettings",
                              change: pickedView,
                            );
                          });
                        },
                        value: settings.feedSettings.globalContentView,
                        items: defaultView
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.image),
                      title: const Text("Thumbnails"),
                      titleTextStyle: AppTextStyles.primaryTextStyle,
                      trailing: DropdownButton<String>(
                        style: AppTextStyles.secondaryTextStyle,
                        dropdownColor: AppColors.backgroundColor,
                        icon: const Icon(Icons.arrow_downward),
                        onChanged: (String? value) {
                          setState(() {
                            currentThumbnail = value!;
                          });
                        },
                        value: currentThumbnail,
                        items: thumbnail
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    )
                  ]);
                }
              }),
          const SettingsTitle(title: "ACCESSIBILITY"),
          ListTile(
            leading: const Icon(Icons.format_size),
            title: const Text("Increase text size"),
            titleTextStyle: AppTextStyles.primaryTextStyle,
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              _selectTextSizeScreen(context);
            },
          ),
          const SettingsTitle(title: "ADVANCED"),
          ListTile(
              leading: const Icon(Icons.volume_off),
              title: const Text("Mute videos by default"),
              titleTextStyle: AppTextStyles.primaryTextStyle,
              trailing: Switch(
                  value: volumeOff,
                  onChanged: (value) {
                    setState(() {
                      volumeOff = value;
                    });
                  })),
          ListTile(
              leading: const Icon(Icons.timelapse),
              title: const Text("Recent communities"),
              titleTextStyle: AppTextStyles.primaryTextStyle,
              trailing: Switch(
                  value: recentOn,
                  onChanged: (value) {
                    setState(() {
                      recentOn = value;
                    });
                  })),
          ListTile(
              leading: const Icon(Icons.message),
              title: const Text("Default comment sort"),
              subtitle: Text(commentSorting),
              titleTextStyle: AppTextStyles.primaryTextStyle,
              trailing: const Icon(Icons.arrow_downward),
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: AppColors.backgroundColor,
                  context: context,
                  builder: (context) => Wrap(
                    children: [
                      RadioListTile<String>(
                        title: Text(
                          "Best",
                          style: AppTextStyles.primaryTextStyle,
                        ),
                        value: "Best",
                        groupValue: commentSorting,
                        onChanged: (value) => setState(() {
                          commentSorting = value!;
                          Navigator.pop(context);
                        }),
                      ),
                      RadioListTile<String>(
                        title: Text(
                          "Top",
                          style: AppTextStyles.primaryTextStyle,
                        ),
                        value: "Top",
                        groupValue: commentSorting,
                        onChanged: (value) => setState(() {
                          commentSorting = value!;
                          Navigator.pop(context);
                        }),
                      ),
                      RadioListTile<String>(
                        title: Text(
                          "New",
                          style: AppTextStyles.primaryTextStyle,
                        ),
                        value: "New",
                        groupValue: commentSorting,
                        onChanged: (value) => setState(() {
                          commentSorting = value!;
                          Navigator.pop(context);
                        }),
                      ),
                      RadioListTile<String>(
                        title: Text(
                          "Controversial",
                          style: AppTextStyles.primaryTextStyle,
                        ),
                        value: "Controversial",
                        groupValue: commentSorting,
                        onChanged: (value) => setState(() {
                          commentSorting = value!;
                          Navigator.pop(context);
                        }),
                      ),
                      RadioListTile<String>(
                        title: Text(
                          "Old",
                          style: AppTextStyles.primaryTextStyle,
                        ),
                        value: "Old",
                        groupValue: commentSorting,
                        onChanged: (value) => setState(() {
                          commentSorting = value!;
                          Navigator.pop(context);
                        }),
                      ),
                      RadioListTile<String>(
                        title: Text(
                          "Q&A",
                          style: AppTextStyles.primaryTextStyle,
                        ),
                        value: "Q&A",
                        groupValue: commentSorting,
                        onChanged: (value) => setState(() {
                          commentSorting = value!;
                          Navigator.pop(context);
                        }),
                      ),
                    ],
                  ),
                );
              }),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text("Clear local history"),
            titleTextStyle: AppTextStyles.primaryTextStyle,
            onTap: () {},
          ),
        ]));
  }
}
