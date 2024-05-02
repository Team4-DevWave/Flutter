import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:threddit_clone/features/home_page/view/widgets/community_feed_unit.dart';
import 'package:threddit_clone/features/searching/model/search_model.dart';
import 'package:threddit_clone/features/searching/view_model/searching_apis.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';

import 'package:threddit_clone/models/subreddit.dart';

class SearchCommunityWidget extends ConsumerStatefulWidget {
  final String searchText;
  const SearchCommunityWidget({super.key, required this.searchText});

  @override
  ConsumerState<SearchCommunityWidget> createState() =>
      _SearchCommunityScreenState();
}

class _SearchCommunityScreenState extends ConsumerState<SearchCommunityWidget> {
  final _scrollController = ScrollController();
  final _subreddits = <Subreddit>[];
  int _currentPage = 1;
  bool _fetching = true;
  bool _fetchingFinish = true;
  String? userId;

  @override
  void initState() {
    super.initState();
    getUserID();
    print("I AM THE USER ID HELLO !: ");
    print(userId);
    _fetchSubreddits();
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

  Future _fetchSubreddits() async {
    print("ALOOOOOOOOOOOOOOOOOOOOO1111");

    final response = await searchTest(widget.searchText, _currentPage);

    final SearchModel results = response;
    print(results.subreddits.length);

    if (results.subreddits.isNotEmpty) {
      setState(() {
        _subreddits.addAll(results.subreddits);
        _currentPage++;
        _fetching = true;
        if (_subreddits.length < 10) {
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
      _fetchSubreddits();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_subreddits.isEmpty) {
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
      return ListView.builder(
        controller: _scrollController,
        itemCount: _subreddits.length + 1,
        itemBuilder: (context, index) {
          if (index < _subreddits.length) {
            return CommunityUnit(
              subreddit: _subreddits[index],
              userID: userId!,
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
                        'No more communities available.',
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
