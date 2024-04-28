import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/listing/view/widgets/FeedunitSharedScreen.dart';
import 'package:threddit_clone/features/listing/view/widgets/comment_item_user_profile.dart';
import 'package:threddit_clone/features/listing/view/widgets/post_feed_widget.dart';
import 'package:threddit_clone/features/user_profile/models/other_user_data.dart';
import 'package:threddit_clone/features/user_profile/view_model/fetchingPostForUser.dart';
import 'package:threddit_clone/features/user_profile/view_model/follow_user.dart';
import 'package:threddit_clone/features/user_profile/view_model/get_user.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/models/comment.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/theme/theme.dart';

class OtherUsersProfile extends ConsumerStatefulWidget {
  const OtherUsersProfile({super.key, required this.username});
  final String username;
  @override
  ConsumerState<OtherUsersProfile> createState() => _OtherUsersProfileState();
}

class _OtherUsersProfileState extends ConsumerState<OtherUsersProfile>
    with TickerProviderStateMixin {
  final _scrollController = ScrollController();
  final _scrollControllerComments = ScrollController();
  final _posts = <Post>[];
  int _currentPage = 1;
  bool _fetchingPosts = true;
  final _comments = <Comment>[];
  int _currentPageComments = 1;
  bool _fetchingPostsFinish = true;
  bool _fetchingComments = true;
  bool _fetchingCommentsFinish = true;
  TabController? _tabController;

  UserModelNotMe? user;
  bool isLoading = true;
  bool? isFollowed;

  void setData() async {
    //getUser function gets the user data and updates it in the provider
    setState(() {
      isLoading = true;
    });
    final res =
        await ref.watch(getUserProvider.notifier).getUser(widget.username);
    res.fold((l) => showSnackBar(navigatorKey.currentContext!, l.message), (r) {
      user = r;
    });
    final response = await followUser(user!.username!);
    response.fold((l) {
      if (l.message == "user already followed") {
        setState(() {
          isFollowed = true;
        });
      }
    }, (r) {
      setState(() {
        isFollowed = !r;
        unfollowUser(user!.username!);
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  String? uid;
  @override
  void initState() {
    //setData();
    _fetchPosts();
    _scrollController.addListener(_onScroll);
    _tabController = TabController(length: 3, vsync: this);
    _scrollControllerComments.addListener(_onScrollComments);
    setUserid();
    _fetchComments();
    super.initState();
  }

  Future _fetchComments() async {
    final response = await fetchComments(
      widget.username,
    );

    if (response.isNotEmpty) {
      setState(() {
        _comments.addAll(response);
        _currentPageComments++;
        _fetchingComments = false;
        if (response.length < 10) {
          _fetchingCommentsFinish = false;
        }
      });
    } else {
      setState(() {
        _fetchingComments = false;
        _fetchingCommentsFinish = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    setData();

    super.didChangeDependencies();
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
    final response = await fetchPostsByUsername(widget.username, _currentPage);

    if (response.posts.isNotEmpty) {
      setState(() {
        _posts.addAll(response.posts);
        _currentPage++;
        _fetchingPosts = false;
      });
    } else {
      setState(() {
        _fetchingPosts = false;
        _fetchingPostsFinish = false;
      });
    }
  }

  Widget buildCommentsTab() {
    return _comments.isEmpty
        ? Column(
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
          )
        : ListView.builder(
            controller: _scrollController,
            itemCount: _comments.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      _comments[index].user.username,
                      style: AppTextStyles.boldTextStyleNotifcation,
                    )
                  ],
                ),
              );
            },
          );
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      fetchPostsByUsername(user?.username ?? '', _currentPage);
    }
  }

  void _onFollow() {
    if (!isFollowed!) {
      followUser(user!.username!);
      setState(() {
        isFollowed = true;
      });
      showSnackBar(context, "${user!.username} followed successfully");
    } else {
      unfollowUser(user!.username!);
      setState(() {
        isFollowed = false;
      });
      showSnackBar(context, "${user!.username} unfollowed successfully");
    }
  }

  void _onScrollComments() {
    if (_scrollControllerComments.position.pixels ==
        _scrollControllerComments.position.maxScrollExtent) {
      _fetchComments();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = <String>['Posts', 'Comments', 'About'];

    ImageProvider setProfilePic() {
      // if (imageFile != null) {
      //   return FileImage(imageFile);
      // } else {
      // }
      return const AssetImage('assets/images/Default_Avatar.png');
    }

    return !isLoading
        ? DefaultTabController(
            length: tabs.length,
            child: Scaffold(
              body: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return <Widget>[
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
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
                                      backgroundImage: setProfilePic()),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  ElevatedButton(
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                AppColors.whiteHideColor)),
                                    onPressed: () {
                                      _onFollow();
                                    },
                                    child: Text(
                                      isFollowed! ? "Unfollow" : "Follow",
                                      style: AppTextStyles.buttonTextStyle
                                          .copyWith(
                                              backgroundColor:
                                                  Colors.transparent),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        //"u/User",
                                        user?.displayName == ""
                                            ? "u/${user?.username}"
                                            : "u/${user?.displayName}",
                                        style: AppTextStyles.primaryTextStyle
                                            .copyWith(fontSize: 20.spMin),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Icon(
                                        Icons.circle,
                                        color: Colors.white,
                                        size: 6.r,
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        "${(user?.karma?.posts ?? 0) + (user?.karma?.comments ?? 0)} karma",
                                        style: AppTextStyles.secondaryTextStyle,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    user?.userProfileSettings?.about != null
                                        ? user!.userProfileSettings!.about
                                        : "",
                                    style: AppTextStyles.secondaryTextStyle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
                              //open search screen
                            },
                            icon: const Icon(
                              Icons.search_outlined,
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
                body: Stack(
                  children: [
                    Positioned.fill(
                      top: 100.h,
                      child: TabBarView(controller: _tabController, children: [
                        _posts.isEmpty
                            ? _fetchingPosts
                                ? SizedBox(
                                    height: 75.h,
                                    width: 75.w,
                                    child: Lottie.asset(
                                      'assets/animation/loading.json',
                                      repeat: true,
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.warning_amber,
                                        color: AppColors.whiteGlowColor,
                                      ),
                                      Text(
                                        "Wow, such empty in Posts!",
                                        style: AppTextStyles.primaryTextStyle,
                                      ),
                                    ],
                                  )
                            : ListView.builder(
                                controller: _scrollController,
                                itemCount: _posts.length + 1,
                                itemBuilder: (context, index) {
                                  if (index < _posts.length) {
                                    return _posts[index].parentPost != null
                                        ? FeedUnitShare(
                                            dataOfPost:
                                                _posts[index].parentPost!,
                                            parentPost: _posts[index],
                                            uid!)
                                        : FeedUnit(_posts[index], uid!);
                                  } else {
                                    return _fetchingPostsFinish
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
                        _comments.isEmpty
                            ? _fetchingComments
                                ? SizedBox(
                                    height: 75.h,
                                    width: 75.w,
                                    child: Lottie.asset(
                                      'assets/animation/loading.json',
                                      repeat: true,
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                  )
                            : ListView.builder(
                                controller: _scrollControllerComments,
                                itemCount: _comments.length + 1,
                                itemBuilder: (context, index) {
                                  if (index < _comments.length) {
                                    return CommentItemForProfile(
                                        comment: _comments[index], uid: uid!);
                                  } else {
                                    return SizedBox(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          'No more Comments ',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ));
                                  }
                                },
                              ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 30.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "${user?.karma?.posts}",
                                        style: AppTextStyles.boldTextStyle,
                                      ),
                                      Text(
                                        "Post karma",
                                        style: AppTextStyles
                                            .primaryButtonHideTextStyle,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 50.w,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "${user?.karma?.comments}",
                                        style: AppTextStyles.boldTextStyle,
                                      ),
                                      Text(
                                        "Comments karma",
                                        style: AppTextStyles
                                            .primaryButtonHideTextStyle,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(),
                              Text(
                                user!.userProfileSettings!.about,
                                style: AppTextStyles.secondaryTextStyle,
                              ),
                            ],
                          ),
                        )
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          )
        : const Loading();
  }
}
