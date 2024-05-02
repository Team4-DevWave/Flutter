import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:threddit_clone/features/community/view%20model/get_community.dart';
import 'package:threddit_clone/features/home_page/view/widgets/community_feed_unit.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
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
  late Future<SubredditList> futuredata;
  late String userId;
  @override
  void initState() {
    futuredata = fetchSubredditsAll();
    setUserid();
    super.initState();
  }

  void setUserid() {
    //userId = (await getUserId())!;
    userId = ref.read(userModelProvider)!.id!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Communities",
          style: AppTextStyles.boldTextStyle,
        ),
      ),
      body: Container(
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
                final subredditData = snapshot.data!.subreddits;

                return ListView.builder(
                  itemCount: subredditData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CommunityUnit(
                      subreddit: subredditData[index],
                      userID: userId,
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
