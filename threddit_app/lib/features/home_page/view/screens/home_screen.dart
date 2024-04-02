import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/view/widgets/communities_tiles.dart';
import 'package:threddit_clone/features/home_page/view/widgets/following_tiles.dart';
import 'package:threddit_clone/features/home_page/view/widgets/right_drawer.dart';
import 'package:threddit_clone/features/listing/view/widgets/feed_widget.dart';
import 'package:threddit_clone/features/user_system/view_model/sign_in_with_google/google_auth_controller.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/photos.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String feedID = 'Best';
  final List<String> tabs = ['Best', 'Hot', 'New', 'Top'];

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    //final user = ref.watch(userProvider)!;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteClass.searchScreen);
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              _openEndDrawer();
            },
            icon: const Icon(Icons.person_rounded),
          ),
        ],
        title: DropdownMenu<String>(
          inputDecorationTheme: const InputDecorationTheme(
            border: InputBorder.none,
          ),
          textStyle: AppTextStyles.primaryTextStyle,
          dropdownMenuEntries:

              ///use provider here
              tabs.map<DropdownMenuEntry<String>>((String string) {
            return DropdownMenuEntry(value: string, label: string);
          }).toList(),
          width: 150,
          initialSelection: tabs[0],
          onSelected: (String? value) {
            setState(() {
              feedID = value!;
            });

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Changed to tab $value'),
              duration: Durations.short1,
            ));
          },
        ),
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(canvasColor: AppColors.mainColor),
        child: Drawer(
          elevation: double.maxFinite,
          backgroundColor: AppColors.mainColor,
          shadowColor: AppColors.mainColor,
          surfaceTintColor: AppColors.mainColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(
                  'Recently Visited',
                  style: AppTextStyles.primaryTextStyle
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const CommunitiesTiles(title: "Communities"),
              const FollowingTiles(title: "Following"),
            ],
          ),
        ),
      ),
      endDrawer: Drawer(
        backgroundColor: AppColors.mainColor,
        child: Column(
          children: [
            SizedBox(
              height: 150.h,
              child: DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, RouteClass.userProfileScreen);
                      },
                      child: Image.asset(
                        Photos.snoLogo,
                        width: 50.w,
                        height: 50.h,
                      ),
                    ),
                    Text(
                      "u/username",
                      //"u/${user.name}",
                      style: AppTextStyles.primaryTextStyle,
                    ),
                  ],
                ),
              ),
            ),
            RightDrawerButtons(
                icon: const Icon(
                  Icons.person_outline,
                  color: AppColors.whiteColor,
                ),
                title: "My profile",
                onTap: () {
                  Navigator.pushNamed(context, RouteClass.userProfileScreen);
                }),
            RightDrawerButtons(
                icon: const Icon(
                  Icons.group_add_outlined,
                  color: AppColors.whiteColor,
                ),
                title: "Create a community",
                onTap: () {
                  Navigator.pushNamed(
                      context, RouteClass.createCommunityScreen);
                }),
            RightDrawerButtons(
                icon: const Icon(
                  Icons.bookmarks_outlined,
                  color: AppColors.whiteColor,
                ),
                title: "Saved",
                onTap: () {}),
            RightDrawerButtons(
                icon: const Icon(
                  Icons.history_toggle_off_rounded,
                  color: AppColors.whiteColor,
                ),
                title: "History",
                onTap: () {}),
            RightDrawerButtons(
              icon: const Icon(
                Icons.logout_rounded,
                color: AppColors.whiteColor,
              ),
              title: "Logout",
              onTap: () => ref.watch(authControllerProvider.notifier).logout(),
            ),
            RightDrawerButtons(
                icon: const Icon(
                  Icons.settings_outlined,
                  color: AppColors.whiteColor,
                ),
                title: "Settings",
                onTap: () {
                  Navigator.pushNamed(context, RouteClass.accountSettingScreen);
                }),
          ],
        ),
      ),
      body: FeedWidget(feedID: feedID),
    );
  }
}
