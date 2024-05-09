import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/theme/text_styles.dart';


class EmptyChats extends StatelessWidget {
  
  const EmptyChats({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            child: Image(
                height: 150.h,
                width: 150.w,
                image:
                    const AssetImage('assets/images/snoovatar-full-hi.png'))),
        SizedBox(
          height: 10.h,
        ),
        Text(
          'You don\'t have any open chatrooms',
          style: AppTextStyles.boldTextStyle,
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          key: const Key('fortest'),
          "don't miss out and start chatting right away!",
          style: AppTextStyles.secondaryTextStyle,
          textAlign: TextAlign.center,
        ),
       
      ],
    ));
  }
}
