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

///
/// This screen fetches a list of all subreddits and presents them in two
/// categories: "Trending Globally" and "Top Globally". The fetched list
/// is divided using a randomization function that randomly splits the list
/// into the two lists displayed in "Trending Globally" and "Top Globally"
/// 
/// It uses a [FutureBuilder] to handle the asynchronous 
/// fetching of subreddit data.
///
/// The screen layout includes an [AppBar], a [Drawer] on the left 
/// (provided by [LeftDrawer]), an end [Drawer] on the right (provided by
/// [RightDrawer]), and the main content area displaying the communities.

class MainCommunityScreen extends ConsumerStatefulWidget {
  const MainCommunityScreen({super.key});

  @override
  ConsumerState<MainCommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<MainCommunityScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<SubredditList> futuredata;
  late String userId;
  @override
  void initState() {
    futuredata = fetchSubredditsAll();
    setUserid();
    super.initState();
  }
  /// Get the user Id from the [userModelProvider] provider
  void setUserid() {
    userId = ref.read(userModelProvider)!.id!;
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
                    getRandomSubreddits(snapshot.data!.subreddits);
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

 /// This function takes the fetched user subreddits and shuffles the list
  /// After shuffling, the list is divided into two lists  to be displayed in 
  /// "Top Globally" and "Trending Globally"
  List<List<Subreddit>> getRandomSubreddits(List<Subreddit> allSubreddits) {
    List<List<Subreddit>> dividedSubs = [];
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
