import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_app/theme/text_styles.dart';

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
        title: Text(
          "User Profile",
          style: AppTextStyles.primaryTextStyle,
        ),
      ),
      body: const Column(),
    );
  }
}
