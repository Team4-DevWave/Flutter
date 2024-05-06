import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class EditLink extends ConsumerStatefulWidget {
  const EditLink(this.onInsert, {super.key});

  final Function(String, String) onInsert;

  @override
  ConsumerState<EditLink> createState() => _EditLinkState();
}

class _EditLinkState extends ConsumerState<EditLink> {
  bool _isValid = false;
  String nameValue = "";
  String linkValue = "";

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                  builder: (context, setState) => AlertDialog(
                        contentPadding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0.r),
                        ),
                        backgroundColor: Colors.transparent,
                        content: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(16.0.spMin),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0.r),
                            color: AppColors.backgroundColor,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Inset a link",
                                style: AppTextStyles.primaryButtonGlowTextStyle,
                              ),
                              SizedBox(height: 16.0.h),
                              TextFormField(
                                onChanged: (value) {
                                  nameValue = value;
                                  setState(() {
                                    _isValid = nameValue.trim().isNotEmpty &&
                                        linkValue.trim().isNotEmpty;
                                  });
                                },
                                cursorColor: AppColors.blueColor,
                                style: AppTextStyles.primaryTextStyle,
                                decoration: InputDecoration(
                                  hintText: "Name",
                                  hintStyle: AppTextStyles.primaryTextStyle
                                      .copyWith(
                                          color: AppColors.whiteHideColor,
                                          fontWeight: FontWeight.bold),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 5.0.h, horizontal: 12.0.w),
                                  counter: const SizedBox.shrink(),
                                  border: InputBorder.none,
                                ),
                              ),
                              SizedBox(height: 16.0.h),
                              TextFormField(
                                onChanged: (value) {
                                  linkValue = value;
                                  setState(() {
                                    _isValid = nameValue.trim().isNotEmpty &&
                                        linkValue.trim().isNotEmpty;
                                  });
                                },
                                cursorColor: AppColors.blueColor,
                                style: AppTextStyles.primaryTextStyle,
                                decoration: InputDecoration(
                                  hintText: "Link",
                                  hintStyle: AppTextStyles.primaryTextStyle
                                      .copyWith(
                                          color: AppColors.whiteHideColor,
                                          fontWeight: FontWeight.bold),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 5.0.h, horizontal: 12.0.w),
                                  counter: const SizedBox.shrink(),
                                  border: InputBorder.none,
                                ),
                              ),
                              SizedBox(height: 16.0.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      _isValid = false;
                                      nameValue = '';
                                      linkValue = '';
                                      this.setState(() {});
                                      Navigator.pop(context);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.transparent),
                                    ),
                                    child: Text(
                                      "Cancel",
                                      style: AppTextStyles.buttonTextStyle
                                          .copyWith(
                                              color: AppColors.whiteHideColor),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: _isValid
                                        ? () {
                                            widget.onInsert(
                                                nameValue, linkValue);
                                            _isValid = false;
                                            Navigator.pop(context);
                                          }
                                        : null,
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              AppColors.blueColor),
                                    ),
                                    child: Text(
                                      "Insert",
                                      style: AppTextStyles.buttonTextStyle
                                          .copyWith(
                                              color: _isValid
                                                  ? AppColors.whiteGlowColor
                                                  : AppColors.whiteColor),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ));
            },
          );
        },
        icon: const Icon(CupertinoIcons.link, color: AppColors.whiteHideColor));
  }
}
