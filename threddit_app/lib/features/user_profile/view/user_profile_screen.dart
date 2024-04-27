// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/listing/view/widgets/FeedunitSharedScreen.dart';
import 'package:threddit_clone/features/listing/view/widgets/post_feed_widget.dart';
import 'package:threddit_clone/features/user_profile/view_model/fetchingPostForUser.dart';
import 'package:threddit_clone/features/user_profile/view_model/on_link.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:threddit_clone/features/user_system/view_model/user_settings_provider.dart';
import 'package:threddit_clone/models/comment.dart';
import 'package:threddit_clone/theme/button_styles.dart';
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
  List<List<String>>? socialLinks;

  TabController? _tabController;
  final _comments = <Comment>[];
  bool _fetchingPosts = true;
  bool _fetchingPostsFinish = true;
  UserModelMe? user;
  void _getUserData() async {
    user = ref.read(userModelProvider)!;
    socialLinks = ref.read(userProfileProvider)?.socialLinks;
  }

  void setData() async {
    //getSettings function gets the user settings data and updates it in the provider
    await ref.read(settingsFetchProvider.notifier).getSettings();
  }

  String? uid;
  @override
  void initState() {
    _getUserData();
    _fetchPosts();
    setData();
    _scrollController.addListener(_onScroll);
    _tabController = TabController(length: 3, vsync: this);
    setUserid();
    super.initState();
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
    final response =
        await fetchPostsByUsername(user!.username ?? '', _currentPage);

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
      _fetchPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = <String>['Posts', 'Comments', 'About'];
    final settings = ref.watch(userProfileProvider);
    final imageFile = ref.watch(imagePathProvider);

    ImageProvider setProfilePic() {
      if (imageFile != null) {
        return FileImage(imageFile);
      } else {
        return const AssetImage('assets/images/Default_Avatar.png');
      }
    }

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                                backgroundImage: setProfilePic()),
                            SizedBox(
                              height: 5.h,
                            ),
                            ElevatedButton(
                              style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      AppColors.whiteHideColor)),
                              onPressed: () {
                                Navigator.pushNamed(
                                        context, RouteClass.editUser)
                                    .then((value) => setState(() {
                                          socialLinks = ref
                                              .read(userProfileProvider)
                                              ?.socialLinks;
                                        }));
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
                              settings!.displayName == ""
                                  ? "u/${user?.username}"
                                  : "u/${settings.displayName}",
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
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            if (settings.about != "")
                              Text(
                                settings.about,
                                style: AppTextStyles.secondaryTextStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            Expanded(
                              child: Wrap(
                                spacing: 7.0.w,
                                runSpacing: 5.0.h,
                                children: socialLinks!
                                    .map(
                                      (link) => ElevatedButton(
                                        style: AppButtons.interestsButtons
                                            .copyWith(
                                                minimumSize:
                                                    const MaterialStatePropertyAll(
                                                        Size(20, 25))),
                                        onPressed: () {
                                          onLink(link);
                                        },
                                        child: Text(
                                          link[1],
                                          style: AppTextStyles.primaryTextStyle
                                              .copyWith(fontSize: 13.spMin),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
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
          body: Stack(
            children: [
              Positioned.fill(
                top: 100.h,
                child: TabBarView(controller: _tabController, children: [
                  _posts.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                        ),
                  buildCommentsTab(),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 30.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "${user?.karma?.posts}",
                                  style: AppTextStyles.boldTextStyle,
                                ),
                                Text(
                                  "Post karma",
                                  style:
                                      AppTextStyles.primaryButtonHideTextStyle,
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
                                  style:
                                      AppTextStyles.primaryButtonHideTextStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(),
                        Text(
                          "${settings?.about}",
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
    );
  }
}
