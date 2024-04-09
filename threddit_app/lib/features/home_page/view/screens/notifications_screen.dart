import 'package:flutter/material.dart';
import 'package:threddit_clone/features/notifications/view/widgets/nottification_feed.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreen();
}

class _NotificationsScreen extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: NotificationFeed(
        userID: "hello world",
      ),
    );
  }
}
