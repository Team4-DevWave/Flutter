import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/user_profile/view/widgets/social_form.dart';
import 'package:threddit_clone/features/user_system/view/widgets/interest_button.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

/// A widget for adding social links.
///
/// This widget displays a modal bottom sheet for adding social links. It includes
/// buttons for different social media platforms. When a button is tapped, it opens
/// a modal form for adding the link for that specific platform.
class AddSocialLink extends ConsumerWidget {
  const AddSocialLink({super.key});

  /// Opens a modal bottom sheet to add a social link for the specified platform.
  ///
  /// This function is triggered when a button for a social media platform is tapped
  /// in the AddSocialLink widget. It displays a modal form for adding the link
  /// corresponding to the selected platform.
  ///
  /// Parameters:
  ///   - context: The build context.
  ///   - typePressed: The type of social media platform (e.g., "Facebook", "Instagram").
  void onSocialTap(BuildContext context, String typePressed) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0.r)),
      ),
      context: context,
      backgroundColor: AppColors.backgroundColor,
      builder: (ctx) {
        return SocialForm(
          typePressed: typePressed,
          initial: [typePressed, '', ''],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close,
                  size: 30.spMin,
                  color: AppColors.blueColor,
                ),
              ),
              SizedBox(
                width: 50.w,
              ),
              Text(
                "Add Social Link",
                style: AppTextStyles.boldTextStyle.copyWith(fontSize: 16.spMin),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              InterestButton(
                answerText: "Facebook",
                onTap: () => onSocialTap(context, "Facebook"),
                isSelected: false,
              ),
              SizedBox(
                width: 30.h,
              ),
              InterestButton(
                answerText: "Instagram",
                onTap: () => onSocialTap(context, "Instagram"),
                isSelected: false,
              ),
              SizedBox(
                width: 30.h,
              ),
              InterestButton(
                answerText: "Twitter",
                onTap: () => onSocialTap(context, "Twitter"),
                isSelected: false,
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              InterestButton(
                answerText: "Reddit",
                onTap: () => onSocialTap(context, "Reddit"),
                isSelected: false,
              ),
              SizedBox(
                width: 35.h,
              ),
              InterestButton(
                answerText: "Discord",
                onTap: () => onSocialTap(context, "Discord"),
                isSelected: false,
              ),
              SizedBox(
                width: 35.h,
              ),
              InterestButton(
                answerText: "Spotify",
                onTap: () => onSocialTap(context, "Spotify"),
                isSelected: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
