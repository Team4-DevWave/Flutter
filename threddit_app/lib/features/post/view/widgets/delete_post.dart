import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/features/post/viewmodel/delete_post.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

void delete(BuildContext context, WidgetRef ref, String postid) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        surfaceTintColor: AppColors.backgroundColor,
        backgroundColor: AppColors.backgroundColor,
        actionsAlignment: MainAxisAlignment.spaceBetween,
        shadowColor: AppColors.backgroundColor,
        content: SizedBox(
          height: 100.h,
          child: Column(
            children: [
              Text(
                "Are you sure?",
                style: AppTextStyles.primaryButtonGlowTextStyle,
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                "You cannot restore posts that have been deleted.",
                style: AppTextStyles.primaryButtonGlowTextStyle,
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Colors.transparent)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel",
                  style: AppTextStyles.buttonTextStyle
                      .copyWith(color: AppColors.whiteColor))),
          ElevatedButton(
            onPressed: () async {
              final response = await ref
                  .watch(deletePostProvider.notifier)
                  .deletePostRequest(postid);
              response.fold((failure) {
                showSnackBar(navigatorKey.currentContext!, failure.message);
                // Navigator.pop(context);
              }, (success) {
                showSnackBar(navigatorKey.currentContext!,
                    'Your post deleted to succefully');
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              });
            },
            style: const ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(AppColors.errorColor)),
            child: Text(
              "Delete",
              style: AppTextStyles.buttonTextStyle,
            ),
          ),
        ],
      );
    },
  );
}
