import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/features/user_system/view/screens/username_screen.dart';

void main() {
  group("check if should continue", () {
    test("entered value is null", () {
      bool isValid = updateFormValidity(null);
      expect(isValid, false);
    });
    test("entered value is empty", () {
      bool isValid = updateFormValidity("");
      expect(isValid, false);
    });
    test("entered value is empty spaces", () {
      bool isValid = updateFormValidity("   ");
      expect(isValid, false);
    });
    test("entered value is valid username", () {
      bool isValid = updateFormValidity("HelloWorld");
      expect(isValid, true);
    });
  });
}
