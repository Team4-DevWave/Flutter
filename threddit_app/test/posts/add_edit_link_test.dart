import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/features/post/view/widgets/add_edit_link.dart';

void main() {
  group("add edit link", () {
    test("sending empty name and empty link", () {
      expect(isValid("", ""), false);
    });

    test("sending empty space name and link", () {
      expect(isValid("   ", "   "), false);
    });

    test("sending valid name ande empty link", () {
      expect(isValid("Press Here", ""), false);
    });

    test("sending valid name ande empty space link", () {
      expect(isValid("Press Here", "   "), false);
    });
    test("sending empty name and link", () {
      expect(isValid("", "https://docs.google.com/"), false);
    });
    test("sending empty space name ande link", () {
      expect(isValid("    ", "https://docs.google.com/"), false);
    });
    test("sending valid name and link", () {
      expect(isValid("Press Here", "https://docs.google.com/"), true);
    });
  });
}
