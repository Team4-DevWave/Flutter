import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_app/features/home_page/model/left_drawer_data.dart';
import 'package:threddit_app/features/home_page/model/user_data.dart';
import 'package:threddit_app/features/home_page/view/search_screen.dart';
import 'package:threddit_app/features/home_page/view/user_profile_screen.dart';
import 'package:threddit_app/features/home_page/view/widgets/left_drawer_tiles.dart';
import 'package:threddit_app/features/home_page/view/widgets/right_drawer.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:threddit_app/theme/photos.dart';
import 'package:threddit_app/theme/text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> tabs = ['Best', 'Hot', 'New', 'Top'];

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SearchScreen()));
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
          width: MediaQuery.of(context).size.width,
          initialSelection: tabs[0],
          onSelected: (String? value) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Changed to tab $value')));
          },
        ),
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(canvasColor: AppColors.mainColor),
        child: Drawer(
          elevation: double.maxFinite,
          backgroundColor: AppColors.mainColor,
          shadowColor: null,
          surfaceTintColor: null,
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
              LeftDrawerTiles(title: "Communities", data: communitiesTiles),
              LeftDrawerTiles(title: "Following", data: follwoingTile),
            ],
          ),
        ),
      ),
      endDrawer: Drawer(
        backgroundColor: AppColors.mainColor,
        child: Column(
          children: [
            SizedBox(
              height: 450,
              child: DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const UserProfile();
                        }));
                      },
                      child: Image.asset(
                        Photos.snoLogo,
                        width: 100.w,
                        height: 100.h,
                      ),
                    ),
                    Text(
                      "u/UserName",
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const UserProfile();
                  }));
                }),
            RightDrawerButtons(
                icon: const Icon(
                  Icons.group_add_outlined,
                  color: AppColors.whiteColor,
                ),
                title: "Create a community",
                onTap: () {}),
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.17),
            RightDrawerButtons(
                icon: const Icon(
                  Icons.settings_outlined,
                  color: AppColors.whiteColor,
                ),
                title: "Settings",
                onTap: () {}),
          ],
        ),
      ),
    );
  }
}
