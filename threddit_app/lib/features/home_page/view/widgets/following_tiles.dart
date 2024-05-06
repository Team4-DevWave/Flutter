import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class FollowingTiles extends ConsumerStatefulWidget {
  const FollowingTiles({super.key, required this.title});
  final String title;
  @override
  ConsumerState<FollowingTiles> createState() => _FollowingTilesState();
}

class _FollowingTilesState extends ConsumerState<FollowingTiles> {
  final List<String> _followingList = [];
  bool isLoading = false;
  UserModelMe? user;

  void _getUserData() async {
    user = ref.read(userModelProvider)!;
  }

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      isLoading = true;
    });
    if (user != null && user!.followedUsers != null) {
      for (var followedUser in user!.followedUsers!) {
        String username = followedUser['username'];
        _followingList.add(username);
      }
    }
    print("FFFFFFFFFFFFFFFFFMMMMMMMMMMMLLLLLLLLLLLLLLLLLLLLL");
    print(_followingList);
    isLoading = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return  ExpansionTile(
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
                        arguments: {
                          'username': followed,
                        });
                  },
                  leading: const CircleAvatar(
                    radius: 10,
                    //backgroundImage: NetworkImage(community[1]),
                    backgroundImage: AssetImage('assets/images/Default_Avatar.png'),
                  ),
                  title: Text(followed,
                      maxLines: 1,
                      style: AppTextStyles.primaryTextStyle.copyWith(
                        fontSize: 17.spMin,
                      )),
                ))
        ]);
  }
  }

