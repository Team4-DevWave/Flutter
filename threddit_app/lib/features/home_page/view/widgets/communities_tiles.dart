import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/model/favourite_model.dart';
import 'package:threddit_clone/features/home_page/view_model/favrourite_notifier.dart';
import 'package:threddit_clone/features/home_page/view_model/get_user_communities.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/photos.dart';
import 'package:threddit_clone/theme/text_styles.dart';

/// A [StatefulWidget] that displays a list of communities the user is a member of.
///
/// It fetches the list of communities from the 
/// [userCommunitisProvider] and displays them in an [ExpansionTile].
/// 
/// Each community is represented by a [ListTile] with its icon, name, and a 
/// star icon to indicate if the user has favorited the community.
class CommunitiesTiles extends ConsumerStatefulWidget {
  /// Creates a [CommunitiesTiles] widget.
  ///
  /// The [title] argument is required and specifies the title displayed 
  /// in the [ExpansionTile].
  const CommunitiesTiles({super.key, required this.title});

  /// The title of the [ExpansionTile].
  final String title;

  @override
  ConsumerState<CommunitiesTiles> createState() => _CommunitiesTilesState();
}

/// The state class for the [CommunitiesTiles] widget.
///
/// This class manages the state of the widget, including the list of communities, 
/// loading state, favorite state, and user information. 
class _CommunitiesTilesState extends ConsumerState<CommunitiesTiles> {
  /// The list of communities data. Each sublist contains the community name and icon.
  List<List<String>>? _userCommunitiesData;

  /// Indicates whether the communities data is being loaded. 
  bool isLoading = false;

  /// Indicates whether the favorite star icon is in a loading state.
  bool isStarLoading = false;

  /// The list of the user's favorite communities.
  List<Favourite> favouriteData = [];

  /// The name of the community that the user has pressed the star icon on.
  String pressedOn = "";

  /// The user's information.
  UserModelMe? user; 

  /// Initializes the state of the widget.
  ///
  /// This method calls [_initializeData] to fetch the communities data 
  /// and [_setData] to get the user's favorite communities.
  @override
  void initState() {
    _initializeData();
    _setData();
    super.initState();
  }

  /// Sets the [favouriteData] with the current list of favorites from the state.
  void _setData() {
    favouriteData = ref.read(favouriteList);
  }

  /// Handles the press event on the star icon.
  ///
  /// This method updates the favorite state of the community and 
  /// refreshes the widget.
  Future<void> _onPress(List<String> community) async {
    setState(() {
      isStarLoading = true;
    }); 

    final Favourite favItem = Favourite(
        community[0], PrefConstants.subredditType, community[1]);
    ref.read(favouriteProvider.notifier).updateItem(favItem);

    if (favouriteData.any((item) => item.username == community[0])) {
      await ref.read(favouriteProvider.notifier).removeItem();
    } else {
      await ref.read(favouriteProvider.notifier).addItem();
    }

    setState(() {
      favouriteData = ref.read(favouriteList);
      isStarLoading = false;
    });
  }

  /// Fetches the list of communities from the [userCommunitisProvider].
  ///
  /// This method updates the [_userCommunitiesData] and [isLoading] state 
  /// based on the response.
  Future<void> _initializeData() async {
    setState(() {
      isLoading = true;
    });

    final response = await ref.read(userCommunitisProvider.notifier).getUserCommunities();

    response.fold(
        (failure) => showSnackBar(navigatorKey.currentContext!, failure.message),
        (list) {
      setState(() {
        _userCommunitiesData = list;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Refresh the favorite data from the state
    favouriteData = ref.watch(favouriteList); 

    return ExpansionTile(
      title: Text(
        widget.title,
        style: AppTextStyles.primaryTextStyle,
      ),
      children: [
        // Option to create a new community
        InkWell(
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, RouteClass.createCommunityScreen,
                arguments: ref.read(userModelProvider)?.id);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              children: [
                const Icon(
                  Icons.add, 
                  color: Colors.white,
                ),
                SizedBox(width: 15.w),
                Text(
                  "Create a community",
                  style: AppTextStyles.primaryTextStyle.copyWith(
                    fontSize: 17.spMin,
                  ),
                )
              ],
            ),
          ),
        ),

        // List of communities
        if (!isLoading) ...[
          ..._userCommunitiesData!.map(
            (community) => ListTile(
              onTap: () {
                // Navigate to the community screen
                Navigator.pop(context);
                Navigator.pushNamed(context, RouteClass.communityScreen, 
                    arguments: {
                  'id': community[0], 
                  'uid': ref.read(userModelProvider)?.id
                });
              }, 
              leading: community[1].isEmpty 
                  ? CircleAvatar( 
                      radius: 15.spMin,
                      backgroundImage: 
                          const AssetImage(Photos.communityDefault))
                  : CircleAvatar(
                      radius: 15.spMin, 
                      backgroundImage: NetworkImage(community[1])),
              title: Text(community[0], 
                  maxLines: 1, 
                  style: AppTextStyles.primaryTextStyle.copyWith(
                    fontSize: 17.spMin,
                  )),
              trailing: isStarLoading && pressedOn == community[0]
                  ? CircularProgressIndicator(
                      strokeWidth: 2.w, 
                      color: AppColors.whiteColor,
                    )
                  : IconButton(
                      onPressed: () {
                        pressedOn = community[0];
                        _onPress(community);
                      },
                      icon: favouriteData.any(
                              (item) => item.username == community[0])
                          ? const Icon(
                              Icons.star_rounded,
                              color: AppColors.whiteGlowColor, 
                              size: 24,
                            )
                          : Icon(
                              Icons.star_border_rounded, 
                              size: 24.spMin,
                            ), 
                    ),
            ), 
          ) 
        ]
      ],
    ); 
  }
}