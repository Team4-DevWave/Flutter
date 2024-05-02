import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_profile/view_model/follow_user.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class SearchUserUnit extends StatefulWidget {
  final UserModelMe user;
  bool isFollowed;
  SearchUserUnit({super.key, required this.user, required this.isFollowed});

  @override
  State<SearchUserUnit> createState() => _SearchUserUnitState();
}

class _SearchUserUnitState extends State<SearchUserUnit> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
      child: Column(
        children: [
          ListTile(
            onTap: () => Navigator.pushNamed(
              context,
              RouteClass.otherUsers,
              arguments: widget.user.username,
            ),
            title: Text("u/${widget.user.username!}",
                style: AppTextStyles.primaryButtonGlowTextStyle),
            trailing: Container(
              decoration: BoxDecoration(
                color: AppColors.redColor,
                borderRadius:
                    BorderRadius.circular(40), // Adjust the radius as needed
              ),
              child: widget.isFollowed
                  ? TextButton(
                      onPressed: () async {
                        await unfollowUser(widget.user.username!);
                        setState(() {
                          widget.isFollowed = !widget.isFollowed;
                        });
                      },
                      child: Text(
                        "Unfollow",
                        style: AppTextStyles.primaryButtonGlowTextStyle,
                      ))
                  : TextButton(
                      onPressed: () async {
                        print(widget.user.username!);
                        await followUser(widget.user.username!);

                        setState(() {
                          widget.isFollowed = !widget.isFollowed;
                        });
                      },
                      child: Text(
                        "Follow",
                        style: AppTextStyles.primaryButtonGlowTextStyle,
                      )),
            ),
          ),
          SizedBox(height: 5.h,),
          const Divider(
            color: Color.fromRGBO(233, 93, 95, 0.573),
            thickness: 1,
          )
        ],
      ),
    );
  }
}
