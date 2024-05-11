import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/features/Moderation/view/screens/post_types.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';

enum PostTypeOption { any, linkOnly, textOnly }

void main() {
  PostTypeOption postAnyType = PostTypeOption.any;
  PostTypeOption postLinkType = PostTypeOption.linkOnly;
  PostTypeOption postTextType = PostTypeOption.textOnly;
  test('test failure', () {
    Failure fail = Failure("error_message");

    expect(fail.message, "error_message");
  });
  group("post types test", () {
    test("any test", () {
      expect(textDisplayed(postAnyType.name), "Any");
    });
    test("link test", () {
      expect(textDisplayed(postLinkType.name), "Link");
    });
    test("text test", () {
      expect(textDisplayed(postTextType.name), "Text");
    });
  });
}
