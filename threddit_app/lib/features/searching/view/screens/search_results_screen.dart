import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/Moderation/model/moderator.dart';
import 'package:threddit_clone/features/Moderation/view/widgets/moderators_search.dart';
import 'package:threddit_clone/features/Moderation/view_model/moderation_apis.dart';
import 'package:threddit_clone/features/searching/model/search_model.dart';
import 'package:threddit_clone/features/searching/view/widgets/search_community_widget.dart';
import 'package:threddit_clone/features/searching/view/widgets/search_feed_widget.dart';
import 'package:threddit_clone/features/searching/view/widgets/search_users_widget.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:http/http.dart' as http;

enum ViewType { all, editable }

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
            ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    widget.searchResults.posts[index].title,
                    style: AppTextStyles.primaryTextStyle,
                  ),
                );
              },
              itemCount: widget.searchResults.posts.length,
            ),
            ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    widget.searchResults.posts[index].title,
                    style: AppTextStyles.primaryTextStyle,
                  ),
                );
              },
              itemCount: widget.searchResults.posts.length,
            ),
            SearchUserWidget(searchText: widget.searchText),
          ],
        ),
      ),
    );
  }
}
