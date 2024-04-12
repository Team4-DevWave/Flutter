import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class UserProfile extends ConsumerStatefulWidget {
  const UserProfile({super.key});
  @override
  ConsumerState<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile> with TickerProviderStateMixin {

  TabController?_tabController;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
    //intitialize tab controller
  }
 
  
  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Widget buildPostTab() {
    return Column(
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
                    "u/Me",
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
                        padding:  EdgeInsets.symmetric(horizontal:10.w, vertical: 75.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           CircleAvatar(
                              radius: 45.spMin,
                               backgroundImage:
                          const AssetImage('assets/images/Default_Avatar.png'),
                            ),
                           SizedBox(
                              height: 5.h,
                            ),
                            ElevatedButton(
                              style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      AppColors.whiteHideColor)),
                              onPressed: () {
                                Navigator.pushNamed(context, RouteClass.editUser);
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
                              "u/userName",
                              style: AppTextStyles.primaryTextStyle
                                  .copyWith(fontSize: 20.spMin),
                            ),
                           SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              "Followers",
                              style: AppTextStyles.primaryTextStyle,
                            ),
                           SizedBox(
                              height: 5 .h,
                            ),
                            Text(
                              "karma",
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
                    IconButton(onPressed: (){
                      Navigator.pushNamed(context, RouteClass.confirmPostScreen);
                    }, icon: const Icon(Icons.add, color: AppColors.whiteGlowColor,)),
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
            children: [
            buildPostTab(),
            buildCommentsTab(),
            buildAboutTab()
          ])
        )));
  }
}