import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/theme/colors.dart';

class UserProfile extends ConsumerStatefulWidget {
  const UserProfile({super.key});
  @override
  ConsumerState<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          const Align(
            alignment: Alignment.centerRight,
          ),
          IconButton(
            onPressed: () {
              //open search screen
            },
            icon: const Icon(
              Icons.search_outlined,
              color: AppColors.whiteGlowColor,
            ),
          ),
          IconButton(
            onPressed: () {
              //share profile modal bottom sheet
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          //The first half of the screen (user info)
        ),
      ),
    );
  }
}
