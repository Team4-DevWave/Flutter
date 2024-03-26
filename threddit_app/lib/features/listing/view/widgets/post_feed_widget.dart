import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:threddit_app/theme/text_styles.dart';
import 'package:threddit_app/theme/widget_container_with_radius.dart';

class FeedUnit extends StatefulWidget {
  const FeedUnit({super.key});

  @override
  State<FeedUnit> createState() => _FeedUnitState();
}

class _FeedUnitState extends State<FeedUnit> {
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
                  const Text(
                    "r/Name",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 7.w,
                  ),
                  const Text(
                    "1d",
                    style: TextStyle(color: AppColors.whiteHideColor),
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
          Text(
            "Header",
            style: AppTextStyles.boldTextStyle,
          ),
          Text(
            "Test Test Test Test Test Test Test Test",
            style: AppTextStyles.secondaryTextStyle,
          ),
          Center(
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.backgroundColor),
                  borderRadius:
                      BorderRadius.circular(35) // Adjust the radius as needed
                  ),
              child: Image(
                fit: BoxFit.cover,
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1682685797660-3d847763208e?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
              ),
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
                            onPressed: () {},
                            icon: const Icon(
                              Icons.arrow_upward,
                              color: AppColors.whiteColor,
                            )),
                        Text(
                          "123",
                          style: AppTextStyles.secondaryTextStyle,
                        ),
                        const VerticalDivider(
                          thickness: 1,
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.arrow_downward,
                              color: AppColors.whiteColor,
                            )),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.comment,
                          color: AppColors.whiteColor,
                        ),
                        Text(
                          " 74 Comment",
                          style: TextStyle(color: AppColors.whiteColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Icon(Icons.share, color: AppColors.whiteColor),
            ],
          ),
          const Divider(color: AppColors.whiteHideColor),
        ],
      ),
    );
  }
}
