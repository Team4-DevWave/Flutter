import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/features/user_system/view/screens/interests_screen.dart';

void main() {
  final List<String> interestsListData = [];
  group("interests list toggle", () {
    test("add to interests", () {
      toggleInterest("Games", interestsListData);
      expect(interestsListData.contains("Games"), true);
    });

    test("add to same intereset again to toggle", () {
      toggleInterest("Games", interestsListData);
      expect(interestsListData.contains("Games"), false);
    });
  });
}
