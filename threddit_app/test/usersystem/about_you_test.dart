import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/features/user_system/view/screens/about_you_screen.dart';
import 'package:threddit_clone/theme/button_styles.dart';

const types = [
  'man',
  'woman',
  'I prefer not to say',
];

void main() {
  group("gender buttons style", () {
    final Map<String, ButtonStyle> genderButtons = {};
    test("reset the style to default", () {
       resetButtonStyles(genderButtons, types);

      expect(genderButtons.containsValue(AppButtons.selectedButtons), false);
    });
  });
}
