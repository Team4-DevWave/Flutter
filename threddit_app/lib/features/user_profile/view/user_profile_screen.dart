import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/listing/view/widgets/FeedunitSharedScreen.dart';
import 'package:threddit_clone/features/listing/view/widgets/post_feed_widget.dart';
import 'package:threddit_clone/features/user_profile/view_model/fetchingPostForUser.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class UserProfile extends ConsumerStatefulWidget {
  const UserProfile({super.key});
  @override
  ConsumerState<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile>
    with TickerProviderStateMixin {
  final _scrollController = ScrollController();
  final _posts = <Post>[];
  int _currentPage = 1;
  TabController? _tabController;

  UserModelMe? user;
  void _getUserData() async {
    user = ref.read(userModelProvider)!;
  }

  String? uid;
  @override
  void initState() {
    _getUserData();
    _fetchPosts();
    _scrollController.addListener(_onScroll);
    _tabController = TabController(length: 3, vsync: this);
    setUserid();
    super.initState();
    //intitialize tab controller
  }

  Future<void> setUserid() async {
    uid = await getUserId();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future _fetchPosts() async {
    final response = await fetchPostsByUsername('moaz', _currentPage);

    setState(() {
      _posts.addAll(response.posts);
      _currentPage++;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      fetchPostsByUsername('moaz', _currentPage);
    }
  }

  Widget buildPostTab() {
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
                        parentPost: _posts[index],
                        uid!)
                    : FeedUnit(_posts[index], uid!);
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

  Widget buildCommentsTab() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.warning_amber,
          color: AppColors.whiteGlowColor,
        ),
        Text(
          "Wow, such empty in Comments!",
          style: AppTextStyles.primaryTextStyle,
        ),
      ],
    );
  }

  Widget buildAboutTab() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.warning_amber,
          color: AppColors.whiteGlowColor,
        ),
        Text(
          "Wow, such empty in About!",
          style: AppTextStyles.primaryTextStyle,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = <String>['Posts', 'Comments', 'About'];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  title: Text(
                    "u/${user?.username}",
                    style: AppTextStyles.secondaryTextStyle,
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: const [
                          Color.fromARGB(255, 0, 99, 145),
                          Color.fromARGB(255, 2, 55, 99),
                          Color.fromARGB(221, 14, 13, 13),
                          Colors.black,
                        ],
                        stops: [0.0.sp, 0.25.sp, 0.6.sp, 1.0.sp],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 75.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 45.spMin,
                              backgroundImage: const AssetImage(
                                  'assets/images/Default_Avatar.png'),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            ElevatedButton(
                              style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      AppColors.whiteHideColor)),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, RouteClass.editUser);
                              },
                              child: Text(
                                "Edit",
                                style: AppTextStyles.buttonTextStyle.copyWith(
                                    backgroundColor: Colors.transparent),
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              //to be replaced with the username from the user provider
                              "u/${user?.username}",
                              style: AppTextStyles.primaryTextStyle
                                  .copyWith(fontSize: 20.spMin),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              "${user?.followedUsers?.length} following",
                              style: AppTextStyles.primaryTextStyle,
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              "${(user?.karma?.posts ?? 0) + (user?.karma?.comments ?? 0)} karma",
                              style: AppTextStyles.secondaryTextStyle,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  expandedHeight: 340.h,
                  actions: [
                    const Align(
                      alignment: Alignment.centerRight,
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, RouteClass.confirmPostScreen);
                        },
                        icon: const Icon(
                          Icons.add,
                          color: AppColors.whiteGlowColor,
                        )),
                    IconButton(
                      onPressed: () {
                        //open search screen
                      },
                      icon: const Icon(
                        Icons.search_outlined,
                        color: AppColors.whiteGlowColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        //share profile modal bottom sheet
                      },
                      icon: const Icon(
                        Icons.share,
                        color: AppColors.whiteGlowColor,
                      ),
                    ),
                  ],
                  pinned: true,
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                      controller: _tabController,
                      indicatorColor: AppColors.redditOrangeColor,
                      labelStyle: AppTextStyles.buttonTextStyle,
                      tabs: tabs
                          .map((name) => Tab(
                                text: name,
                              ))
                          .toList()),
                ),
              )
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [buildPostTab(), buildCommentsTab(), buildAboutTab()],
          ),
        ),
      ),
    );
  }
}
