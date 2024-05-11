import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/features/post/view/cross_post.dart';
import 'package:threddit_clone/theme/colors.dart';

void main() {
  group("cross post test", () {
    group("toggle isOn", () {
      test("toggle false", () {
        expect(onIsOn(true), false);
      });
      test("toggle true", () {
        expect(onIsOn(false), true);
      });
    });

    group("toggle isNSFW", () {
      test("toggle false", () {
        expect(onIsNSFW(true), false);
      });
      test("toggle true", () {
        expect(onIsNSFW(false), true);
      });
    });

    group("toggle isSpoiler", () {
      test("toggle false", () {
        expect(onIsSpoiler(true), false);
      });
      test("toggle true", () {
        expect(onIsSpoiler(false), true);
      });
    });

    group("post button color", () {
      test("case valid", () {
        expect(postButtonColor(true), AppColors.blueColor);
      });
      test("case invalid", () {
        expect(postButtonColor(false), AppColors.whiteHideColor);
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
    group("Titile validity", () {
      test("valid", () {
        expect(updateFormValidity(""), false);
      });
      test("invalid", () {
        expect(updateFormValidity("   "), false);
      });
      test("valid", () {
        expect(updateFormValidity("New Title"), true);
      });
    });
  });
}
