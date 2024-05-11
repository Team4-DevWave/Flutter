import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/features/post/view/widgets/add_edit_link.dart';
import 'package:threddit_clone/theme/colors.dart';

void main() {
  group("choose valid color", () {
    test("when valid", () {
      expect(validColor(true), AppColors.whiteGlowColor);
    });
    test("when not valid", () {
      expect(validColor(false), AppColors.whiteColor);
    });
  });
}
