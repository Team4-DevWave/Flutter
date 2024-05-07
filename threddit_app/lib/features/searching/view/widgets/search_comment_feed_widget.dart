import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/listing/view/widgets/FeedunitSharedScreen.dart';
import 'package:threddit_clone/features/listing/view/widgets/post_feed_widget.dart';

import 'package:lottie/lottie.dart';
import 'package:threddit_clone/features/post/viewmodel/save_post.dart';
import 'package:threddit_clone/features/searching/model/search_comment_model.dart';
import 'package:threddit_clone/features/searching/model/search_model.dart';
import 'package:threddit_clone/features/searching/view/widgets/search_comment_item.dart';
import 'package:threddit_clone/features/searching/view/widgets/search_feed_widget.dart';
import 'package:threddit_clone/features/searching/view/widgets/search_post_feed_widget.dart';
import 'package:threddit_clone/features/searching/view/widgets/search_shared_feed_unit.dart';
import 'package:threddit_clone/features/searching/view_model/searching_apis.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

/// The `SearchCommentFeedWidget` widget displays a feed of comments related to a specific search query. It takes a [searchText] parameter as input, 
/// which represents the search query entered by the user.
/// 
/// The `_SearchCommentFeedWidgetState` class manages the state for this widget. 
/// It maintains a list of `SearchCommentModel` objects, `_comments`, which are displayed in the feed.
///  Additionally, it handles pagination of comments using a `_currentPage` counter and implements infinite scrolling functionality with the `_fetchComments` method.
/// 
/// The `_fetchComments` method is responsible for fetching comments from the server based on the provided search query and page number. 
/// It adds the fetched comments to the `_comments` list and updates the `_currentPage` counter accordingly.
/// 
/// The `_onScroll` method is a listener attached to the scroll controller. 
/// It triggers the `_fetchComments` method when the user scrolls to the end of the feed, allowing for continuous loading of comments.
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
  final List<String> tabs = ['Best', 'Hot', 'New', 'Top'];

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
    String searchValue = ref.read(selectedSortProvider);
    final response =
        await searchTest(widget.searchText, _currentPage, sorting: searchValue);

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
    ref.listen(selectedSortProvider, (previous, next) {
      setState(() {
        _comments.clear();
        _currentPage = 1;
        _fetching = true;
        _fetchingFinish = true;
      });
      _fetchComments();
    });
    if (_comments.isEmpty) {
      if (_fetching) {
        return Center(
          child: Lottie.asset(
            'assets/animation/loading2.json',
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
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownMenu<String>(
            inputDecorationTheme: const InputDecorationTheme(
              border: InputBorder.none,
            ),
            textStyle: AppTextStyles.primaryTextStyle,
            dropdownMenuEntries:
                tabs.map<DropdownMenuEntry<String>>((String string) {
              return DropdownMenuEntry(value: string, label: string);
            }).toList(),
            width: 150.w,
            initialSelection: ref.read(selectedSortProvider),
            onSelected: (String? value) {
              ref.read(selectedSortProvider.notifier).state = value!;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Changed to tab $value'),
                duration: Durations.short1,
              ));
            },
          ),
          Expanded(
            child: ListView.builder(
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
                            'assets/animation/loading2.json',
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
            ),
          ),
        ],
      );
    }
  }
}
