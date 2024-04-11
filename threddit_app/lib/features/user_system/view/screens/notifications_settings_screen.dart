import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/view/widgets/enable_setting.dart';
import 'package:threddit_clone/features/user_system/view/widgets/settings_title.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:http/http.dart' as http;

/// Notification screen has the options renders the options that the user
/// can use to turn on/off the notifcations he wants/doesn't want.
class NotificationsSettingsScreen extends ConsumerStatefulWidget {
  NotificationsSettingsScreen({super.key});

  @override
  ConsumerState<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends ConsumerState<NotificationsSettingsScreen> {
  final client = http.Client();
  String? token;
  Future<bool> isNotificationEnabled() async {
    setState(() {
      ref.watch(settingsFetchProvider.notifier).getNotificationSetting(client: client, token: token!);
    });
    return ref
        .watch(settingsFetchProvider.notifier)
        .getNotificationSetting(client: client, token: token!);
  }
  Future getUserToken() async {
    String? result = await getToken();
    print(result);
    setState(() {
      token = result!;
    });
  }
  @override
  void initState() {
    getUserToken();
    super.initState();
  }

  void toggleNotificationSettings(bool isEnabled) async {
    notificationOn(client: client, isEnabled: isEnabled, token: token!);
    setState(() {
      ref.watch(settingsFetchProvider.notifier).getNotificationSetting(client: client, token: token!);
    });
  }

  @override
  Widget build(BuildContext context) {
    getUserToken();
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SettingsTitle(title: "MESSAGES"),
            FutureBuilder<bool>(
              future: isNotificationEnabled(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const CircularProgressIndicator();
                } else {
                  final isEnabled = snapshot.data!;
                  return EnableSetting(
                    isEnabled: isEnabled,
                    optionName: "Private messages",
                    settingIcon: Icons.mail,
                    enable: () => toggleNotificationSettings(!isEnabled),
                  );
                }
              },
            ),
            FutureBuilder<bool>(
              future: isNotificationEnabled(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const CircularProgressIndicator();
                } else {
                  final isEnabled = snapshot.data!;
                  return EnableSetting(
                      isEnabled: isEnabled,
                      optionName: "Chat messages",
                      settingIcon: Icons.chat,
                      enable: () {});
                }
              },
            ),
            FutureBuilder<bool>(
              future: isNotificationEnabled(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const CircularProgressIndicator();
                } else {
                  final isEnabled = snapshot.data!;
                  return EnableSetting(
                      isEnabled: isEnabled,
                      optionName: "Chat requests",
                      settingIcon: Icons.chat_bubble_outline,
                      enable: () {});
                }
              },
            ),
            SettingsTitle(title: "ACTIVITY"),
            FutureBuilder<bool>(
              future: isNotificationEnabled(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const CircularProgressIndicator();
                } else {
                  final isEnabled = snapshot.data!;
                  return EnableSetting(
                      isEnabled: isEnabled,
                      optionName: "Mentions of u/username",
                      settingIcon: Icons.person,
                      enable: () {});
                }
              },
            ),
            FutureBuilder<bool>(
              future: isNotificationEnabled(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const CircularProgressIndicator();
                } else {
                  final isEnabled = snapshot.data!;
                  return EnableSetting(
                      isEnabled: isEnabled,
                      optionName: "Comments on your posts",
                      settingIcon: Icons.comment,
                      enable: () {});
                }
              },
            ),
            FutureBuilder<bool>(
              future: isNotificationEnabled(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const CircularProgressIndicator();
                } else {
                  final isEnabled = snapshot.data!;
                  return EnableSetting(
                      isEnabled: isEnabled,
                      optionName: "Upvotes on your posts",
                      settingIcon: Icons.arrow_upward,
                      enable: () {});
                }
              },
            ),
            FutureBuilder<bool>(
              future: isNotificationEnabled(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const CircularProgressIndicator();
                } else {
                  final isEnabled = snapshot.data!;
                  return EnableSetting(
                      isEnabled: isEnabled,
                      optionName: "Upvotes on your comments",
                      settingIcon: Icons.arrow_upward_sharp,
                      enable: () {});
                }
              },
            ),
            FutureBuilder<bool>(
              future: isNotificationEnabled(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const CircularProgressIndicator();
                } else {
                  final isEnabled = snapshot.data!;
                  return EnableSetting(
                      isEnabled: isEnabled,
                      optionName: "Replies to your comments",
                      settingIcon: Icons.reply,
                      enable: () {});
                }
              },
            ),
            FutureBuilder<bool>(
              future: isNotificationEnabled(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const CircularProgressIndicator();
                } else {
                  final isEnabled = snapshot.data!;
                  return EnableSetting(
                    isEnabled: isEnabled,
                    optionName: "New followers",
                    settingIcon: Icons.person,
                    enable: () {},
                  );
                }
              },
            ),
            const SettingsTitle(title: "UPDATES"),
            FutureBuilder<bool>(
              future: isNotificationEnabled(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const CircularProgressIndicator();
                } else {
                  final isEnabled = snapshot.data!;
                  return EnableSetting(
                      isEnabled: isEnabled,
                      optionName: "Cake day",
                      settingIcon: Icons.cake,
                      enable: () {});
                }
              },
            ),
            const SettingsTitle(title: "MODERATION"),
            FutureBuilder<bool>(
              future: isNotificationEnabled(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const CircularProgressIndicator();
                } else {
                  final isEnabled = snapshot.data!;
                  return EnableSetting(
                      isEnabled: isEnabled,
                      optionName: "Mod notifications",
                      settingIcon: Icons.shield,
                      enable: () {});
                }
              },
            ),
          ]),
        ),
      ),
    );
  }
}
