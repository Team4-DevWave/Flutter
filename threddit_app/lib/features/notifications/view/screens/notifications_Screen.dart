import 'package:flutter/material.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/notifications/view/widgets/nottification_feed.dart';

class NotificationTempScreen extends StatefulWidget {
  final String usedID;
  const NotificationTempScreen({super.key, required this.usedID});

  @override
  State<NotificationTempScreen> createState() => _NotificationTempScreenState();
}

class _NotificationTempScreenState extends State<NotificationTempScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 236, 118, 7),
                Color.fromARGB(255, 218, 5, 5)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, RouteClass.notificationsSettingsScreen);
              // Handle the button press
            },
          ),
        ],
      ),
      body: NotificationFeed(
        userID: widget.usedID,
      ),
    );
  }
}
