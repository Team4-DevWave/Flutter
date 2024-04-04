import 'package:flutter/material.dart';
import 'package:threddit_clone/features/user_system/view/widgets/register_appbar.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class Interests extends StatefulWidget {
  const Interests({super.key});
  @override
  State<Interests> createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RegisterAppBar(action: () {}, title: "sdf"),
      body: Center(
        child: Text(
          "HEYYYYY",
          style: AppTextStyles.primaryButtonGlowTextStyle,
        ),
      ),
    );
  }
}
