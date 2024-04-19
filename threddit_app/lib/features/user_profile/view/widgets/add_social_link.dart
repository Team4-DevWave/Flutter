import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/user_system/view/widgets/interest_button.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class AddSocialLink extends ConsumerWidget {
  const AddSocialLink({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
    mainAxisSize: MainAxisSize.min,
      children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start, // Align button to the far left
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.cancel_outlined),
          ),
          SizedBox(width: 50.w,),
          Text(
        "Add Social Link",
        style: AppTextStyles.boldTextStyle,
        textAlign: TextAlign.center, // Center the title text
      ),
        ],
      ),
      SizedBox(height: 16.h), // Add some space between the title and buttons
      Row(
        children: [
          InterestButton(
            answerText: "Facebook",
            onTap: () {},
            isSelected: true,
          ),
          SizedBox(width: 30.h,),
          InterestButton(
            answerText: "Instagram",
            onTap: () {},
            isSelected: true,
          ),
          SizedBox(width: 30.h,),
          InterestButton(
            answerText: "Twitter",
            onTap: () {},
            isSelected: true,
          ),
        ],
      ),
      SizedBox(height: 10.h,),
      Row(
        children: [
          InterestButton(
            answerText: "Reddit",
            onTap: () {},
            isSelected: true,
          ),
          SizedBox(width: 35.h,),
           InterestButton(
            answerText: "Discord",
            onTap: () {},
            isSelected: true,
          ),
          SizedBox(width: 35.h,),
           InterestButton(
            answerText: "Spotify",
            onTap: () {},
            isSelected: true,
          ),
        ],
      ),
    ],
  ),
);
  }}


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
