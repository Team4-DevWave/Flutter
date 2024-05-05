import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/listing/view/widgets/FeedunitSharedScreen.dart';
import 'package:threddit_clone/features/listing/view/widgets/post_feed_widget.dart';

import 'package:lottie/lottie.dart';
import 'package:threddit_clone/features/post/viewmodel/save_post.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';

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
class FeedWidget extends ConsumerStatefulWidget {
  final String feedID;
  final String subreddit;
  const FeedWidget({super.key, required this.feedID, required this.subreddit});

  @override
  ConsumerState<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends ConsumerState<FeedWidget> {
  final _scrollController = ScrollController();
  final _posts = <Post>[];
  int _currentPage = 1;
  bool _fetching = true;
  bool _fetchingFinish = true;
  String? userId;

  @override
  void initState() {
    super.initState();
    getUserID();
    _fetchPosts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant FeedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.feedID != widget.feedID) {
      _posts.clear();
      _currentPage = 1;
      _fetching = true;
      _fetchingFinish = true;
      _fetchPosts();
      _scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> getUserID() async{
    userId = await getUserId();
    //userId = ref.read(userModelProvider)!.id!;
  }

  Future _fetchPosts() async {
    final response =
        await fetchPosts(widget.feedID, widget.subreddit, _currentPage);

    if (response.posts.isNotEmpty) {
      setState(() {
        _posts.addAll(response.posts);
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

  @override
  Widget build(BuildContext context) {
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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
              height: 100.h,
              width: 150.w,
              child: Image.asset('assets/images/threaddit_web.png')),
          SizedBox(
            height: 100.h,
            width: 150.w,
            child: Lottie.asset(
              'assets/animation/loading2.json',
              repeat: true,
            ),
          )
        ]));
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
        controller: _scrollController,
        itemCount: _posts.length + 1,
        itemBuilder: (context, index) {
          if (index < _posts.length) {
            return _posts[index].parentPost != null
                ? FeedUnitShare(
                    dataOfPost: _posts[index].parentPost!,
                    parentPost: _posts[index],
                    userId!)
                : FeedUnit(_posts[index], userId!);
          } else {
            return _fetchingFinish
                ? Center(
                    child: SizedBox(
                    height: 75.h,
                    width: 75.w,
                    child: Lottie.asset(
                      'assets/animation/loading2.json',
                      repeat: true,
                    ),
                  ))
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
      );
    }
  }
}
