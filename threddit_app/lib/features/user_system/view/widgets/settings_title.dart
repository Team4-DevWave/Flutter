import 'package:flutter/material.dart';
import 'package:threddit_app/theme/text_styles.dart';

class SettingsTitle extends StatelessWidget {
  const SettingsTitle({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(title, style: AppTextStyles.secondaryTextStyle),
    );
  }
}
