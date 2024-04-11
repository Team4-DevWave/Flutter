import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/listing/view/widgets/FeedunitSharedScreen.dart';
import 'package:threddit_clone/features/listing/view/widgets/post_feed_widget.dart';

import 'package:lottie/lottie.dart';

class FeedWidget extends StatefulWidget {
  final String feedID;
  const FeedWidget({Key? key, required this.feedID}) : super(key: key);

  @override
  _FeedWidgetState createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  final _scrollController = ScrollController();
  final _posts = <Post>[];
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future _fetchPosts() async {
    final response = await fetchPosts();

    setState(() {
      _posts.addAll(response.posts);
      _currentPage++;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _posts.isEmpty
        ? Center(
            child: Lottie.asset(
            'assets/animation/loading.json',
            repeat: true,
          ))
        : ListView.builder(
            controller: _scrollController,
            itemCount: _posts.length + 1,
            itemBuilder: (context, index) {
              if (index < _posts.length) {
                return _posts[index].parentPost != null
                    ? FeedUnitShare(
                        dataOfPost: _posts[index].parentPost!,
                        parentPost: _posts[index])
                    : FeedUnit(_posts[index]);
              } else {
                return SizedBox(
                  height: 75.h,
                  width: 75.w,
                  child: Lottie.asset(
                    'assets/animation/loading.json',
                    repeat: true,
                  ),
                );
              }
            },
          );
  }
}
