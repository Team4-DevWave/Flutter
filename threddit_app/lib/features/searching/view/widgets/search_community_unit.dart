import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/models/subreddit.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class SearchCommunityUnit extends StatefulWidget {
  final Subreddit subreddit;
  final String userID;
  const SearchCommunityUnit({super.key, required this.subreddit, required this.userID});

  @override
  State<SearchCommunityUnit> createState() => _SearchCommunityUnitState();
}

class _SearchCommunityUnitState extends State<SearchCommunityUnit> {
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
                  ClipOval(
                    child: widget.subreddit.srLooks.icon != ''
                        ? Image.network(
                            widget.subreddit.srLooks.icon,

                            fit: BoxFit.cover,
                            width: 45
                                .w, // You can adjust width and height to your needs
                            height: 45.h,
                          )
                        : SizedBox(
                            width: 45,
                            height: 45.h,
                            child: Image.asset(
                              'assets/images/Reddit_Icon_FullColor.png',
                            ),
                          ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.subreddit.name,
                          style: AppTextStyles.primaryButtonGlowTextStyle),
                      Text(
                        "${widget.subreddit.members.length} members",
                        style: AppTextStyles.secondaryTextStyle,
                      )
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
                    onPressed: () {
                      Navigator.pushNamed(context, RouteClass.communityScreen,
                          arguments: {
                            'id': widget.subreddit.name,
                            'uid': widget.userID
                          });
                    },
                    child: Text(
                      "Visit",
                      style: AppTextStyles.primaryButtonGlowTextStyle,
                    )),
              )
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.only(left: 60.w),
            child: Text(
              maxLines: 2,
              widget.subreddit.status,
              style: AppTextStyles.secondaryTextStyle,
            ),
          ),
          const Divider(
            color: Color.fromRGBO(233, 93, 95, 0.573),
            thickness: 1,
          )
        ],
      ),
    );
  }
}
