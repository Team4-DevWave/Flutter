import 'package:flutter/material.dart';
import 'package:threddit_app/features/user_system/view/widgets/register_buttons.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:threddit_app/theme/photos.dart';
import 'package:threddit_app/theme/text_styles.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: AppColors.registerColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Photos.snoLogo,
            width: 55,
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'All your interests in one place',
              style: AppTextStyles.welcomeScreen,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 200,
          ),
          const RegisterButtons(),
        ],
      ),
    ));
  }
}
