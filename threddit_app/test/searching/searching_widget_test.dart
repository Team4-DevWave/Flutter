import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/features/home_page/view/screens/home_screen.dart';

void main() {
  testWidgets('Navigate to the searching screen', (WidgetTester tester) async {
    final searchButton = find.byKey(ValueKey("searchButton"));

    await tester.pumpWidget(MaterialApp(home: HomeScreen()));
    await tester.tap(searchButton);

    expect(find.byKey(ValueKey("trendingText")), findsOneWidget);
  });
}
