import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/features/listing/view/widgets/widget_container_with_radius.dart';

class FeedUnit extends StatefulWidget {
  final Map<String, dynamic> dataOfPost;
  // ignore: lines_longer_than_80_chars
  const FeedUnit(this.dataOfPost, {super.key});

  @override
  State<FeedUnit> createState() => _FeedUnitState();
}

class _FeedUnitState extends State<FeedUnit> {
  late int numbberOfvotes;
  int choiceBottum = -1; // 1 upvote 2 downvote

  @override
  void initState() {
    super.initState();
    numbberOfvotes = int.parse(widget.dataOfPost['votes'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, RouteClass.communityScreen,
                          arguments: ["1", "mod2"]);
                    },
                    child: Text(
                      'r/${widget.dataOfPost['username']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 7.w,
                  ),
                  Text(
                    widget.dataOfPost['time'],
                    style: const TextStyle(color: AppColors.whiteHideColor),
                  ),
                ],
              )),
              InkWell(
                onTap: () {},
                child: const Icon(
                  Icons.more_vert,
                  color: AppColors.whiteHideColor,
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.dataOfPost['header'],
                  style: AppTextStyles.boldTextStyle,
                ),
                Text(
                  widget.dataOfPost['container'],
                  style: AppTextStyles.secondaryTextStyle,
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.backgroundColor),
                  borderRadius:
                      BorderRadius.circular(35) // Adjust the radius as needed
                  ),
              child: (widget.dataOfPost['imageLink'] != null)
                  ? Image(
                      height: 250.h,
                      width: 360.w,
                      fit: BoxFit.fitWidth,
                      image: NetworkImage(widget.dataOfPost['imageLink']
                          //'https://images.unsplash.com/photo-1682685797660-3d847763208e?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
                          ),
                    )
                  : const SizedBox(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  AddRadiusBoarder(
                    childWidget: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              if (choiceBottum == -1 || choiceBottum == 2) {
                                setState(() {
                                  if (numbberOfvotes ==
                                      int.parse(widget.dataOfPost['votes']
                                              .toString()) -
                                          1) {
                                    numbberOfvotes += 2;
                                  } else {
                                    numbberOfvotes++;
                                  }
                                  choiceBottum = 1;
                                });
                              }
                            },
                            icon: Icon(
                              Icons.arrow_upward,
                              color: (choiceBottum == 1)
                                  ? AppColors.redditOrangeColor
                                  : AppColors.whiteColor,
                            )),
                        Text(
                          numbberOfvotes.toString(),
                          style: AppTextStyles.secondaryTextStyle,
                        ),
                        const VerticalDivider(
                          thickness: 1,
                        ),
                        IconButton(
                            onPressed: () {
                              if (choiceBottum == -1 || choiceBottum == 1) {
                                setState(() {
                                  if (numbberOfvotes ==
                                      int.parse(widget.dataOfPost['votes']
                                              .toString()) +
                                          1) {
                                    numbberOfvotes -= 2;
                                  } else {
                                    numbberOfvotes--;
                                  }
                                  choiceBottum = 2;
                                });
                              }
                            },
                            icon: Icon(
                              Icons.arrow_downward,
                              color: (choiceBottum == 2)
                                  ? AppColors.redditOrangeColor
                                  : AppColors.whiteColor,
                            )),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.comment,
                          color: AppColors.whiteColor,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          widget.dataOfPost['numberOfComments'].toString(),
                          style: const TextStyle(color: AppColors.whiteColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Icon(Icons.share, color: AppColors.whiteColor),
            ],
          ),
          const Divider(color: AppColors.whiteHideColor),
        ],
      ),
    );
  }
}
