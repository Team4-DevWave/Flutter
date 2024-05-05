import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:lottie/lottie.dart';

import 'package:threddit_clone/features/searching/model/search_comment_model.dart';
import 'package:threddit_clone/features/searching/model/search_model.dart';
import 'package:threddit_clone/features/searching/view/widgets/search_comment_item.dart';

import 'package:threddit_clone/features/searching/view_model/searching_apis.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';

/// The `feed_widget.dart` file defines a stateful widget `FeedWidget` that is used to
/// display a feed of posts. The widget takes a `feedID` as a parameter, which is used
/// to fetch the posts for the specific feed.

/// The `_FeedWidgetState` class manages the state for this widget. It maintains a list
/// of `Post` objects, `_comments`, which are displayed in the feed, and a page counter,
/// `_currentPage`, which is used for pagination of the posts.

/// The `_fetchPosts` method is used to fetch the posts from the server. It adds the
/// fetched posts to the `_comments` list and increments the `_currentPage` counter.

/// The `_onScroll` method is a listener that triggers the `_fetchPosts` method when the
/// user scrolls to the end of the feed, enabling infinite scrolling.

/// The `initState` method initializes the state of the widget by fetching the first set
/// of posts. The `dispose` method is used to clean up the controller when the widget is
/// removed from the widget tree.
class SearchCommentFeedWidget extends ConsumerStatefulWidget {
  final String searchText;
  const SearchCommentFeedWidget({super.key, required this.searchText});

  @override
  ConsumerState<SearchCommentFeedWidget> createState() =>
      _SearchCommentFeedWidgetState();
}

class _SearchCommentFeedWidgetState
    extends ConsumerState<SearchCommentFeedWidget> {
  final _scrollController = ScrollController();
  final _comments = <SearchCommentModel>[];
  int _currentPage = 1;
  bool _fetching = true;
  bool _fetchingFinish = true;
  String? userId;

  @override
  void initState() {
    super.initState();
    getUserID();
    _fetchComments();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> getUserID() async {
    userId = await getUserId();
  }

  Future _fetchComments() async {
    final response = await searchTest(widget.searchText, _currentPage);

    final SearchModel results = response;

    if (results.comments.isNotEmpty) {
      setState(() {
        _comments.addAll(results.comments);
        _currentPage++;
        _fetching = true;
        if (_comments.length < 10) {
          _fetchingFinish = false;
        }
      });
    } else {
      setState(() {
        _fetching = false;
        _fetchingFinish = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchComments();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_comments.isEmpty) {
      if (_fetching) {
        return Center(
          child: Lottie.asset(
            'assets/animation/loading.json',
            repeat: true,
          ),
        );
      } else {
        return Center(
          child: Text(
            'No feed available.',
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.white,
            ),
          ),
        );
      }
    } else {
      return ListView.builder(
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: _comments.length + 1,
        itemBuilder: (context, index) {
          if (index < _comments.length) {
            return Column(
              children: [
                SearchCommentItem(
                  comment: _comments[index],
                  uid: userId!,
                  parentPost: _comments[index].post,
                ),
                const Divider(),
              ],
            );
          } else {
            return _fetchingFinish
                ? SizedBox(
                    height: 75.h,
                    width: 75.w,
                    child: Lottie.asset(
                      'assets/animation/loading.json',
                      repeat: true,
                    ),
                  )
                : SizedBox(
                    child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'No more comments available.',
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ));
          }
        },
      );
    }
  }
}
