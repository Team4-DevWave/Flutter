import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/model/visited_item.dart';
import 'package:threddit_clone/features/home_page/view/widgets/communities_tiles.dart';
import 'package:threddit_clone/features/home_page/view/widgets/favourites_tiles.dart';
import 'package:threddit_clone/features/home_page/view/widgets/following_tiles.dart';
import 'package:threddit_clone/features/home_page/view/widgets/moderating_tiles.dart';
import 'package:threddit_clone/features/home_page/view_model/favrourite_notifier.dart';
import 'package:threddit_clone/features/home_page/view_model/get_user_communities.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/photos.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/theme/theme.dart';

/// A drawer widget displaying user activity and navigation options.
///
/// This drawer displays various sections related to the user's activity:
/// - Recently visited communities and users.
/// - Favorite communities and users ([FavouriteTiles]).
/// - Communities the user moderates ([ModeratingTiles]).
/// - Communities the user is a member of ([CommunitiesTiles]).
/// - Users the current user is following ([FollowingTiles]).
///
/// The drawer fetches data for these sections from various providers.
/// It also handles displaying a second drawer for showing all recently visited
/// items if the user clicks on "See all".
///
/// If there are no items in any of the sections, a message indicating that the
/// drawer is empty is displayed.

class LeftDrawer extends ConsumerStatefulWidget {
  const LeftDrawer({super.key});

  @override
  ConsumerState<LeftDrawer> createState() => _LeftDrawerState();
}

class _LeftDrawerState extends ConsumerState<LeftDrawer> {
  List<VisitedItem> recentlyVisted = [];
  List<List<String>> userCommunitiesData = [];
  List<List<String>> moderatingCommunities = [];
  List<String>? favouritesList;
  bool isLoading = false;

  /// Gets all the initial data of the drawer from the provider on opening the screen
  Future<void> _setData() async {
    setState(() {
      isLoading = true;
    });
    await ref.read(settingsFetchProvider.notifier).getMe();
    recentlyVisted = await getRecentVisits();
    final response =
        await ref.read(userCommunitisProvider.notifier).getUserCommunities();
    response.fold(
        (failure) =>
            showSnackBar(navigatorKey.currentContext!, failure.message),
        (list) => userCommunitiesData = list);

    final response2 =
        await ref.read(userCommunitisProvider.notifier).getUserModerating();
    response2.fold(
        (failure) =>
            showSnackBar(navigatorKey.currentContext!, failure.message),
        (list) => moderatingCommunities = list);

    final resp = await ref.read(favouriteProvider.notifier).getFavourite();
    resp.fold(
        (failure) =>
            showSnackBar(navigatorKey.currentContext!, failure.message),
        (r) => null);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    _setData();
    super.initState();
  }

  bool _showSecondDrawer = false;

