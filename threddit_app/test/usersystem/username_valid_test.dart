import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/features/user_system/view/screens/username_screen.dart';

void main() {
  group("check if should continue", () {
    test("entered value is null", () {
      expect(updateFormValidity(null), false);
    });
    test("entered value is empty", () {
      expect(updateFormValidity(""), false);
    });
    test("entered value is empty spaces", () {
      expect(updateFormValidity("   "), false);
    });
    test("entered value is valid username", () {
      expect(updateFormValidity("HelloWorld"), true);
    });
  });
}
