import 'package:flutter/material.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_app/theme/button_styles.dart';
import 'package:threddit_app/theme/text_styles.dart';

//will watch if the input is valid the on pressed is not null
//and the textstyle is the glow one
class ContinueButton extends StatelessWidget {
  const ContinueButton({super.key, required this.identifier});

  final String identifier;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: null,
      style: AppButtons.choiceButtonTheme,
      child: Text(
        'Continue',
        style: AppTextStyles.primaryButtonHideTextStyle,
      ),
    );
  }
}