  @override
  Widget build(BuildContext context) {
    ref.watch(favouriteList);

    final limitedRecentlyVisited = recentlyVisted.take(3).toList();
    return Stack(children: [
      Drawer(
        elevation: double.maxFinite,
        backgroundColor: AppColors.backgroundColor,
        shadowColor: AppColors.backgroundColor,
        surfaceTintColor: AppColors.backgroundColor,
        child: isLoading
            ? const Loading()
            : recentlyVisted.isEmpty &&
                    ref.read(favouriteList).isEmpty &&
                    ref.read(userModelProvider)!.followedUsers!.isEmpty &&
                    userCommunitiesData.isEmpty
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.warning_amber,
                        color: AppColors.whiteGlowColor,
                      ),
                      Text(
                        "Wow, such empty in activity!",
                        style: AppTextStyles.primaryTextStyle,
                      ),
                    ],
                  )
                : ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      if (recentlyVisted.isNotEmpty)
                        SizedBox(
                          height: limitedRecentlyVisited.length * 50.h + 60.h,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 40.h),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.spMin),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Recently Visited',
                                            style: AppTextStyles
                                                .primaryTextStyle
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _showSecondDrawer = true;
                                              });
                                            },
                                            child: Text(
                                              'See all',
                                              style: AppTextStyles
                                                  .primaryTextStyle
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15.spMin),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ListView.builder(
                                      padding: EdgeInsets.all(0.spMin),
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(), // Disable scrolling within the list
                                      itemCount: limitedRecentlyVisited.length,
                                      itemBuilder: (context, index) {
                                        final item =
                                            limitedRecentlyVisited[index];
                                        return ListTile(
                                          onTap: () {
                                            //go to the community/user's profile screen
                                            Navigator.pop(context);
                                            if (item.type ==
                                                PrefConstants.userType) {
                                              Navigator.pushNamed(context,
                                                  RouteClass.otherUsers,
                                                  arguments: {
                                                    'username': item.username,
                                                  });
                                            } else {
                                              Navigator.pushNamed(context,
                                                  RouteClass.communityScreen,
                                                  arguments: {
                                                    'id': item.username,
                                                    'uid': ref
                                                        .read(userModelProvider)
                                                        ?.id
                                                  });
                                            }
                                          },
                                          leading: item.imageUrl == ""
                                              ? CircleAvatar(
                                                  radius: 15.spMin,
                                                  backgroundImage:
                                                      const AssetImage(Photos
                                                          .profileDefault))
                                              : CircleAvatar(
                                                  radius: 15.spMin,
                                                  backgroundImage: NetworkImage(
                                                      item.imageUrl)),
                                          title: Text(item.username,
                                              maxLines: 1,
                                              style: AppTextStyles
                                                  .primaryTextStyle
                                                  .copyWith(
                                                fontSize: 17.spMin,
                                              )),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (recentlyVisted.isNotEmpty) const Divider(),
                      if (recentlyVisted.isEmpty) SizedBox(height: 30.h),
                      if (ref.read(favouriteList).isNotEmpty)
                        const FavouriteTiles(title: "Favourites"),
                      if (moderatingCommunities.isNotEmpty)
                        const ModeratingTiles(title: "Moderating"),
                      if (userCommunitiesData.isNotEmpty)
                        const CommunitiesTiles(title: "Your Communities"),
                      if (ref
                          .read(userModelProvider)!
                          .followedUsers!
                          .isNotEmpty)
                        const FollowingTiles(title: "Following"),
                    ],
                  ),
      ),
      if (_showSecondDrawer)
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Drawer(
                elevation: double.maxFinite,
                backgroundColor: AppColors.mainColor,
                shadowColor: AppColors.mainColor,
                surfaceTintColor: AppColors.mainColor,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height.h,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 40.h),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.spMin),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              _showSecondDrawer = false;
                                            });
                                          },
                                          child: const Icon(
                                            Icons.arrow_back,
                                            color: Colors.white,
                                          )),
                                      SizedBox(width: 15.spMin),
                                      Text(
                                        'Recently Visited',
                                        style: AppTextStyles.primaryTextStyle
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 60.spMin),
                                      InkWell(
                                        onTap: () async {
                                          await deleteAll();
                                          setState(() {
                                            recentlyVisted = [];
                                            _showSecondDrawer = false;
                                          });
                                        },
                                        child: Text(
                                          'Clear all',
                                          style: AppTextStyles.primaryTextStyle
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.spMin),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  padding: EdgeInsets.all(0.spMin),
                                  shrinkWrap: true,
                                  physics:
                                      const NeverScrollableScrollPhysics(), // Disable scrolling within the list
                                  itemCount: recentlyVisted.length,
                                  itemBuilder: (context, index) {
                                    final item = recentlyVisted[index];
                                    return ListTile(
                                      onTap: () {
                                        //go to the community/user's profile screen
                                        Navigator.pop(context);
                                        if (item.type ==
                                            PrefConstants.userType) {
                                          Navigator.pushNamed(
                                              context, RouteClass.otherUsers,
                                              arguments: {
                                                'username': item.username,
                                              });
                                        } else {
                                          Navigator.pushNamed(context,
                                              RouteClass.communityScreen,
                                              arguments: {
                                                'id': item.username,
                                                'uid': ref
                                                    .read(userModelProvider)
                                                    ?.id
                                              });
                                        }
                                      },
                                      leading: item.imageUrl == ""
                                          ? CircleAvatar(
                                              radius: 15.spMin,
                                              backgroundImage: const AssetImage(
                                                  Photos.profileDefault))
                                          : CircleAvatar(
                                              radius: 15.spMin,
                                              backgroundImage:
                                                  NetworkImage(item.imageUrl)),
                                      title: Text(item.username,
                                          maxLines: 1,
                                          style: AppTextStyles.primaryTextStyle
                                              .copyWith(
                                            fontSize: 17.spMin,
                                          )),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
    ]);
  }
}
