import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/messaging/view/widgets/new_message_bottom_sheet.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';


class NoInbox extends StatelessWidget {
  const NoInbox({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
            height: 150.h,
            width: 150.w,
            image:
                const AssetImage('assets/images/snoovatar-full-hi.png')),
        SizedBox(
          height: 10.h,
        ),
        Text(
          'Wow such empty!',
          style: AppTextStyles.boldTextStyle,
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          key: const Key('fortest'),
          "Start Messaging?",
          style: AppTextStyles.secondaryTextStyle,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.h,),
        FilledButton(onPressed: (){
           showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              scrollControlDisabledMaxHeightRatio: double.infinity,
              backgroundColor: const Color.fromARGB(255, 7, 7, 7),
              builder: (context) {
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: const NewMessage(),
                );
              },
            );
        },style: FilledButton.styleFrom(backgroundColor: AppColors.redditOrangeColor,), child: const Text("New Message",style:TextStyle(color: Colors.white),)
        ),
      ],
    ));
  }
}
