import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/notifications/view/widgets/empty_notification.dart';

void main() {
  testWidgets('NoNotification widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              // Initialize flutter_screenutil
              ScreenUtil.init(context);
              return NoNotification();
            },
          ),
        ),
      ),
    );

    // Verify that the image is displayed
    expect(find.byType(Image), findsOneWidget);

    // Verify that the title is displayed
    expect(find.text('You don\'t have any activity yet'), findsOneWidget);

    // Verify that the description is displayed
    expect(find.byKey(const Key('fortest')), findsOneWidget);
    expect(
        find.text(
            "That's okay, maybe you just need the right inspiration. Check out a popular community for discussion."),
        findsOneWidget);

    // Verify that the button is displayed
    expect(find.text('Check Communites'), findsOneWidget);

    // Tap the button and verify navigation
    await tester.tap(find.text('Check Communites'));
    await tester.pumpAndSettle();

    // Verify that navigation occurred correctly
    expect(find.text('Main Community Screen'), findsOneWidget);
  });
}
