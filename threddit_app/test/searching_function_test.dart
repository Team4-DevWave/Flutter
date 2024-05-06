import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/features/searching/view_model/searching_function.dart';

void main() {
  String history = 'test';
  List<String> firstHistory = [];
  List<String> firstMatcherHistory = ['test'];
  List<String> secondHistory = ['hello'];
  List<String> secondMatcherHistory = ['test', 'hello'];
  List<String> thirdHistory = ['hello', 'world', 'hello'];
  List<String> thirdMatcherHistory = ['test', 'hello', 'world'];

  group("Testing adding a search history function", () {
    test("No elements", () {
      addingHistory(history, firstHistory);
      expect(firstHistory, firstMatcherHistory);
    });
    test("One or two elements", () {
      addingHistory(history, secondHistory);
      expect(secondHistory, secondMatcherHistory);
    });
    test("three or more elements", () {
      addingHistory(history, thirdHistory);
      expect(thirdHistory, thirdMatcherHistory);
    });
  });
}
