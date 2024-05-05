import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/notifications/view/screens/notifications_Screen.dart';
import 'package:threddit_clone/features/notifications/view/widgets/nottification_feed.dart';
import 'package:threddit_clone/features/user_system/view/screens/notifications_settings_screen.dart';

void main() {
  testWidgets('NotificationTempScreen UI Test', (WidgetTester tester) async {
    // Build our widget
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          RouteClass.notificationsSettingsScreen: (context) =>
              NotificationsSettingsScreen(),
          // other routes...
        },
        home: NotificationTempScreen(usedID: '66377b6aabc3d58cad4960b3'),
      ),
    );

    // Verify that the title is rendered correctly
    expect(find.text('Notifications'), findsOneWidget);

    // Verify that the settings icon is rendered
    expect(find.byIcon(Icons.settings), findsOneWidget);

    // Tap on the settings icon and verify navigation
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    expect(
        Navigator.of(tester.element(find.text('Notifications')))
            .context
            .widget
            .runtimeType,
        equals(Navigator));
    expect(find.byType(NotificationFeed), findsOneWidget);
  });
}
