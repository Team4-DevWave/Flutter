import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/notifications/view/widgets/nottification_feed.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NotificationsScreen();
}

class _NotificationsScreen extends ConsumerState<NotificationsScreen> {
  UserModelMe? user;
  void _getUserData() async {
    user = ref.read(userModelProvider)!;
  }

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Title(
              color: const Color.fromARGB(255, 253, 243, 243),
              child: const Text("Notifications")),
        ),
      ),
      body: NotificationFeed(
        userID: user?.username ?? " ",
      ),
    );
  }
}
