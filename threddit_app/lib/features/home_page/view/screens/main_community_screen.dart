import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:threddit_clone/features/community/view%20model/get_community.dart';
import 'package:threddit_clone/features/home_page/view/widgets/community_feed_unit.dart';
import 'package:threddit_clone/features/home_page/view/widgets/left_drawer.dart';
import 'package:threddit_clone/features/home_page/view/widgets/right_drawer.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';

import 'package:threddit_clone/models/subreddit.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class MainCommunityScreen extends ConsumerStatefulWidget {
  const MainCommunityScreen({super.key});

  @override
  ConsumerState<MainCommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<MainCommunityScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<SubredditList> futuredata;
  late String userId;
  List<List<Subreddit>> dividedSubs = [];
  @override
  void initState() {
    futuredata = fetchSubredditsAll();
    setUserid();
    super.initState();
  }

  void setUserid() {
    userId = ref.read(userModelProvider)!.id!;
  }

  List<List<Subreddit>> _getRandomSubreddits(List<Subreddit> allSubreddits) {
    // Shuffle the list
    allSubreddits.shuffle();
    // Divide the list into two
    int length = allSubreddits.length;
    int half = (length / 2).round();
    List<Subreddit> list1 = allSubreddits.take(half).toList();
    List<Subreddit> list2 =
        allSubreddits.skip(half).take(length - half).toList();
    dividedSubs.add(list1);
    dividedSubs.add(list2);
    return dividedSubs;
  }

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    List<String> titles = ["Trending Globally", "Top Globally"];
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text(
            "Communities",
            style: AppTextStyles.boldTextStyle,
          ),
          actions: [
            IconButton(
              onPressed: () {
                _openEndDrawer();
              },
              icon: const Icon(Icons.person_rounded),
            ),
          ]),
      drawer: const LeftDrawer(),
      endDrawer: const RightDrawer(),
      body: Container(
          padding: EdgeInsets.all(8.spMin),
          color: AppColors.backgroundColor,
          child: FutureBuilder<SubredditList>(
            future: futuredata,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Lottie.asset(
                    'assets/animation/loading2.json',
                    repeat: true,
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else if (snapshot.hasData) {
                final subredditData =
                    _getRandomSubreddits(snapshot.data!.subreddits);
                return ListView.builder(
                  itemCount: 2,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 15.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titles[index],
                            style: AppTextStyles.boldTextStyle,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          CommunityUnit(
                            subreddit: subredditData[index],
                            userID: userId,
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return const Text('No data available.');
              }
            },
          )),
    );
  }
}
