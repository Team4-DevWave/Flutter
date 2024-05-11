import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/features/user_system/view/widgets/email_textformfield.dart';

void main() {
  group("text form diplayed text", () {
    test("case at empty", () {
      String identifier = "";
      expect(displayText(identifier), "Email");
    });
    test("case at login", () {
      String identifier = "login";
      expect(displayText(identifier), "Email or Username");
    });
  });
}
