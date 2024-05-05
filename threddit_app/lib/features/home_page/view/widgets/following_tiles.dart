import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_profile/models/other_user_data.dart';
import 'package:threddit_clone/features/user_profile/view_model/get_user.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/theme/theme.dart';

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

  void _getUserData() async {
    user = ref.watch(userModelProvider)!;
    print("UUUUUUUUUUUUUUUUUUUUUUUUUUUUU");
    print(user!.followedUsers);
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getOtherUserData(String username) async {
    final res = await ref.watch(getUserProvider.notifier).getUser(username);
    res.fold((l) => showSnackBar(navigatorKey.currentContext!, l.message), (r) {
      someone = r;
    });
  }

  @override
  void didChangeDependencies() async {
    setState(() {
      isLoading = true;
    });
    _getUserData();
    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    print(user!.followedUsers);
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
      print("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF");
      print(_followingList);
    }                   
    setState(() {
      isLoading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider putProfilepic(String pfpLink) {
      if (pfpLink == "") {
        return const AssetImage('assets/images/Default_Avatar.png');
      } else {
        return NetworkImage(pfpLink);
      }
    }

    return isLoading
        ? const Loading()
        : ExpansionTile(
            title: Text(
              widget.title,
              style: AppTextStyles.primaryTextStyle,
            ),
            children: [
                if (!isLoading)
                  ..._followingList.map((followed) => ListTile(
                        onTap: () {
                          ///go to the user's profile screen
                          Navigator.pushNamed(context, RouteClass.otherUsers,
                              arguments: <String, dynamic>{
                                'username': followed['username'].toString(),
                              }).then((value) {
                            setState(() {
                              isLoading = true;
                            });

                            _followingList =
                                ref.watch(userModelProvider)!.followedUsers!;

                            setState(() {
                              isLoading = false;
                            });
                            
                          });
                        },
                        leading: CircleAvatar(
                            radius: 15,
                            backgroundImage:
                                putProfilepic(followed['profilePicture']!)),
                        title: Text(followed['username']!,
                            maxLines: 1,
                            style: AppTextStyles.primaryTextStyle.copyWith(
                              fontSize: 17.spMin,
                            )),
                      ))
                else
                  const Loading(),
              ]);
  }
}
