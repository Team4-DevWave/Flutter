import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:threddit_clone/features/searching/model/search_model.dart';
import 'package:threddit_clone/features/searching/view/widgets/search_comment_feed_widget.dart';
import 'package:threddit_clone/features/searching/view/widgets/search_community_widget.dart';
import 'package:threddit_clone/features/searching/view/widgets/search_feed_widget.dart';
import 'package:threddit_clone/features/searching/view/widgets/search_media_feed.dart';
import 'package:threddit_clone/features/searching/view/widgets/search_users_widget.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:http/http.dart' as http;

enum ViewType { all, editable }
/// The `SearchResultsScreen` widget presents search results for various content types within the Threddit app. 
/// This widget is responsible for displaying search results in tabs for posts, communities, comments, media, and people. 
/// Each tab contains a specific type of search result, allowing users to easily navigate through the different types of content. 
/// The search results are populated based on the provided [searchResults] model and the [searchText] that was queried by the user.

class SearchResultsScreen extends ConsumerStatefulWidget {
  final SearchModel searchResults;
  final String searchText;
  const SearchResultsScreen(
      {super.key, required this.searchResults, required this.searchText});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      //initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: ListTile(
            onTap: () => Navigator.pop(context),
            leading: const Icon(Icons.search),
            title: Text(
              widget.searchText,
              style: AppTextStyles.primaryTextStyle,
            ),
          ),
          bottom: const TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: [
                Tab(
                  text: "Posts",
                ),
                Tab(
                  text: "Communities",
                ),
                Tab(
                  text: "Comments",
                ),
                Tab(
                  text: "Media",
                ),
                Tab(
                  text: "People",
                )
              ]),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.cancel),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            SearchFeedWidget(searchText: widget.searchText),
            SearchCommunityWidget(searchText: widget.searchText),
            SearchCommentFeedWidget(searchText: widget.searchText),
            SearchMediaFeed(searchText: widget.searchText),
            SearchUserWidget(searchText: widget.searchText),
          ],
        ),
      ),
    );
  }
}
