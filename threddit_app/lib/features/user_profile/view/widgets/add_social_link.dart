import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/user_profile/view/widgets/social_form.dart';
import 'package:threddit_clone/features/user_system/view/widgets/interest_button.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class AddSocialLink extends ConsumerWidget {
  const AddSocialLink({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
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
                style: AppTextStyles.boldTextStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
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


// class AddData extends ConsumerWidget {
//   const AddData({super.key, required this.account});
//   final String account;
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     void updateLink(String link) {
//       ref.read(userProfileProvider.notifier).addLink(link);
//     }

//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//             IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: const Icon(Icons.cancel_outlined),
//             ),
//             Text(
//               "Add Social Link",
//               style: AppTextStyles.boldTextStyle,
//             ),
//           ]),
//           Text(account),
//           TextFormField(
//             style: AppTextStyles.primaryTextStyle,
//             decoration: const InputDecoration(
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(16))),
//                 labelText: "https://website.com",
//                 fillColor: Color.fromARGB(255, 38, 38, 38),
//                 filled: true,
//                 floatingLabelBehavior: FloatingLabelBehavior.never,
//                 labelStyle: TextStyle(color: AppColors.whiteHideColor)),
//             maxLength: 30,
//             onChanged: (value) {
//               updateLink(value);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
