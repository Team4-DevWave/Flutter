import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threddit_clone/features/home_page/view/widgets/communities_tiles.dart';
import 'package:threddit_clone/features/home_page/view/widgets/following_tiles.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

///TODO: IMPLEMENT THE FAVOURITES LIST AND RECENTLY VIEWED USING SHARED PREFERENCES.

class LeftDrawer extends StatefulWidget{
  const LeftDrawer({super.key});

  @override
  State<LeftDrawer> createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  String?_favourites;

  void _getFavourites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favourites = prefs.getString('favourites');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
    );
  }
}