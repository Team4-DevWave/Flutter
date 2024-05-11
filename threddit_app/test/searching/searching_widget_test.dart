import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/features/home_page/view/screens/home_screen.dart';
import 'package:threddit_clone/features/searching/model/search_model.dart';
import 'package:threddit_clone/features/searching/view/screens/search_results_screen.dart';
import 'package:threddit_clone/features/searching/view/screens/search_screen.dart';

void main() {
  group('Searching Tests', () {
    testWidgets('Find the searching screen button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                // Initialize flutter_screenutil
                ScreenUtil.init(context);
                return const ProviderScope(
                  child: MaterialApp(
                    home: HomeScreen(),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final searchButton = find.byKey(const ValueKey("searchButton"));
      expect(searchButton, findsOneWidget);
    });

    testWidgets('type in the searching bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                // Initialize flutter_screenutil
                ScreenUtil.init(context);
                return const ProviderScope(
                  child: MaterialApp(
                    home: SearchScreen(),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final searchForm = find.byKey(const ValueKey("searchForm"));
      expect(searchForm, findsOneWidget);
      await tester.enterText(searchForm, "hello");
      final textFieldValue =
          tester.widget<TextFormField>(searchForm).controller!.text;

      expect(textFieldValue, "hello");
    });
    testWidgets('Finding the trending', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                // Initialize flutter_screenutil
                ScreenUtil.init(context);
                return const ProviderScope(
                  child: MaterialApp(
                    home: SearchScreen(),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final trendingText = find.byKey(const ValueKey("trendingText"));
      expect(trendingText, findsOneWidget);
    });

    testWidgets('Checking if search result query is displayed correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                // Initialize flutter_screenutil
                ScreenUtil.init(context);
                return ProviderScope(
                  child: MaterialApp(
                    home: SearchResultsScreen(
                      searchResults: SearchModel(
                          posts: [],
                          comments: [],
                          subreddits: [],
                          medias: [],
                          users: []),
                      searchText: "test",
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final trendingText = find.text("test");
      expect(trendingText, findsOneWidget);
    });
    testWidgets('Posts display part', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                // Initialize flutter_screenutil
                ScreenUtil.init(context);
                return ProviderScope(
                  child: MaterialApp(
                    home: SearchResultsScreen(
                      searchResults: SearchModel(
                          posts: [],
                          comments: [],
                          subreddits: [],
                          medias: [],
                          users: []),
                      searchText: "test",
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final trendingText = find.text("Posts");
      expect(trendingText, findsOneWidget);
    });
    testWidgets('Communities display part', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                // Initialize flutter_screenutil
                ScreenUtil.init(context);
                return ProviderScope(
                  child: MaterialApp(
                    home: SearchResultsScreen(
                      searchResults: SearchModel(
                          posts: [],
                          comments: [],
                          subreddits: [],
                          medias: [],
                          users: []),
                      searchText: "test",
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final trendingText = find.text("Communities");
      expect(trendingText, findsOneWidget);
    });

    testWidgets('Media display part', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                // Initialize flutter_screenutil
                ScreenUtil.init(context);
                return ProviderScope(
                  child: MaterialApp(
                    home: SearchResultsScreen(
                      searchResults: SearchModel(
                          posts: [],
                          comments: [],
                          subreddits: [],
                          medias: [],
                          users: []),
                      searchText: "test",
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final trendingText = find.text("Media");
      expect(trendingText, findsOneWidget);
    });

    testWidgets('Comments display part', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                // Initialize flutter_screenutil
                ScreenUtil.init(context);
                return ProviderScope(
                  child: MaterialApp(
                    home: SearchResultsScreen(
                      searchResults: SearchModel(
                          posts: [],
                          comments: [],
                          subreddits: [],
                          medias: [],
                          users: []),
                      searchText: "test",
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final trendingText = find.text("Comments");
      expect(trendingText, findsOneWidget);
    });

    testWidgets('People display part', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                // Initialize flutter_screenutil
                ScreenUtil.init(context);
                return ProviderScope(
                  child: MaterialApp(
                    home: SearchResultsScreen(
                      searchResults: SearchModel(
                          posts: [],
                          comments: [],
                          subreddits: [],
                          medias: [],
                          users: []),
                      searchText: "test",
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final trendingText = find.text("People");
      expect(trendingText, findsOneWidget);
    });
    testWidgets('Going back to search suggesstions',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                // Initialize flutter_screenutil
                ScreenUtil.init(context);
                return ProviderScope(
                  child: MaterialApp(
                    home: SearchResultsScreen(
                      searchResults: SearchModel(
                          posts: [],
                          comments: [],
                          subreddits: [],
                          medias: [],
                          users: []),
                      searchText: "test",
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final cancelIcon = find.byIcon(Icons.cancel);
      expect(cancelIcon, findsOneWidget);
      await tester.tap(cancelIcon);
      expect(find.text("test"), findsOneWidget);
      expect(find.text("Communities"), findsOneWidget);
    });
    // testWidgets('Searching', (WidgetTester tester) async {
    //   await tester.pumpWidget(
    //     MaterialApp(
    //       home: Scaffold(
    //         body: Builder(
    //           builder: (context) {
    //             // Initialize flutter_screenutil
    //             ScreenUtil.init(context);
    //             return ProviderScope(
    //               child: MaterialApp(
    //                 home: SearchScreen(),
    //                 routes: {
    //                   '/search-results': (context) => SearchResultsScreen(
    //                         searchResults: SearchModel(
    //                             posts: [],
    //                             comments: [],
    //                             subreddits: [],
    //                             medias: [],
    //                             users: []),
    //                         searchText: "test",
    //                       ), // Define SearchResultsScreen widget
    //                 },
    //               ),
    //             );
    //           },
    //         ),
    //       ),
    //     ),
    //   );

    //   final searchForm = find.byKey(const ValueKey("searchForm"));
    //   expect(searchForm, findsOneWidget);
    //   await tester.enterText(searchForm, "test");
    //   await tester.testTextInput.receiveAction(TextInputAction.done);
    //   expect(find.text("test"), findsOneWidget);
    //   expect(find.text("Posts"), findsOneWidget);
    // });
  });
}
