import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/model/favourite_model.dart';
import 'package:threddit_clone/features/home_page/view_model/favrourite_notifier.dart';
import 'package:threddit_clone/features/user_profile/models/other_user_data.dart';
import 'package:threddit_clone/features/user_profile/view_model/get_user.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class FollowingTiles extends ConsumerStatefulWidget {
  const FollowingTiles({super.key, required this.title});
  final String title;
  @override
  ConsumerState<FollowingTiles> createState() => _FollowingTilesState();
}

class _FollowingTilesState extends ConsumerState<FollowingTiles> {
  List<Map<String, dynamic>> _followingList = [];
  bool isLoading = false;
  UserModelMe? user;
  UserModelNotMe? someone;
  bool isStarLoading = false;
  List<Favourite> favouriteData = [];
  String pressedOn = "";
  bool initialState = false;

  Future<void> _getUserData() async {
    setState(() {
      isLoading = true;
    });
    await ref.read(settingsFetchProvider.notifier).getMe();
    user = ref.read(userModelProvider)!;
    _followingList = [];
    if (user != null && user!.followedUsers != null) {
      for (var followedUser in user!.followedUsers!) {
        String username = followedUser['username'];
        await _getOtherUserData(username);
        String otherpfp = someone?.profilePicture ?? "";
        // Create a Map for each user with username and profile picture
        Map<String, String> userMap = {
          'username': username,
          'profilePicture': otherpfp,
        };
        _followingList.add(userMap);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _onPress(String username) async {
    setState(() {
      isStarLoading = true;
    });

    final Favourite favItem = Favourite(username, PrefConstants.userType, '');
    ref.read(favouriteProvider.notifier).updateItem(favItem);

    if (favouriteData.any((item) => item.username == username)) {
      await ref.read(favouriteProvider.notifier).removeItem();
    } else {
      await ref.read(favouriteProvider.notifier).addItem();
    }

    setState(() {
      favouriteData = ref.read(favouriteList);
      isStarLoading = false;
    });
  }

  void _setData() {
    favouriteData = ref.read(favouriteList);
  }

  @override
  void initState() {
    _setData();
    _getUserData();
    super.initState();
  }

  Future<void> _getOtherUserData(String username) async {
    final res = await ref.read(getUserProvider.notifier).getUser(username);
    res.fold((l) => showSnackBar(navigatorKey.currentContext!, l.message), (r) {
      someone = r;
    });
  }

  @override
  Widget build(BuildContext context) {
    favouriteData = ref.watch(favouriteList);
    // initialState = ref.read(followingStateProvider) ?? false;

    ImageProvider putProfilepic(String pfpLink) {
      if (pfpLink == "") {
        return const AssetImage('assets/images/Default_Avatar.png');
      } else {
        return NetworkImage(pfpLink);
      }
    }

    return ExpansionTile(
        // initiallyExpanded: ref.read(followingStateProvider) ?? false,
        // onExpansionChanged: (value) async {
        //   print(initialState);
        //   print("DDDDDDDDDD$value");
        //   await saveCommunitiesState(value);
        //   setState(() {
        //     initialState = value;
        //   });
        // },
        title: Text(
          widget.title,
          style: AppTextStyles.primaryTextStyle,
        ),
        children: [
          if (!isLoading)
            ..._followingList.map((followed) => ListTile(
                  onTap: () {
                    //go to the user's profile screen
                    Navigator.pushNamed(context, RouteClass.otherUsers,
                        arguments: <String, dynamic>{
                          'username': followed['username'].toString(),
                        }).then((value) {
                      Navigator.pop(context);
                    });
                  },
                  leading: CircleAvatar(
                      radius: 15.spMin,
                      backgroundImage:
                          putProfilepic(followed['profilePicture']!)),
                  title: Text(followed['username']!,
                      maxLines: 1,
                      style: AppTextStyles.primaryTextStyle.copyWith(
                        fontSize: 17.spMin,
                      )),
                  trailing: isStarLoading && pressedOn == followed['username']!
                      ? CircularProgressIndicator(
                          strokeWidth: 2.w,
                          color: AppColors.whiteColor,
                        )
                      : IconButton(
                          onPressed: () {
                            pressedOn = followed['username']!;
                            _onPress(followed['username']!);
                          },
                          icon: favouriteData.any((item) =>
                                  item.username == followed['username']!)
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
                ))
          else
            const CircularProgressIndicator(
              color: Color.fromARGB(0, 255, 255, 255),
            ),
        ]);
  }
}
