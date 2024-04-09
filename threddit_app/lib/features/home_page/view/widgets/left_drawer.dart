import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/home_page/view/widgets/communities_tiles.dart';
import 'package:threddit_clone/features/home_page/view/widgets/following_tiles.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

///TODO: IMPLEMENT THE FAVOURITES LIST AND RECENTLY VIEWED USING SHARED PREFERENCES.

class LeftDrawer extends ConsumerStatefulWidget{
  const LeftDrawer({super.key});
  @override
  ConsumerState<LeftDrawer> createState()=>  _LeftDrawerState();
}

class _LeftDrawerState extends ConsumerState<LeftDrawer>{

  @override
  Widget build(BuildContext context) {
    return Theme(
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
      );
  }
}