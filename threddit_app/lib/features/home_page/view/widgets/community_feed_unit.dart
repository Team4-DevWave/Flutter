import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/community/view%20model/community_provider.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/models/subreddit.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class CommunityUnit extends ConsumerStatefulWidget {
  final List<Subreddit> subreddit;
  final String userID;
  const CommunityUnit(
      {super.key, required this.subreddit, required this.userID});

  @override
  ConsumerState<CommunityUnit> createState() => _CommunityUnitState();
}

class _CommunityUnitState extends ConsumerState<CommunityUnit> {
  ImageProvider setCommunityImage(Subreddit sub) {
    if (sub.srLooks.icon != '') {
      return NetworkImage(sub.srLooks.icon);
    } else {
      return const NetworkImage(
          "https://st2.depositphotos.com/1432405/8410/v/450/depositphotos_84106432-stock-illustration-saturn-icon-simple.jpg");
    }
  }

  @override
  Widget build(BuildContext context) {
    String username = ref.read(userModelProvider)!.username!;
    final newUser = UserModel(id: widget.userID, username: username);

    return SizedBox(
      height: Platform.isAndroid?170.h:190.h,
      child: GridView.builder(
          scrollDirection: Axis.horizontal,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: Platform.isAndroid?0.3.spMin: 0.2.spMin,
              mainAxisSpacing: 10.w,
              crossAxisSpacing: 5.h),
          itemCount: widget.subreddit.length,
          itemBuilder: (context, index) {
            bool isCurrentUser =
                widget.subreddit[index].members.contains(newUser);
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, RouteClass.communityScreen,
                    arguments: {
                      'id': widget.subreddit[index].name,
                      'uid': widget.userID
                    });
              },
              child: Container(
                width: 300.w,
                decoration: BoxDecoration(
                  border: Border.all(
                      style: BorderStyle.solid,
                      color: AppColors.whiteHideColor),
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 20.r,
                                backgroundImage:
                                    setCommunityImage(widget.subreddit[index]),
                              ),
                              SizedBox(
                                width: 15.w,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.subreddit[index].name,
                                      style: AppTextStyles
                                          .primaryButtonGlowTextStyle),
                                  Text(
                                    "${widget.subreddit[index].members.length} members",
                                    style: AppTextStyles
                                        .primaryButtonHideTextStyle
                                        .copyWith(fontSize: 14.spMin),
                                  )
                                ],
                              ),
                            ],
                          ),
                          ElevatedButton(
                              onPressed: () {
                                if (!isCurrentUser) {
                                  ref.watch(joinCommunityProvider(
                                      widget.subreddit[index].name));
                                  widget.subreddit[index].members.add(newUser);
                                  isCurrentUser = true;
                                  setState(() {});
                                } else {
                                  ref.watch(unjoinCommunityProvider(
                                      widget.subreddit[index].name));
                                  widget.subreddit[index].members
                                      .remove(newUser);
                                  isCurrentUser = false;

                                  setState(() {});
                                }
                              },
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(255, 0, 69, 172)),
                              ),
                              child: Text(
                                isCurrentUser ? 'Joined' : 'Join',
                                style: AppTextStyles.primaryButtonGlowTextStyle
                                    .copyWith(fontSize: 14.spMin),
                              ))
                        ],
                      ),
                      Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        widget.subreddit[index].status,
                        style: AppTextStyles.primaryButtonHideTextStyle
                            .copyWith(fontSize: 14.spMin),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
