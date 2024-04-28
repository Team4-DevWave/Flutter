import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/models/subreddit.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class SearchUserUnit extends StatefulWidget {
  final UserModelMe user;
  SearchUserUnit({super.key, required this.user});

  @override
  State<SearchUserUnit> createState() => _SearchUserUnitState();
}

class _SearchUserUnitState extends State<SearchUserUnit> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 15.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("u/${widget.user.username!}",
                          style: AppTextStyles.primaryButtonGlowTextStyle),
                    ],
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.redColor,
                  borderRadius:
                      BorderRadius.circular(40), // Adjust the radius as needed
                ),
                child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Follow",
                      style: AppTextStyles.primaryButtonGlowTextStyle,
                    )),
              )
            ],
          ),
          SizedBox(height: 10.h),
          Divider(
            color: Color.fromRGBO(233, 93, 95, 0.573),
            thickness: 1,
          )
        ],
      ),
    );
  }
}
