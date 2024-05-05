import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/listing/view/widgets/FeedunitSharedScreen.dart';
import 'package:threddit_clone/features/listing/view/widgets/post_feed_widget.dart';

import 'package:lottie/lottie.dart';
import 'package:threddit_clone/features/post/viewmodel/save_post.dart';
import 'package:threddit_clone/features/searching/model/search_model.dart';
import 'package:threddit_clone/features/searching/view/widgets/search_post_feed_widget.dart';
import 'package:threddit_clone/features/searching/view/widgets/search_shared_feed_unit.dart';
import 'package:threddit_clone/features/searching/view_model/searching_apis.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

/// The `feed_widget.dart` file defines a stateful widget `FeedWidget` that is used to
/// display a feed of posts. The widget takes a `feedID` as a parameter, which is used
/// to fetch the posts for the specific feed.

/// The `_FeedWidgetState` class manages the state for this widget. It maintains a list
/// of `Post` objects, `_posts`, which are displayed in the feed, and a page counter,
/// `_currentPage`, which is used for pagination of the posts.

/// The `_fetchPosts` method is used to fetch the posts from the server. It adds the
/// fetched posts to the `_posts` list and increments the `_currentPage` counter.

/// The `_onScroll` method is a listener that triggers the `_fetchPosts` method when the
/// user scrolls to the end of the feed, enabling infinite scrolling.

/// The `initState` method initializes the state of the widget by fetching the first set
/// of posts. The `dispose` method is used to clean up the controller when the widget is
/// removed from the widget tree.
final selectedSortProvider = StateProvider<String>((ref) => "Top");

class SearchFeedWidget extends ConsumerStatefulWidget {
  final String searchText;
  const SearchFeedWidget({super.key, required this.searchText});

  @override
  ConsumerState<SearchFeedWidget> createState() => _SearchFeedWidgetState();
}

class _SearchFeedWidgetState extends ConsumerState<SearchFeedWidget> {
  
  final _scrollController = ScrollController();
  final _posts = <Post>[];
  int _currentPage = 1;
  bool _fetching = true;
  bool _fetchingFinish = true;
  String? userId;
  final List<String> tabs = ['Best', 'Hot', 'New', 'Top'];
  @override
  void initState() {
    super.initState();
    getUserID();
    _fetchPosts();
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

  Future _fetchPosts() async {
    String searchValue = ref.read(selectedSortProvider);
    final response =
        await searchTest(widget.searchText, _currentPage, sorting: searchValue);

    final SearchModel results = response;
    if (results.posts.isNotEmpty) {
      setState(() {
        _posts.addAll(results.posts);
        _currentPage++;
        _fetching = true;
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
      _fetchPosts();
    }
  }

  void onSortChange() {
    _fetchPosts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(selectedSortProvider, (previous, next) {
      setState(() {
        _posts.clear();
        _currentPage = 1;
        _fetching = true;
        _fetchingFinish = true;
      });
      _fetchPosts();
    });
    ref.listen(updatesDeleteProvider, (previous, next) {
      if (next != null) {
        setState(() {
          _posts.clear();
          _currentPage = 1;
          _fetching = true;
          _fetchingFinish = true;
        });
        _fetchPosts();
      }
    });
    ref.listen(updatesEditProvider, (previous, next) {
      if (next != null) {
        setState(() {
          _posts.clear();
          _currentPage = 1;
          _fetching = true;
          _fetchingFinish = true;
        });
        _fetchPosts();
      }
    });
    if (_posts.isEmpty) {
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
              controller: _scrollController,
              itemCount: _posts.length + 1,
              itemBuilder: (context, index) {
                if (index < _posts.length) {
                  return _posts[index].parentPost != null
                      ? Column(
                          children: [
                            SearchFeedUnitShare(
                                dataOfPost: _posts[index].parentPost!,
                                parentPost: _posts[index],
                                userId!),
                            const Divider(color: AppColors.whiteHideColor),
                          ],
                        )
                      : Column(
                          children: [
                            SearchFeedUnit(_posts[index], userId!),
                            const Divider(color: AppColors.whiteHideColor),
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
                              'No more posts available.',
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
