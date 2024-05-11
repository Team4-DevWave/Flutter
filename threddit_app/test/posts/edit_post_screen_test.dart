import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/features/post/view/edit_post_screen.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:tuple/tuple.dart';

void main() {
  group("test edit post screen", () {
    group("test on link added", () {
      test("test on link with domain insert", () {
        expect(
            onInsertData(
                "hello_without_domain", "www.google.com", "Hello_initial"),
            "Hello_initial[hello_without_domain](http://www.google.com)");
      });

      test("test on link without domain insert", () {
        expect(
            onInsertData(
                "hello_with_domain", "http://www.google.com", "Hello_initial"),
            "Hello_initial[hello_with_domain](http://www.google.com)");
      });
    });

    group("update validity and check for changes", () {
      Tuple2 tuple2;
      test("nothing changed and not valid", () {
        tuple2 = updateFormValidity("", "");
        expect(tuple2.item1, false);
        expect(tuple2.item2, false);
      });
      test("nothing changed and empty space", () {
        tuple2 = updateFormValidity(" ", " ");
        expect(tuple2.item1, false);
        expect(tuple2.item2, false);
      });
      test("changed and empty value", () {
        tuple2 = updateFormValidity("", "changed");
        expect(tuple2.item1, true);
        expect(tuple2.item2, false);
      });
      test("changed and empty space", () {
        tuple2 = updateFormValidity("    ", "changed");
        expect(tuple2.item1, true);
        expect(tuple2.item2, false);
      });
      test("not changed and valid", () {
        tuple2 = updateFormValidity("not_changed", "not_changed");
        expect(tuple2.item1, false);
        expect(tuple2.item2, false);
      });
      test("changed and valid", () {
        tuple2 = updateFormValidity("valid change", "changed");
        expect(tuple2.item1, true);
        expect(tuple2.item2, true);
      });
    });

    group("toggle buttons visibility", () {
      test("visible", () {
        expect(onIsOn(true), false);
      });
      test("not visible", () {
        expect(onIsOn(false), true);
      });
    });

    group("toggle nsfw button", () {
      test("is on", () {
        expect(onIsNSFW(true), false);
      });
      test("is off", () {
        expect(onIsNSFW(false), true);
      });
    });

    group("toggle spoiler button", () {
      test("is on", () {
        expect(onIsSpoiler(true), false);
      });
      test("is off", () {
        expect(onIsSpoiler(false), true);
      });
    });

    group("Save button color", () {
      test("is on", () {
        expect(saveButtonColor(true), AppColors.blueColor);
      });
      test("is off", () {
        expect(saveButtonColor(false), AppColors.whiteHideColor);
      });
    });

    group("NFSW Button color", () {
      test("valid", () {
        expect(isNSFWButtonBackgroundColor(true), AppColors.redColor);
      });
      test("inVlaid", () {
        expect(isNSFWButtonBackgroundColor(false), AppColors.backgroundColor);
      });
    });

    group("NSFW Button Text color", () {
      test("valid", () {
        expect(isNSFWButtonTextColor(true), AppColors.backgroundColor);
      });
      test("inVlaid", () {
        expect(isNSFWButtonTextColor(false), AppColors.whiteColor);
      });
    });

    group("Spoiler Button color", () {
      test("valid", () {
        expect(isSpoilerButtonBackgroundColor(true), AppColors.whiteGlowColor);
      });
      test("inVlaid", () {
        expect(
            isSpoilerButtonBackgroundColor(false), AppColors.backgroundColor);
      });
    });

    group("Spoiler Button Text color", () {
      test("valid", () {
        expect(isSpoilerButtonTextColor(true), AppColors.backgroundColor);
      });
      test("inVlaid", () {
        expect(isSpoilerButtonTextColor(false), AppColors.whiteColor);
      });
    });
  });
}
