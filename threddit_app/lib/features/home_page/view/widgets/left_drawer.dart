import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/home_page/view/widgets/communities_tiles.dart';
import 'package:threddit_clone/features/home_page/view/widgets/following_tiles.dart';
import 'package:threddit_clone/features/home_page/view_model/favourites_provider.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class LeftDrawer extends ConsumerStatefulWidget {
  const LeftDrawer({super.key});

  @override
  ConsumerState<LeftDrawer> createState() => _LeftDrawerState();
}

class _LeftDrawerState extends ConsumerState<LeftDrawer> {
  List<String>? favouritesList;
  Future<void> _setData() async {
    await ref.read(settingsFetchProvider.notifier).getMe();
  }

  @override
  void initState() {
    _setData(); 
    super.initState();
  }

  @override
  void didChangeDependencies() {
    favouritesList = ref.watch(favouriteListProvider);
    super.didChangeDependencies();
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
          //favouritesList == [] ? const SizedBox() : const FavouriteTiles(),
          const CommunitiesTiles(title: "Communities"),
          const FollowingTiles(title: "Following"),
        ],
      ),
    );
  }
}
